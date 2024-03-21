//
//  KeyValueView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-18.
//

import SwiftUI

struct KeyValueView: View {
    let key: String
    let value: Double

    var body: some View {
        switch key {
            case "Amps":
                return Text("The value of 'Amps' is: \(value)")
            case "Volts":
                return Text("The value of 'Volts' is: \(value)")
            case "ArcSpeed":
                return Text("The value of 'ArcSpeed' is: \(value)")
            case "HeatInput":
                return Text("The value of 'Heat Input' is: \(value)")
            default:
                return Text("Unknown key: \(key)")
        }
    }
}


