//
//  CustomSectionHeader.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-01.
//

import SwiftUI

struct CustomSectionHeader: View {
    var sectionLabel: String
    var action: () -> Void
    
    var body: some View {
        VStack{
            HStack {
                Text(sectionLabel)
                    .font(.headline)
                Spacer()
                Button(action: action) {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }
            Text("Range Values")
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.top, 5)
            
            HStack {
                Text("Pass")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("Amps")
                    .frame(maxWidth: .infinity)
                Text("Volts")
                    .frame(maxWidth: .infinity)
                VStack {
                    Text("Arc")
                    Text("Speed")
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("Heat")
                    Text("Input")
                }
                .frame(maxWidth: .infinity)
                Spacer()
            }
            .padding(.vertical, 5)
            
        }
        .padding(.horizontal)
    }
}

struct CustomSectionHeader_Preview: PreviewProvider {
    static var previews: some View {
        CustomSectionHeader(sectionLabel: "Custom Section", action: {
            // Add action for the button here
            print("Button tapped")
        })
        .previewLayout(.sizeThatFits)
    }
}

