//
//  KeyValueRow.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-22.
//

import SwiftUI

struct KeyValueRow: View {
    let key: String
    let value: Double?
    
    var body: some View {
        HStack {
            Text(key)
            
            Spacer()
            
            if let value = value {
                Text(String(format: "%.1f", value))
            } else {
                Text("Not Recorded")
            }
        }
        .padding()
        .background(Color.white) // Set background color
        .cornerRadius(5) // Apply corner radius for a rounded border effect
        .overlay(
            RoundedRectangle(cornerRadius: 5) // Add a rounded rectangle overlay for the border
                .stroke(Color.black, lineWidth: 1) // Specify the border color and width
        )
        .padding(.horizontal) // Add horizontal padding to separate items
    }
}


