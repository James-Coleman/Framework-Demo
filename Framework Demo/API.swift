//
//  API.swift
//  Framework Demo
//
//  Created by James Coleman on 27/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//


import Moya
import RxMoya

enum ErgastAPI {
    case getCurrentSeason
    case get(year: String, round: String)
}

extension ErgastAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://ergast.com/api/f1")!
    }
    
    var path: String {
        var start: String {
            switch self {
            case .getCurrentSeason:
                return "/current"
            case let .get(year, round):
                return "/\(year)/\(round)/results"
            }
        }
        return start + ".json" // This tells the api to return json, otherwise it will return xml by default
    }
    
    var method: Moya.Method {
        return .get // All methods are currently .get
    }
    
    var sampleData: Data {
        // TODO: Add actual sample data
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        return .requestPlain // All methods are currently plain (no parameters are passed in)
    }
    
    var headers: [String : String]? {
        return nil // No headers are necessary
    }
}
