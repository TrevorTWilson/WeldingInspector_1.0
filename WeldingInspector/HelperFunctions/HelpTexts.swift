//
//  HelpTexts.swift
//  WeldingInspector
//
//  Created by trevor wilson on 2024-04-13.
//

import Foundation

struct HelpTexts {
    static let messages: [String: String] = [
        "Name": "This Name will be used when connecting to nearby users when transmitting or receiving weld or welding procedure data",
        "Conversion": "This will convert the entire database to the selected units. Verify the data after it has been converted",
        "Range": "Add each pass in the welding procedure then select each element and set allowed ranges. Red represents system default Range. Green are ranges that have been set by the user",
        "Discoverable": "Enabling Dicoverable will allow nearby 'WELDING INSPECTOR' users to discover and invite to connect with your device. Once an invitation has been accepted Welding Procedures, Welders, and Welds can be shared directly to IOS users, without the need for cellular or internet connectivity.",
        "Procedure": "If there are procedures stored on this device in other Jobs, they can be selected for import into the new job added.",
        "Welder": "If there are welders stored on this device in other welding procedures or jobs, they will be listed here to allow easy addition to list of qualified welders when adding a new welding procedure to this device.",
        "PassRange": "Name the new weld pass according to the company direction, then select the weld pass it represents from the selected procedure.  For example name the new pass Fill3 and assign the pass to the allowable ranges of fill.  This will ensure each pass is identified by a unique name, and evaluated according to the ranges entered for that procedure pass."
    ]
    
    static func getMessage(for key: String) -> String {
        return messages[key] ?? "Message not found"
    }
}

//  Example Usage for helpIcons

//      HelpIconView(isPopoverVisible: $isNamePopOverVisable, messageKey: "Name")
//          .previewLayout(.sizeThatFits)
//          .padding()
