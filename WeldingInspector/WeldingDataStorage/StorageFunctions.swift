//
//  StorageFunctions.swift
//  Create_Json_Seed_File
//
//  Created by trevor wilson on 2024-02-02.
//

import Foundation

class StorageFunctions {
    
    static let fileManager = FileManager.default
    
    static let backupURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("backup.json")
    
    static let bundleUrl = Bundle.main.url(forResource: "Seed", withExtension: "json")!
    
    static func retrieveInspector() -> WeldingInspector {
        var url = backupURL
        if !fileManager.fileExists(atPath: backupURL.path){
            url = bundleUrl
        }
        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to decode data")
        }
        guard let weldingInspector = try? decoder.decode(WeldingInspector.self, from: data) else {
            fatalError("Failed to decode JSON from data")
        }
        return weldingInspector
    }
    
    
    static func storeInspector(weldingInspector: WeldingInspector){
        let backupURLPath = backupURL.path()
        print(backupURLPath)
        let encoder = JSONEncoder()
        guard let welderJSONData = try? encoder.encode(weldingInspector) else {
            fatalError("Could not encode data")
        }
        let welderJSON = String(data: welderJSONData, encoding: .utf8)!
        
        do {
            try welderJSON.write(toFile: backupURLPath, atomically: true, encoding: .utf8)
        } catch {
            print("Could not save file to directory: \(error.localizedDescription)")
        }
    }
}
