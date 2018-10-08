//
//  File Manager Extensions.swift
//  Framework Demo
//
//  Created by James Coleman on 07/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation

extension FileManager {
    /**
     Saves picture data to the `.picturesDirectory` and returns the path that it was saved to. Uses a UUID as the file name
     
     - thows:
     Propegates the `Data.write(to:)` error
     
     - returns:
     
    */
    func save(pictureData: Data) throws -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let picturesDirectory = paths[0]
        
        let uuid = UUID().uuidString
        let filename = "\(uuid).jpg"
        let filepath = picturesDirectory.appendingPathComponent(filename)
        
        try pictureData.write(to: filepath)
        
        return filename
    }
}