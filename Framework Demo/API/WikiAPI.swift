//
//  WikiAPI.swift
//  Framework Demo
//
//  Created by James Coleman on 06/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Moya

enum WikiAPI {
    case getImageUrls(title: String)
    case downloadImage(url: String)
}

extension WikiAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .getImageUrls:
            return URL(string: "https://en.wikipedia.org")!
        case .downloadImage:
            return URL(string: "https://upload.wikimedia.org")!
        }
    }
    
    var path: String {
        switch self {
        case .getImageUrls:
            return "/w/api.php"
        case let .downloadImage(url):
            return "/wikipedia/commons\(url)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        var string: String {
            switch self {
            case .getImageUrls:
                return """
                {
                "batchcomplete": "",
                "query": {
                "normalized": [
                {
                "from": "Fernando_Alonso",
                "to": "Fernando Alonso"
                }
                ],
                "pages": {
                "240390": {
                "pageid": 240390,
                "ns": 0,
                "title": "Fernando Alonso",
                "thumbnail": {
                "source": "
                https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Alonso_2016.jpg/40px-Alonso_2016.jpg
                ",
                "width": 40,
                "height": 50
                },
                "pageimage": "Alonso_2016.jpg"
                }
                }
                }
                }
                """
            case .downloadImage:
                return ""
            }
        }
        return string.data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .getImageUrls(title):
            return .requestParameters(parameters: ["action":"query", "prop":
                "pageimages","format":"json", "titles":title], encoding: URLEncoding.default
            )
        case .downloadImage:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
