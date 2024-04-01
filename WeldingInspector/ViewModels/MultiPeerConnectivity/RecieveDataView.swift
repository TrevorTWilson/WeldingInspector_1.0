//
//  RecieveDataView.swift
//  WeldingInspector
//
//  Created by trevor wilson on 2024-04-01.
//

import SwiftUI

struct ReceiveDataView: View {
    
    @ObservedObject var mainViewModel: MainViewModel
    
    @State private var selectedJob: String = ""
    @State private var customJobOption: String = ""
    
    @State private var selectedProcedure: String = ""
    @State private var customProcedureOption: String = ""
    
    @State private var selectedWelder: String = ""
    @State private var customWelderOption: String = ""
    
    @State private var jobOptions: [String] = []
    @State private var procedureOptions: [String] = []
    @State private var welderOptions: [String] = []
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        _jobOptions = State(initialValue: Array(mainViewModel.getAllJobs().keys))
    }
    
    var body: some View {
        VStack {
            Picker(selection: $selectedJob, label: Text("Job Picker")) {
                ForEach(jobOptions, id: \.self) { jobName in
                    Text(jobName)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            HStack {
                TextField("Enter Custom Job Option", text: $customJobOption)
                Button(action: {
                    self.addCustomJobOption()
                }) {
                    Text("Add Custom Option")
                }
            }
            
            Text("Selected Job: \(selectedJob)")

            if let selectedJobIndex = getSelectedJobIndex() {
                Text("Selected Job Index: \(selectedJobIndex)")
                
                Picker(selection: $selectedProcedure, label: Text("Procedure Picker")) {
                    ForEach(procedureOptions, id: \.self) { procedureName in
                        Text(procedureName)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                HStack {
                    TextField("Enter Custom Procedure Option", text: $customProcedureOption)
                    Button(action: {
                        self.addCustomProcedureOption()
                    }) {
                        Text("Add Custom Option")
                    }
                }
                
                Text("Selected Procedure: \(selectedProcedure)")
                
                if let selectedProcedureIndex = getSelectedProcedureIndex(selectedJobIndex: selectedJobIndex) {
                    Text("Selected Procedure Index: \(selectedProcedureIndex)")
                    
                    Picker(selection: $selectedWelder, label: Text("Welder Picker")) {
                        ForEach(welderOptions, id: \.self) { welderName in
                            Text(welderName)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    HStack {
                        TextField("Enter Custom Welder Option", text: $customWelderOption)
                        Button(action: {
                            self.addCustomWelderOption()
                        }) {
                            Text("Add Custom Option")
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
                    Text("Selected Welder \(selectedWelder)")
                    
                    if let selectedWelderIndex = getSelectedWelderIndex(selectedJobIndex: selectedJobIndex, selectedProcedureIndex: selectedProcedureIndex) {
                        Text("Selected Welder Index: \(selectedWelderIndex)")
                    }
                }
            } else {
                Text("Selected Job Index: N/A")
            }

        }
        .padding()
        .onAppear {
            reloadProcedureOptions()
        }
        .onChange(of: selectedJob) {
            selectedProcedure = ""
            reloadProcedureOptions()
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
    static var previews: some View {
        ReceiveDataView(mainViewModel: MainViewModel())
    }
}
