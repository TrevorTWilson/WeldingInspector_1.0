//
//  WeldingProcedureFormView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-22.
//

import SwiftUI

struct WeldingProcedureFormView: View {
    @ObservedObject var mainViewModel: MainViewModel
    var selectedWeldingProcedure: WeldingInspector.Job.WeldingProcedure?
    @Binding var isPresented: Bool
    @State private var addNewPass = false // add weldPass
    @State private var selectedItemForDeletion: WeldingInspector.Job.WeldingProcedure.WeldPass?
    @State private var isRangeSliderSheetPresented = false
    @State private var selectedKey: String = "" // Store the selected key
    @State private var selectedDescriptor: String = "" // Store descriptor
    @State private var selectedMinRange: Double = 0.0 // Store the minimum range
    @State private var selectedMaxRange: Double = 0.0 // Store the maximum range
    @State private var selectedInitialMin: Double = 0.0 //Store initial min Value
    @State private var selectedInitialMax: Double = 0.0 // Store initial max Value
    @State private var selectedResolution: Double = 0.0 // store rangeslider resolution
    
    @State  var procedureName = ""
    
    @State  var procedureWeldPass: [WeldingInspector.Job.WeldingProcedure.WeldPass] = []
    
    let procedureTypesList = ["","SMAW", "FCAW", "GMAW", "GTAW"]
    @State private var selectedProcedureType = 0
    
    let procedureUseList = ["","Girth", "Girth/Repair"]
    @State private var selectedProcedureUse = 0
    
    let procedureOwnerList = ["","Client", "Contractor"]
    @State private var selectedProcedureOwner = 0
    
    // Define the keys in the desired order
    let orderedKeys = ["Amps", "Volts", "ArcSpeed", "HeatInput"]
    // Initializer with a passed in weldingProcedure
    init(mainViewModel: MainViewModel, isPresented: Binding<Bool>, selectedWeldingProcedure: WeldingInspector.Job.WeldingProcedure? = nil) {
        self.mainViewModel = mainViewModel
        self._isPresented = isPresented
        self.selectedWeldingProcedure = selectedWeldingProcedure
        
        _procedureName = State(initialValue: selectedWeldingProcedure?.name ?? "")
        
        // Initialize procedure type with stored value or default to the first element
        if let selectedType = selectedWeldingProcedure?.type,
           let typeIndex = procedureTypesList.firstIndex(of: selectedType) {
            _selectedProcedureType = State(initialValue: typeIndex)
        } else {
            _selectedProcedureType = State(initialValue: 0)
        }
        
        // Initialize procedure usage with stored value or default to the first element
        if let selectedUsage = selectedWeldingProcedure?.usage,
           let usageIndex = procedureUseList.firstIndex(of: selectedUsage) {
            _selectedProcedureUse = State(initialValue: usageIndex)
        } else {
            _selectedProcedureUse = State(initialValue: 0)
        }
        
        // Initialize procedure owner with stored value or default to the first element
        if let selectedOwner = selectedWeldingProcedure?.owner,
           let ownerIndex = procedureOwnerList.firstIndex(of: selectedOwner) {
            _selectedProcedureOwner = State(initialValue: ownerIndex)
        } else {
            _selectedProcedureOwner = State(initialValue: 0)
        }
        
        _procedureWeldPass = State(initialValue: selectedWeldingProcedure?.weldPass ?? [])
    }
    
    
    var body: some View {
        Form {
            Section(header: Text("Procedure Details")) {
                TextField("Procedure Name", text: $procedureName)
                
                Picker("Procedure Type", selection: $selectedProcedureType) {
                    ForEach(procedureTypesList.indices, id: \.self) { index in
                        Text(procedureTypesList[index])
                    }
                }
                
                Picker("Procedure Use", selection: $selectedProcedureUse) {
                    ForEach(procedureUseList.indices, id: \.self) { index in
                        Text(procedureUseList[index])
                    }
                }
                Picker("Procedure Owner", selection: $selectedProcedureOwner) {
                    ForEach(procedureOwnerList.indices, id: \.self) { index in
                        Text(procedureOwnerList[index])
                    }
                }
            }
            
            Section(header: CustomSectionHeader(sectionLabel: "Weld Passes", action: {
                addNewPass.toggle()
            })) {
                ScrollView(.vertical) {
                    LazyVStack{
                        if let passList = selectedWeldingProcedure?.weldPass, !passList.isEmpty {
                            
                            ForEach(Array(passList.enumerated()), id: \.element.id) { index, pass in
                                
                                HStack {
                                    Text(pass.passName)
                                        .frame(width: 60, height: 60)
                                        .onTapGesture{
                                            selectedItemForDeletion = mainViewModel.selectedWeldingProcedure?.weldPass[index]
                                        } 
                                    HStack(spacing: 5) {
                                        // Update the button actions to handle each key individually
                                        ForEach(orderedKeys, id: \.self) { key in
                                            // Call to handleKeyAction in WeldingProcedureFormView
                                            handleKeyAction(for: key, pass: pass, mainViewModel: mainViewModel, updateKeyValues: { updatedKey, updatedDescriptor, updatedMinRange, updatedMaxRange, updatedInitialMin, updatedInitialMax, updatedResolution in
                                                self.selectedKey = updatedKey
                                                self.selectedDescriptor = updatedDescriptor
                                                self.selectedMinRange = updatedMinRange
                                                self.selectedMaxRange = updatedMaxRange
                                                self.selectedInitialMin = updatedInitialMin
                                                self.selectedInitialMax = updatedInitialMax
                                                self.selectedResolution = updatedResolution
                                            }, isRangeSliderSheetPresented: $isRangeSliderSheetPresented)
                                        }
                                    }
                                }
                               
                            }
                        } else {
                            Text("No welding passes available")
                            Text("Add welding passes to the selected procedure")
                        }
                    }
                    
                    .alert(item: $selectedItemForDeletion) { passRemove in
                        Alert(
                            title: Text("Delete \(passRemove.passName) Weld Pass"),
                            message: Text("Are you sure you want to delete \(passRemove.passName)? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                if let index = mainViewModel.selectedWeldingProcedure?.weldPass.firstIndex(where: { $0.id == passRemove.id }) {
                                    print("Alert Index: \(index)")
                                    mainViewModel.deleteSelectedProcedurePass(index: index)
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .scrollIndicatorsFlash(onAppear: true)
                .frame(maxHeight: 220) // Set a maximum height for the scrollable
            }
            VStack {
                HStack {
                    Text("Tap on Pass Name to delete pass")
                        .foregroundColor(Color.gray)
                }
            }
            Spacer()
            HStack{
                Button(action: {
                    // Add logic to save the collected data for WeldingProcedure
                    let updatedProcedureName = procedureName
                    let updatedProcedureType = procedureTypesList[selectedProcedureType]
                    let updatedProcedureUse = procedureUseList[selectedProcedureUse]
                    let updatedProcedureOwner = procedureOwnerList[selectedProcedureOwner]
                    
                    mainViewModel.updateProcedure(newName: updatedProcedureName, newType: updatedProcedureType, newUse: updatedProcedureUse, newOwner: updatedProcedureOwner)
                    
                    isPresented = false
                }) {
                    Text("Save Procedure")
                }
                Spacer()
                Button(action: {
                    // Add logic to save the collected data for WeldingProcedure
                    isPresented = false
                }) {
                    Text("Cancel")
                }
            }
            
        }
        .navigationTitle("Add Welding Procedure")
        
        .sheet(isPresented: $isRangeSliderSheetPresented) {
            RangeSlider(
                isRangeSliderSheetPresented: $isRangeSliderSheetPresented,
                attributeTitle: self.selectedKey,
                descriptor: self.selectedDescriptor,
                minValue: self.selectedMinRange,
                maxValue: self.selectedMaxRange,
                initialMinValue: self.selectedInitialMin,
                initialMaxValue: self.selectedInitialMax,
                resolution: self.selectedResolution,
                onValueSelected: { minValue, maxValue in
                    print(minValue, maxValue)
                    mainViewModel.addProcedurePaasRange(key: self.selectedKey, minRange: minValue, maxRange: maxValue)
                }
            )
        }
        .sheet(isPresented: $addNewPass, content: {
            // Add new job item view
            AddProcedurePass(mainViewModel: mainViewModel, isPresented: $addNewPass)
        })
        
    }
}



struct WeldingProcedureFormView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        mockMainViewModel.weldingInspector = loadSample() // Initialize with default data or mock data
        //mockMainViewModel.setSelectedJob(job: mockMainViewModel.weldingInspector.jobs[1])
        //mockMainViewModel.selectedWeldingProcedure = mockMainViewModel.weldingInspector.jobs[1].weldingProcedures[1]
        @State var isPresented: Bool = true // Define isPresented as @State variable
        
        return WeldingProcedureFormView(mainViewModel: MainViewModel(), isPresented: $isPresented, selectedWeldingProcedure: mockMainViewModel.weldingInspector.jobs[1].weldingProcedures[1])
    }
}


