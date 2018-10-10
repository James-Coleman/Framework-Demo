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
     The path of the newly saved image data as a `String`
    */
    func save(pictureData: Data, as name: String) throws -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        let filepath = documentDirectory.appendingPathComponent(name)
        
        try pictureData.write(to: filepath)
        
        return name // Is this necessary in my context anymore?
    }
}
