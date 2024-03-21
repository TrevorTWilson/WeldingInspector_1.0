//
//  CalculateArcSpeed.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-13.
//

import Foundation


func calculateArcSpeed (distance: Double, time: Double) -> Double {
    if distance == 0.0 || time == 0.0 {
        let arcSpeed = 0.0
        return arcSpeed
    } else {
        let arcSpeed = (distance / time) * 60
        return arcSpeed
    }
}


