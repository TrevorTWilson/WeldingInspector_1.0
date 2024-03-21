//
//  AddParametersView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-15.
//

import SwiftUI
import Combine

struct AddParametersView: View {
    
    @ObservedObject var mainViewModel: MainViewModel
    @State private var passName: String
    @State private var procedurePass: WeldingInspector.Job.WeldingProcedure.WeldPass
    @Binding var isPresented: Bool
    @State private var selectedPassIndex: Int?
    
    var weldPassList: [WeldingInspector.Job.WeldingProcedure.WeldPass] {
        if let weldingProcedure = mainViewModel.selectedWeldingProcedure {
            return weldingProcedure.weldPass
        }
        return []
    }
    
    let defaultPass = WeldingInspector.Job.WeldingProcedure.WeldPass(passName: "None", minRanges: ["Amps": 90, "Volts": 7, "ArcSpeed": 50, "HeatInput": 0.3], maxRanges: ["Amps": 350, "Volts": 35, "ArcSpeed": 1000, "HeatInput": 3.0])
    
    var procedurePassDefault: WeldingInspector.Job.WeldingProcedure.WeldPass {
            if let firstPass = mainViewModel.selectedWeldingProcedure?.weldPass.first {
                return firstPass
            } else {
                return defaultPass
            }
        }
    
    var selectedWeldPass: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters?
    
    @State private var sectionTitle: String = "Add"
    
    public init(mainViewModel: MainViewModel, isPresented: Binding<Bool>, selectedWeldPass: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters? = nil) {
        self.mainViewModel = mainViewModel
        self._passName = State(initialValue: selectedWeldPass?.passName ?? "")
        self._isPresented = isPresented
        self.selectedWeldPass = selectedWeldPass
        
        if let firstPass = mainViewModel.selectedWeldingProcedure?.weldPass.first {
            let initialProcedurePass = firstPass
            self._procedurePass = State(initialValue: initialProcedurePass)
            print("weldList first name")
        } else {
            self._procedurePass = State(initialValue: defaultPass)
            print("defaultPass name")
        }
        print("procedurePass name: \(procedurePass.passName)")
    }

    
    func addParameters() {
        
        if selectedWeldPass != nil {
            print("Edit using procedurePass: \(procedurePass.passName)")
            mainViewModel.updateParameters(passName: passName, procedurePass: procedurePass)
        } else {
            print("Add using procedurePass: \(procedurePass.passName)")
            mainViewModel.addParameters(passName: passName, procedurePass: procedurePass)
        }
        
        isPresented = false
    }

    
    var body: some View {
        Form {
            Section(header: Text("\(sectionTitle) Weld Pass")) {
                Picker("Select Pass For Ranges", selection: $procedurePass) {
                    ForEach(weldPassList) { pass in
                        Text(pass.passName).tag(pass)
                    }
                }
            }
            .pickerStyle(.segmented)
            
            Section(header: Text("\(sectionTitle) Weld Pass")){
                Text("\(sectionTitle) Pass Name")
                TextField("\(sectionTitle) Pass Name Here", text: $passName)
            }
            
            GeometryReader { geometry in
                HStack{
                    Button("\(sectionTitle) Pass Name") {
                        addParameters()
                    }
                    .disabled(passName.isEmpty)
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
        .navigationTitle("Add New Pass")
        .onAppear {
            if let selectedWeldPass = selectedWeldPass {
                // Populate form fields with selected welder's data for editing
                passName = selectedWeldPass.passName
                procedurePass = selectedWeldPass.procedurePass
                sectionTitle = "Edit"
                
                // set default selectedPassIndex to the index of the selected pass
                selectedPassIndex = weldPassList.firstIndex(where: { $0.passName == selectedWeldPass.passName })
            }
        }
    }
}

struct AddParametersView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented: Bool = true
        let mockMainViewModel = MainViewModel()
        mockMainViewModel.weldingInspector = loadSample() // Initialize with default data or mock data

        mockMainViewModel.setSelectedProcedure(procedure: mockMainViewModel.weldingInspector.jobs[1].weldingProcedures[1])
        
        return AddParametersView(mainViewModel: mockMainViewModel, isPresented: $isPresented)
    }
}

