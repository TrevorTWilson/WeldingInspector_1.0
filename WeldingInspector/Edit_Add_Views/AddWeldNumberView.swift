//
//  AddWeldNumberView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-15.
//

import SwiftUI
import Combine

struct AddWeldNumberView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @State private var name: String
    @Binding var isPresented: Bool
    
    var selectedWeldNumber: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers?
    @State private var sectionTitle: String = "Add"
    
    public init(mainViewModel: MainViewModel, isPresented: Binding<Bool>, selectedWeldNumber: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers? = nil) {
        self.mainViewModel = mainViewModel
        self._name = State(initialValue: selectedWeldNumber?.name ?? "")
        self._isPresented = isPresented
        self.selectedWeldNumber = selectedWeldNumber
    }
    
    func addWeldNumber(){
        if selectedWeldNumber != nil {
            // Edit existing weldNumber
            mainViewModel.updateWeldNumber(name: name)
        } else {
            // Add new weldNumber
            mainViewModel.addWeldNumber(name: name)
        }
        isPresented = false
    }
    
    var body: some View {
        Form {
            Section(header: Text("\(sectionTitle) Weld Number")){
                Text("\(sectionTitle) weld number")
                TextField("\(sectionTitle) Weld Number", text: $name)
                    .onSubmit {
                        addWeldNumber()
                    }
            }
            
            GeometryReader { geometry in
                HStack{
                    Button("\(sectionTitle) Weld Number") {
                        addWeldNumber()
                    }
                    .disabled(name.isEmpty)
                    .frame(width: geometry.size.width / 2 - 10)
                    
                    Spacer()
                    
                    Button("Cancel") {
                        isPresented = false
                    }
                    .frame(width: geometry.size.width / 2 - 10)
                }
            }
            .padding(.horizontal, 10)
        }
        .navigationTitle("Add New Welder")
        .onAppear {
            if let selectedWeldNumber = selectedWeldNumber {
                // Populate form fields with selected welder's data for editing
                name = selectedWeldNumber.name
                sectionTitle = "Edit"
            }
        }
    }
        
}


struct AddWeldNumberView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented: Bool = true // Define isPresented as @State variable
        AddWeldNumberView(mainViewModel: MainViewModel(), isPresented: $isPresented)
    }
}
