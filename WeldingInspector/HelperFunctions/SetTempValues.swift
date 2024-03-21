//
//  SetTempValues.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-06.
//

import Foundation

// Helper function to set tempMin and tempMax
func setTempValuesForKey(for key: String, pass: WeldingInspector.Job.WeldingProcedure.WeldPass?, mainViewModel: MainViewModel) -> (String, String, Double, Double, Double) {
    var tempMin: Double = 0.0
    var tempMax: Double = 0.0
    var tempResolution = 0.0

    var selectedKey: String = ""
    var selectedDescriptor: String = ""
    var selectedMinRange: Double = 0.0
    var selectedMaxRange: Double = 0.0
    var selectedResolution: Double = 0.0

    if let _ = pass?.minRanges[key], let _ = pass?.maxRanges[key] {
        selectedDescriptor = "Edit Range Values"
    } else {
        selectedDescriptor = "Add new Range Values"
    }

    
    (tempMin, tempMax, tempResolution) = getTemporaryValuesForKey(key, mainViewModel: mainViewModel)

    selectedKey = key
    selectedMinRange = tempMin
    selectedMaxRange = tempMax
    selectedResolution = tempResolution
    //print("\(pass!.passName)---\(selectedKey)---\(selectedDescriptor)---\(selectedMinRange)---\(selectedMaxRange)")

    return (selectedKey, selectedDescriptor, selectedMinRange, selectedMaxRange, selectedResolution)
}

