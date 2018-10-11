//
//  DriverModelController.swift
//  Framework Demo
//
//  Created by James Coleman on 07/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import Moya
import RxMoya
import RxOptional

struct DriverModelController {
    private let bag = DisposeBag()
    private let realm = try! Realm()
    
    private let provider = MoyaProvider<WikiAPI>(
        plugins: [NetworkLoggerPlugin(verbose: false)] // Verbose logging includes the full response. Otherwise logging just includes the headers.
    )
    
    public func checkImage(driver: Driver) throws {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        let fileUrl = documentDirectory.appendingPathComponent(driver.imageName)
        let filePath = fileUrl.path
        
        if FileManager.default.fileExists(atPath: filePath) {
            try realm.write {
                driver.imageLoaded = true
            }
        } else {
            try getImage(driver: driver)
        }
    }
    
    private func getImage(driver: Driver) throws {
        let articleName = try driver.wikipediaArticleName()
        
        guard let articleNameDecoded = articleName.removingPercentEncoding else { throw WikipediaError.cannotRemovePercentEncoding(from: articleName) }
        
        wikimediaImageName(of: articleNameDecoded)
            .flatMap(wikimediaCommonsImage)
            .map { (image) -> Data in
                guard let data = image.jpegData(compressionQuality: 0.8) else { throw WikipediaError.cannotGetDataFromImage }
                
                return data
            }
            .map { (data) -> String in
                return try FileManager.default.save(pictureData: data, as: driver.imageName)
            }
            .subscribe(onNext: { (_) in
                try? self.realm.write {
                    driver.imageLoaded = true
                }}, onError: {(error) in
                    print(error) // This doesn't appear able to throw? Must be included in rx?
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
    
    private enum WikipediaError: Error {
        case cannotCast
        case noPageImage
        case cannotParseImage
        case incorrectSplitCount(splitString: String, shouldBeAtLeast: Int, isActually: Int)
        case cannotGetDataFromImage
        case cannotRemovePercentEncoding(from: String)
    }
    
    /**
     Returns the address of the main image used in a Wikipedia article (if
     there is one)
     
     - parameters:
     - page: The name of the Wikipedia article to find the main image of.
     
     - throws:
     Is not marked as `throws` but the rx components can throw a
     `WikipediaError`
     
     - returns:
     The address of the image as an `Observable<String>`
     */
    private func wikimediaImageName(of page: String) -> Observable<String> {
        return provider.rx.request(.getImageUrls(title: page))
            .asObservable()
            .mapJSON()
            .map({ (json) -> String in
                guard
                    let json = json as? [String: Any],
                    let query = json["query"] as? [String: Any],
                    let pages = query["pages"] as? [String: Any]
                    else { throw WikipediaError.cannotCast }
                
                for (_, value) in pages {
                    guard
                        let value = value as? [String: Any],
                        let thumbnail = value["thumbnail"] as? [String: Any],
                        let source = thumbnail["source"] as? String
                        else { throw WikipediaError.noPageImage }
                    
                    let splitOnThumb = source.components(separatedBy: "/thumb")
                    
                    guard splitOnThumb.count > 1 else { throw WikipediaError.incorrectSplitCount(splitString: "/thumb", shouldBeAtLeast: 2, isActually: splitOnThumb.count) }
                    
                    let splitOnJpg = splitOnThumb[1].components(separatedBy:
                        ".jpg")
                    
                    guard splitOnJpg.isNotEmpty else { throw WikipediaError.incorrectSplitCount(splitString: ".jpg", shouldBeAtLeast: 1, isActually: splitOnJpg.count) }
                    
                    return "\(splitOnJpg[0]).jpg"
                }
                
                throw WikipediaError.noPageImage // This is required in case there is a pages object but it has no values in it and therefore the loop doesn't get a chance to run
            })
    }
    
    /**
     Returns an observable of the image of the url specified
     Currenty defaults to Wikimedia commons but this would be the structure for all such image requests
     
     - parameters:
     - url: The url of the image to download
     
     - returns:
     The image of the url specified
     */
    private func wikimediaCommonsImage(from url: String) throws -> Observable<UIImage> {
        guard let urlDecoded = url.removingPercentEncoding else { throw WikipediaError.cannotRemovePercentEncoding(from: url) }
        
        return provider.rx.request(.downloadImage(url: urlDecoded))
            .asObservable()
            .mapImage()
            .filterNil()
    }
}
