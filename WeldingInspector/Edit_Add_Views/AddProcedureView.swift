//
//  AddProcedureView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-15.
//

import SwiftUI
import Combine

struct AddProcedureView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @Binding var isPresented: Bool
    @State private var procedureName: String
    @State private var savedItems: [String: WeldingInspector.Job.WeldingProcedure.Welder] = [:]
    @State private var savedProcedureItems: [String: WeldingInspector.Job.WeldingProcedure] = [:]
    @State private var addWelders: [WeldingInspector.Job.WeldingProcedure.Welder]?
    @State private var selectedWelders: [WeldingInspector.Job.WeldingProcedure.Welder] = []
    @State private var selectedWeldingProcedures: [WeldingInspector.Job.WeldingProcedure] = []
    @State private var weldersAvailableLabel: String = ""
    @State private var isExpanded: Bool = false
    @State private var isAlertPresented = false
    @State private var singleProcedure = true
    
    
    init(mainViewModel: MainViewModel, isPresented: Binding<Bool>) {
        self.mainViewModel = mainViewModel
        self._isPresented = isPresented
        _procedureName = State(initialValue: "")
    }
    
    func addProcedure() {
        if singleProcedure{
            mainViewModel.addProcedure(name: procedureName, weldersQualified: selectedWelders)
        } else {
            mainViewModel.addMultipleProcedures(selectedProcedures: selectedWeldingProcedures)

        }
        
        
        isPresented = false
    }
    
    var body: some View {
        Form {
            
            GeometryReader { geometry in
                HStack {
                    Button(action: {
                        singleProcedure = true
                    }) {
                        Text("Single Entry")
                            .padding()
                            .background(singleProcedure ? Color.blue : Color.white)
                            .foregroundColor(singleProcedure ? Color.white : Color.black)
                            .cornerRadius(10)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        singleProcedure = true
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                        )

                    Spacer()

                    Button(action: {
                        singleProcedure = false
                    }) {
                        Text("Multiple Entry")
                            .padding()
                            .background(singleProcedure ? Color.white : Color.blue)
                            .foregroundColor(singleProcedure ? Color.black : Color.white)
                            .cornerRadius(10)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        singleProcedure = false
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                        )
                }
            }
            .frame(height: 50)
            
            if singleProcedure {
                Section{
                    Text("Enter The Procedure Name")
                    TextField("Procedure Name", text: $procedureName)
                        .onSubmit {
                            if procedureName != "" {
                                addProcedure()
                            } else {
                                isAlertPresented = true
                            }
                        }
                }
                Section{
                    VStack {
                        let items = mainViewModel.getAllWelders()
                        //let items = [:]
                        if items.isEmpty {
                            Text("There are no Welders available on this device")
                                .font(.system(size: 14))
                        } else {
                            Text("Welders are available on this device")
                                .font(.system(size: 14))
                     
                                MultipleSelectionPicker(items: Array(items.keys), onSave: { selectedItems in
                                    self.savedItems = items.filter { selectedItems.contains($0.key) }
                                    // Extract values from the dictionary to the array
                                    self.selectedWelders = Array(self.savedItems.values)
                                    print(selectedWelders)
                                }, buttonLabel: "Add")
                            
                        }
                    }
                }
                
                Section{
                    if selectedWelders.isEmpty {
                        Text("No Welders linked to ")
                        + Text(procedureName)
                            .foregroundColor(.blue)
                    } else {
                        Text("Welders linked to ")
                        + Text(procedureName)
                            .foregroundColor(.blue)
                    }

                }
                HStack{
                    GeometryReader { geometry in
                        HStack {
                            Button("Add Procedure") {
                                if procedureName != "" {
                                    addProcedure()
                                } else {
                                    isAlertPresented = true
                                }
                            }
                            .disabled(procedureName.isEmpty)
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
            } else {
                Section{
                    Text("Select from List")
                    VStack {
                        let items = mainViewModel.getAllWeldingProcedure()
                        //let items = [:]
                        if items.isEmpty {
                            Text("There are no Welding Procedures available on this device")
                                .font(.system(size: 14))
                        } else {
                            Text("Welding Procedures are available on this device")
                                .font(.system(size: 14))
                            
                                MultipleSelectionPicker(items: Array(items.keys), onSave: { selectedItems in
                                    self.savedProcedureItems = items.filter { selectedItems.contains($0.key) }
                                    // Extract values from the dictionary to the array
                                    self.selectedWeldingProcedures = Array(self.savedProcedureItems.values)
                                    print(selectedWeldingProcedures)
                                }, buttonLabel: "Add")
                        }
                    }
                    
                }
                HStack{
                    GeometryReader { geometry in
                        HStack {
                            Button("Add Procedure") {
                                if selectedWeldingProcedures != [] {
                                    addProcedure()
                                } else {
                                    isAlertPresented = true
                                }
                            }
                            .disabled(selectedWeldingProcedures.isEmpty)
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
            }
            
        }
        .navigationTitle("Add New Procedure") // Adjust title based on editing or adding
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text("Error"),
                message: Text("Procedure name cannot be blank"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}



struct AddProcedureView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        mockMainViewModel.weldingInspector = loadSample() // Initialize with default data or mock data
        @State var isPresented: Bool = true // Define isPresented as @State variable
        
        return AddProcedureView(mainViewModel: mockMainViewModel, isPresented: $isPresented)
    }
}




