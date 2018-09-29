//
//  Model.swift
//  Framework Demo
//
//  Created by James Coleman on 27/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Result: Object, Decodable {
    @objc dynamic var number       : String = ""
    @objc dynamic var position     : String = ""
    @objc dynamic var positionText : String = ""
    @objc dynamic var points       : String = ""
    @objc dynamic var grid         : String = ""
    @objc dynamic var laps         : String = ""
    @objc dynamic var status       : String = ""
    
    let race = LinkingObjects(fromType: Race.self, property: "results")
    
    private enum CodingKeys: String, CodingKey {
        
        case number, position, positionText, points, grid, laps, status
    }
    
    // Could you use the init to reach into the race LinkedObject, pull out the season and round, and then combine that with the number of the result to create a unique id for each result?
}

class Race: Object, Decodable {
    @objc dynamic var season    : String = ""
    @objc dynamic var round     : String = ""
    @objc dynamic var stringUrl : String = ""
    @objc dynamic var raceName  : String = ""
    @objc dynamic var date      : String = ""
    @objc dynamic var time      : String = ""
    @objc dynamic var id        : String = ""
    
    //    @objc dynamic var circuit: Circuit?
    let results = List<Result>()
    
    var url: URL? { return URL(string: stringUrl) }
    var dateTime: String { return "\(date)T\(time)" }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case stringUrl = "url"
        //        case circuit   = "Circuit"
        case results   = "Results"
        
        case season, round, raceName, date, time
    }
    
    // This convenience init exists in order to decode the array of Results
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let season = try container.decode(String.self, forKey: .season)
        self.season = season
        
        let round = try container.decode(String.self, forKey: .round)
        self.round = round
        
        let stringUrl = try container.decode(String.self, forKey: .stringUrl)
        self.stringUrl = stringUrl
        
        let raceName = try container.decode(String.self, forKey: .raceName)
        self.raceName = raceName
        
        let date = try container.decode(String.self, forKey: .date)
        self.date = date
        
        let time = try container.decode(String.self, forKey: .time)
        self.time = time
        
        self.id = "\(season) \(round)"
        
        //        let circuit = try container.decode(Circuit.self, forKey: .circuit)
        //        self.circuit = circuit
        
        let resultsList = try container.decodeIfPresent([Result].self, forKey: .results) ?? []
        results.append(objectsIn: resultsList)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}


class RaceTable: Object, Decodable {
    @objc dynamic var season: String = ""
    let races = List<Race>()
    
    @objc dynamic var id: String = "1"
    
    //    override static func primaryKey() -> String? {
    //        return "id"
    //    }
    
    private enum CodingKeys: String, CodingKey {
        case races = "Races"
        
        case season
    }
    
    // This convenience init exists in order to decode the array of Races
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let season = try container.decode(String.self, forKey: .season)
        self.season = season
        
        let raceList = try container.decodeIfPresent([Race].self, forKey: .races) ?? []
        races.append(objectsIn: raceList)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

class MRData: Object, Decodable {
    @objc dynamic var stringXmlns : String = ""
    @objc dynamic var series      : String = ""
    @objc dynamic var stringUrl   : String = ""
    @objc dynamic var limit       : String = ""
    @objc dynamic var offset      : String = ""
    @objc dynamic var total       : String = ""
    
    @objc dynamic var raceTable: RaceTable?
    
    var xmlns: URL? { return URL(string: stringXmlns) }
    var url: URL? { return URL(string: stringUrl) }
    
    @objc dynamic var id: String = "1"
    
    //    override static func primaryKey() -> String? {
    //        return "id"
    //    }
    
    private enum CodingKeys: String, CodingKey {
        case stringXmlns = "xmlns"
        case stringUrl   = "url"
        case raceTable   = "RaceTable"
        
        case series, limit, offset, total
    }
}

class ErgastResponse: Object, Decodable {
    @objc dynamic var mrData: MRData?
    @objc dynamic var id: String = "1"
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}
