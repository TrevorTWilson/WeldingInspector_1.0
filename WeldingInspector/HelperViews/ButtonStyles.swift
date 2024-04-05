//
//  ButtonStyles.swift
//  WeldingInspector
//
//  Created by Trevor Wilson on 2024-04-03.
//

import SwiftUI

struct BorderedBlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding() // Add padding inside the button
            .foregroundColor(.blue)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .cornerRadius(8) // Adjust the corner radius for a smoother appearance
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}


