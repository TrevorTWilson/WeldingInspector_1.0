//
//  HelpIconView.swift
//  WeldingInspector
//
//  Created by trevor wilson on 2024-04-13.
//

import SwiftUI

struct HelpIconView: View {
    @Binding var isPopoverVisible: Bool
    var messageKey: String
    
    var body: some View {
        let message = HelpTexts.getMessage(for: messageKey)
        
        Image(systemName: "info.circle.fill")
            .foregroundColor(.blue)
            .onTapGesture {
                isPopoverVisible.toggle()
            }
            .popover(isPresented: $isPopoverVisible, attachmentAnchor: .point(.top), arrowEdge: .top) {
                VStack {
                    VStack {
                        Text(message)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                        
                        Button("Dismiss") {
                            isPopoverVisible = false
                        }
                        .padding()
                    }
                    .padding()
                }
            }
            .padding()
    }
}



// Preview for HelpIconView
struct HelpIconView_Previews: PreviewProvider {
    @State static var isPopoverVisible: Bool = true
    
    static var previews: some View {
        HelpIconView(isPopoverVisible: $isPopoverVisible, messageKey: "Name")
            .previewLayout(.sizeThatFits)
    }
}

