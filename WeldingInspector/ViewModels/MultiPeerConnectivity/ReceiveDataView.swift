//
//  ReceiveDataView.swift
//  WeldingInspector
//
//  Created by Trevor Wilson on 2024-04-01.
//

import SwiftUI

struct ReceiveDataView: View {
    
    //@ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var mainViewModel: MainViewModel
    @EnvironmentObject var multipeerManager: MultipeerConnectivityManager
    
    @Binding var showReceivedData: Bool
    
    var newProcedureData: WeldingInspector.Job.WeldingProcedure?
    var newWelderData: WeldingInspector.Job.WeldingProcedure.Welder?
    var newWeldData: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers?
    
    var isWeld: Bool = false
    var isWelder: Bool = false
    var isProcedure: Bool = false
    @State private var activeButton = false
    @State private var showProgressView = false
    
    @State private var selectedJob: String = ""
    @State private var customJobOption: String = ""
    
    @State private var selectedProcedure: String = ""
    @State private var customProcedureOption: String = ""
    
    @State private var selectedWelder: String = ""
    @State private var customWelderOption: String = ""
    
    @State private var jobOptions: [String] = []
    @State private var procedureOptions: [String] = []
    @State private var welderOptions: [String] = []
    
    init(
        mainViewModel: MainViewModel,
        showReceivedData: Binding<Bool>,
        newProcedureData: WeldingInspector.Job.WeldingProcedure? = nil,
        newWelderData: WeldingInspector.Job.WeldingProcedure.Welder? = nil,
        newWeldData: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers? = nil
    ) {
        self.mainViewModel = mainViewModel
        _showReceivedData = showReceivedData
        self.newWeldData = newWeldData
        self.newProcedureData = newProcedureData
        self.newWelderData = newWelderData
        _jobOptions = State(initialValue: Array(mainViewModel.getAllJobs().keys))
        
        self.isWeld = newWeldData != nil
        self.isWelder = newWelderData != nil
        self.isProcedure = newProcedureData != nil
        //print("Procedure: \(isProcedure)---Welder: \(isWelder)---Weld: \(isWeld)")
        if isWelder {
            print("Start")
            print(newWelderData as Any)
            print("Procedure: \(isProcedure)---Welder: \(isWelder)---Weld: \(isWeld)")
            print("End")
        }
    }
    
    var body: some View {
        VStack {
            if isWeld {
                Text("Received a Weld")
            } else {
                if isWelder {
                    Text("Received a Welder")
                } else {
                    Text("Received Welding Procedure")
                }
            }
            Picker(selection: $selectedJob, label: Text("Job Picker")) {
                ForEach(jobOptions, id: \.self) { jobName in
                    Text(jobName)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            HStack {
                TextField("New Job Name", text: $customJobOption)
                Button(action: {
                    self.addCustomJobOption()
                }) {
                    Text("Add Job")
                }
                .buttonStyle(BorderedBlueButtonStyle())
                .disabled(customJobOption.isEmpty)
            }
            
            Spacer()
            
            // Check if data is a weldingProcedure
            if isProcedure && !selectedJob.isEmpty{
                Text("Welding Procedure: \(newProcedureData?.name ?? "Unknown Procedure")")
                Text("Will be added to Job: \(selectedJob)")
            } else {
                
                if let selectedJobIndex = getSelectedJobIndex() {
                    
                    Picker(selection: $selectedProcedure, label: Text("Procedure Picker")) {
                        ForEach(procedureOptions, id: \.self) { procedureName in
                            Text(procedureName)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    HStack {
                        TextField("New Procedure Name", text: $customProcedureOption)
                        Button(action: {
                            self.addCustomProcedureOption()
                        }) {
                            Text("Add Procedure")
                        }
                        .buttonStyle(BorderedBlueButtonStyle())
                        .disabled(customProcedureOption.isEmpty)
                    }
                    .onChange(of: selectedProcedure) {
                        if isWelder && !selectedProcedure.isEmpty {
                            activeButton = true
                        } else {
                            activeButton = false
                        }
                    }
                    Text("Selected Procedure: \(selectedProcedure)")
                    Spacer()
                    
                    if isWelder && !selectedProcedure.isEmpty {
                        Text("Welder: \(newWelderData?.name ?? "Unknown Welder")")
                        Text("Will be added to Job: \(selectedJob)")
                        Text("And Welding Procedure: \(selectedProcedure)")
                    } else {
                        
                        if let selectedProcedureIndex = getSelectedProcedureIndex(selectedJobIndex: selectedJobIndex) {
                            
                            Picker(selection: $selectedWelder, label: Text("Welder Picker")) {
                                ForEach(welderOptions, id: \.self) { welderName in
                                    Text(welderName)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            HStack {
                                TextField("New Welder Name", text: $customWelderOption)
                                Button(action: {
                                    self.addCustomWelderOption()
                                }) {
                                    Text("Add Welder")
                                }
                            }
                            .onAppear{
                                reloadWelderOptions()
                            }
                            .onChange(of: selectedJob) {
                                selectedProcedure = ""
                                selectedWelder = ""
                                reloadProcedureOptions()
                                reloadWelderOptions()
                            }
                            .onChange(of: selectedProcedure) {
                                selectedWelder = ""
                                reloadWelderOptions()
                                
                            }
                            .onChange(of: selectedWelder) {
                                if isWeld && !selectedJob.isEmpty && !selectedProcedure.isEmpty && !selectedWelder.isEmpty {
                                    activeButton = true
                                } else {
                                    activeButton = false
                                }
                            }
                            Text("Selected Welder \(selectedWelder)")
                            Spacer()
                            
                            if isWeld && !selectedWelder.isEmpty {
                                Text("WeldNumber: \(newWeldData?.name ?? "Unknown Weld")")
                                Text("Will be added to Job: \(selectedJob)")
                                Text("And Welding Procedure: \(selectedProcedure)")
                                Text("Assigned to: \(selectedWelder)")
                            }
                            
                            if let selectedWelderIndex = getSelectedWelderIndex(selectedJobIndex: selectedJobIndex, selectedProcedureIndex: selectedProcedureIndex) {
                            }
                        }
                    }
                    }
            }
            HStack {
                Spacer()
                Button("Cancel") {
                    showReceivedData = false
                    multipeerManager.receivedWeldData = false
                    multipeerManager.receivedProcedureData = false
                    multipeerManager.receivedWelderData = false
                }
                .buttonStyle(BorderedBlueButtonStyle())
                Spacer()
                Button("Save") {
                    showProgressView = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulating a delay for demonstration purposes
                        if isProcedure {
                            print("Saving PROCEDURE to job: \(selectedJob)")
                        }
                        if isWeld {
                            print("Saving WELD to job: \(selectedJob)---procedure: \(selectedProcedure)---welder: \(selectedWelder)")
                        }
                        if isWelder {
                            print("Saving WELDER to job: \(selectedJob)---procedure: \(selectedProcedure)")
                        }
                        
                        showProgressView = false // Hide the ProgressView after saving
                        showReceivedData = false
                        multipeerManager.receivedWeldData = false
                        multipeerManager.receivedProcedureData = false
                        multipeerManager.receivedWelderData = false
                    }
                }
                .buttonStyle(BorderedBlueButtonStyle())
                .disabled(!activeButton)
                .overlay(
                    Group {
                        if showProgressView {
                            ProgressView("Saving data...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.white.opacity(0.8))
                        }
                    }
                )
                Spacer()
            }
        }
        .padding()
        .onAppear {
            reloadProcedureOptions()
        }
        .onChange(of: selectedJob) {
            selectedProcedure = ""
            reloadProcedureOptions()
            if isProcedure && !selectedJob.isEmpty {
                activeButton = true
            } else {
                activeButton = false
            }
        }
       
    }
    
    func addCustomJobOption() {
        if !customJobOption.isEmpty {
            jobOptions.append(customJobOption)
            let newJob = WeldingInspector.Job(name: customJobOption, weldingProcedures: [])
            mainViewModel.weldingInspector.jobs.append(newJob)
            customJobOption = ""
        }
    }
    
    func addCustomProcedureOption() {
        if !customProcedureOption.isEmpty {
            procedureOptions.append(customProcedureOption)
            guard let selectedJobIndex = getSelectedJobIndex() else {
                return
            }
            let newProcedure = WeldingInspector.Job.WeldingProcedure(name: customProcedureOption, type: "", usage: "", owner: "", weldPass: [], weldersQualified: [])
            mainViewModel.weldingInspector.jobs[selectedJobIndex].weldingProcedures.append(newProcedure)
            customProcedureOption = ""
        }
    }
    
    func addCustomWelderOption() {
        if !customWelderOption.isEmpty {
            welderOptions.append(customWelderOption)
            guard let selectedJobIndex = getSelectedJobIndex() else {
                return
            }
            guard let selectedProcedureIndex = getSelectedProcedureIndex(selectedJobIndex: selectedJobIndex) else {
                return
            }
            let newWelder = WeldingInspector.Job.WeldingProcedure.Welder(name: customWelderOption, welderId: "", pressureNumber: "", pressureExpiry: "", welds: [])
            mainViewModel.weldingInspector.jobs[selectedJobIndex].weldingProcedures[selectedProcedureIndex].weldersQualified.append(newWelder)
            customWelderOption = ""
        }
    }
    
    func getSelectedJobIndex() -> Int? {
        return mainViewModel.weldingInspector.jobs.firstIndex(where: { $0.name == selectedJob })
    }
    
    func getSelectedProcedureIndex(selectedJobIndex: Int) -> Int? {
        return mainViewModel.weldingInspector.jobs[selectedJobIndex].weldingProcedures.firstIndex(where: { $0.name == selectedProcedure })
    }
    
    func getSelectedWelderIndex(selectedJobIndex: Int, selectedProcedureIndex: Int) -> Int? {
        return mainViewModel.weldingInspector.jobs[selectedJobIndex].weldingProcedures[selectedProcedureIndex].weldersQualified.firstIndex(where: { $0.name == selectedWelder })
    }
    
    func reloadProcedureOptions() {
        guard let selectedJobIndex = getSelectedJobIndex() else {
            procedureOptions = []
            return
        }
        
        procedureOptions = mainViewModel.weldingInspector.jobs[selectedJobIndex].weldingProcedures.map { $0.name }
    }
    
    func reloadWelderOptions() {
        guard let selectedJobIndex = getSelectedJobIndex() else {
            procedureOptions = []
            return
        }
        guard let selectedProcedureIndex = getSelectedProcedureIndex(selectedJobIndex: selectedJobIndex) else {
            welderOptions = []
            return
        }
        welderOptions = mainViewModel.weldingInspector.jobs[selectedJobIndex].weldingProcedures[selectedProcedureIndex].weldersQualified.map { $0.name }
    }
}


struct ReceiveDataView_Previews: PreviewProvider {
    @State static var showReceivedData = true
    static var previews: some View {
        let mainViewModel = MainViewModel()
        let multipeerManager = MultipeerConnectivityManager()
        
        // Preview 1 pass in WeldNumber
        let newWeldData = mainViewModel.weldingInspector.jobs[0].weldingProcedures[0].weldersQualified[0].welds[0]
        let preview1 = ReceiveDataView(mainViewModel: mainViewModel, showReceivedData: $showReceivedData, newWeldData: newWeldData)
            .environmentObject(multipeerManager)
        
        // Preview 2
        let newProcedureData = mainViewModel.prepareProcedure(procedure: mainViewModel.weldingInspector.jobs[0].weldingProcedures[0])
        let preview2 = ReceiveDataView(mainViewModel: mainViewModel, showReceivedData: $showReceivedData, newProcedureData: newProcedureData)
            .environmentObject(multipeerManager)
        
        // Preview 3
        let newWelderData = mainViewModel.prepareWelder(welder: mainViewModel.weldingInspector.jobs[0].weldingProcedures[0].weldersQualified[0])
        let preview3 = ReceiveDataView(mainViewModel: mainViewModel, showReceivedData: $showReceivedData, newWelderData: newWelderData)
            .environmentObject(multipeerManager)
        
        return Group {
            preview1
            preview2
            preview3
        }
        
    }
}
