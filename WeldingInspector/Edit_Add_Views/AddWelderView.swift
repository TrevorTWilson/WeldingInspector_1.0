//
//  AddWelderView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-15.
//

import SwiftUI
import Combine

struct AddWelderView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @State private var welderName: String
    @State private var welderId: String
    @State private var pressureNumber: String
    @State private var pressureExpiry: String
    @Binding var isPresented: Bool
    var selectedWelder: WeldingInspector.Job.WeldingProcedure.Welder?
    @State private var selectedWelderList : [WeldingInspector.Job.WeldingProcedure.Welder] = []
    @State private var savedWelderItems: [String: WeldingInspector.Job.WeldingProcedure.Welder] = [:]
    
    @State private var singleWelder = true
    @State private var isAlertPresented = false
    
    public init(mainViewModel: MainViewModel, isPresented: Binding<Bool>, selectedWelder: WeldingInspector.Job.WeldingProcedure.Welder? = nil) {
        self.mainViewModel = mainViewModel
        self._isPresented = isPresented
        self._welderName = State(initialValue: selectedWelder?.name ?? "")
        self._welderId = State(initialValue: selectedWelder?.welderId ?? "")
        self._pressureNumber = State(initialValue: selectedWelder?.pressureNumber ?? "")
        self._pressureExpiry = State(initialValue: selectedWelder?.pressureExpiry ?? "")
        self.selectedWelder = selectedWelder
    }

    func addWelder() {
        if singleWelder {
            if selectedWelder != nil {
                // Edit existing welder
                mainViewModel.updateWelder(name: welderName, welderId: welderId, pressureNumber: pressureNumber, pressureExpiry: pressureExpiry)
            } else {
                // Add new welder
                mainViewModel.addWelder(name: welderName, welderId: welderId, pressureNumber: pressureNumber, pressureExpiry: pressureExpiry)
            }
        } else {
            mainViewModel.addMultipleWelders(selectedWelders: selectedWelderList)
        }
        
        isPresented = false
    }

    var body: some View {
        Form {
            
            if selectedWelder == nil {
                GeometryReader { geometry in
                    HStack {
                        Button(action: {
                            singleWelder = true
                        }) {
                            Text("Single Entry")
                                .padding()
                                .background(singleWelder ? Color.blue : Color.white)
                                .foregroundColor(singleWelder ? Color.white : Color.black)
                                .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            singleWelder = true
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                            )

                        Spacer()

                        Button(action: {
                            singleWelder = false
                        }) {
                            Text("Multiple Entry")
                                .padding()
                                .background(singleWelder ? Color.white : Color.blue)
                                .foregroundColor(singleWelder ? Color.black : Color.white)
                                .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            singleWelder = false
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
                .frame(height: 50)
            }
            
            
            
            if singleWelder {
                Section{
                    Text("Welders Name")
                    TextField("New Welder Name", text: $welderName)
                }

                Section {
                    Text("Welder ID")
                    TextField("E.G.: 61", text: $welderId)
                }

                Section {
                    Text("Pressure Number")
                    TextField("Pressure Number", text: $pressureNumber)
                }

                Section {
                    Text("Pressure Expiry")
                    TextField("Pressure Expiry", text: $pressureExpiry)
                }

                HStack {
                    Button(selectedWelder != nil ? "Edit Welder" : "Add Welder") {
                        addWelder()
                    }
                    .disabled(welderName.isEmpty)
                    Spacer()
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            } else {
                Section{
                    Text("Select from List")
                    VStack {
                        let items = mainViewModel.getAllWelders()
                        //let items = [:]
                        if items.isEmpty {
                            Text("There are no Welding Procedures available on this device")
                                .font(.system(size: 14))
                        } else {
                            Text("Welding Procedures are available on this device")
                                .font(.system(size: 14))
                            
                                MultipleSelectionPicker(items: Array(items.keys), onSave: { selectedItems in
                                    self.savedWelderItems = items.filter { selectedItems.contains($0.key) }
                                    // Extract values from the dictionary to the array
                                    self.selectedWelderList = Array(self.savedWelderItems.values)
                                    print(selectedWelderList)
                                }, buttonLabel: "Add")
                        }
                    }
                    
                }
                HStack{
                    GeometryReader { geometry in
                        HStack {
                            Button("Add Procedure") {
                                if selectedWelderList != [] {
                                    addWelder()
                                }
                            }
                            .disabled(selectedWelderList.isEmpty)
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
        .onAppear {
            if let selectedWelder = selectedWelder {
                // Populate form fields with selected welder's data for editing
                welderName = selectedWelder.name
                welderId = selectedWelder.welderId
                pressureNumber = selectedWelder.pressureNumber
                pressureExpiry = selectedWelder.pressureExpiry
            }
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text("Error"),
                message: Text("Welder name cannot be blank"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}




struct AddWelderView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented: Bool = true // Define isPresented as @State variable
        AddWelderView(mainViewModel: MainViewModel(), isPresented: $isPresented)
    }
}
