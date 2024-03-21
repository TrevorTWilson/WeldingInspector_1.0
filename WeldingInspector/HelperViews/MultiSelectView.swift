//
//  MultiSelectView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-14.
//

import SwiftUI

struct MultipleSelectionPicker<T: Hashable>: View {
    @State private var selectedItems: Set<T> = []

    let items: [T] // List of items to display
    let onSave: ([T]) -> Void // Closure to handle saving selected items
    let buttonLabel: String // Button label text

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(String(describing: item))
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: {
                                self.selectedItems.contains(item)
                            },
                            set: { _ in
                                if self.selectedItems.contains(item) {
                                    self.selectedItems.remove(item)
                                } else {
                                    self.selectedItems.insert(item)
                                }
                            }
                        ))
                    }
                }
            }
        }
        Button(buttonLabel) {
            self.onSave(Array(self.selectedItems))
        }
    }
}


struct MultiPicker: View {
    let items: [String: WeldingInspector.Job.WeldingProcedure] = [
        "Welding Procedure 1": WeldingInspector.Job.WeldingProcedure(name: "Welding Procedure 1", type: "Type 1", usage: "Usage 1", owner: "Owner 1", weldPass: [], weldersQualified: []),
        "Welding Procedure 2": WeldingInspector.Job.WeldingProcedure(name: "Welding Procedure 2", type: "Type 2", usage: "Usage 2", owner: "Owner 2", weldPass: [], weldersQualified: [])
    ]
    
    @State private var savedItems: [String: WeldingInspector.Job.WeldingProcedure] = [:]
    @State private var selectedWeldingProcedures: [WeldingInspector.Job.WeldingProcedure] = []

    var body: some View {
        VStack {
            MultipleSelectionPicker(items: Array(items.keys), onSave: { selectedItems in
                self.savedItems = items.filter { selectedItems.contains($0.key) }

                // Extract values from the dictionary to the array
                self.selectedWeldingProcedures = Array(self.savedItems.values)
                print(selectedWeldingProcedures)
            }, buttonLabel: "Custom Save")
            Text("Selected Items: \(savedItems.map { "\($0.key): \($0.value)" }.joined(separator: ", "))")
        }
    }
}



struct MultiPicker_Previews: PreviewProvider {
    static var previews: some View {
        MultiPicker()
    }
}


