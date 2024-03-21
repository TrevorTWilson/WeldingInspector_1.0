//
//  DataStorage.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-13.
//

import Foundation

extension MainViewModel {
    
    // Methods to store and retrieve weldingInspector data from local JSON file (default 'Seed' data available if no file present
    func loadWeldingInspector() {
        weldingInspector = StorageFunctions.retrieveInspector()
    }
    func saveWeldingInspector() {
        StorageFunctions.storeInspector(weldingInspector: weldingInspector)
    }
}
