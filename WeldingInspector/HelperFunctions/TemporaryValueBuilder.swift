//
//  TemporaryValueBuilder.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-01.
//

import Foundation


// Sets temporary values for minRange and maxRange in WeldingInspector.Jobs.WeldingProcedure[index].passName.minRange(maxRange)

func getTemporaryValuesForKey(_ key: String, mainViewModel: MainViewModel) -> (Double, Double, Double) {
    let minRange: Double
    let maxRange: Double
    let resolution: Double
    
    switch key {
    case "Amps", "Volts", "ArcSpeed", "HeatInput":
        minRange = mainViewModel.weldingInspector.defaultMinRange[key] ?? 0.0
        maxRange = mainViewModel.weldingInspector.defaultMaxRange[key] ?? 0.0
        resolution = mainViewModel.weldingInspector.defaultResolution[key] ?? 0.0
    default:
        minRange = 0.0
        maxRange = 0.0
        resolution = 1.0
    }
    
    return (minRange, maxRange, resolution)
}



