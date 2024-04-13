//
//  ReusableToolBar.swift
//  WeldingInspector
//
//  Created by Trevor Wilson on 2024-04-05.
//

import SwiftUI

import SwiftUI

struct ReusableTrailingToolbarItemView: View {
    @State private var isDiscoverPopOverVisable: Bool = false
    @Binding var isDiscoverable: Bool
    
    var body: some View {
        HStack {
            Text("Discoverable")
                .foregroundColor(.primary)
            
            Toggle("", isOn: $isDiscoverable)
                .toggleStyle(SwitchToggleStyle(tint: .green))
                .labelsHidden()
            HelpIconView(isPopoverVisible: $isDiscoverPopOverVisable, messageKey: "Discoverable")
                .previewLayout(.sizeThatFits)
        }
    }
}

struct ReusableLeadingToolbarItemView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "gear")
                .imageScale(.large)
        }
    }
}


struct ReusableTrailingToolbarItemView_Previews: PreviewProvider {
    static var previews: some View {
        ReusableTrailingToolbarItemView(isDiscoverable: .constant(true))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color(UIColor.systemBackground))
            .environment(\.colorScheme, .light) // Set the color scheme as needed
    }
}


// USAGE
//          ToolbarItem(placement: .navigationBarLeading) {
//              ReusableLeadingToolbarItemView {
//                  showProfileView.toggle()
//              }
//          }

//          ToolbarItem(placement: .navigationBarTrailing) {
//              ReusableTrailingToolbarItemView(isDiscoverable: $multipeerManager.isDiscoverable)
//          }

