//
//  CalculateHeatInput.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-13.
//

import Foundation

func calculateHeatInput (distance: Double, time:Double, amps: Double, volts: Double) -> Double {
    if distance == 0.0 || time == 0.0 || amps == 0.0 || volts == 0.0 {
        let heatInput = 0.0
        return heatInput
    } else {
        let heatInput =  (((amps * volts) * time) / distance) / 1000
        return heatInput
    }
}
