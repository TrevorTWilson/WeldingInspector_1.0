//
//  SectionHeaderView.swift
//  WeldingInspector
//
//  Created by trevor wilson on 2024-04-13.
//

import SwiftUI

struct SectionHeaderView: View {
    var title: String
    @Binding var isPopoverVisible: Bool
    var message: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            HelpIconView(isPopoverVisible: $isPopoverVisible, messageKey: message)
                .previewLayout(.sizeThatFits)
        }
    }

}

struct SectionHeaderView_Previews: PreviewProvider {
    @State static var isPopoverVisible: Bool = false // Initial popover visibility state
    
    static var previews: some View {
        SectionHeaderView(title: "Test Header", isPopoverVisible: $isPopoverVisible, message: "Range")
            .previewLayout(.sizeThatFits)
    }
}

