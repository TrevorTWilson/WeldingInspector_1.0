//
//  PassParameterView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-22.
//

import SwiftUI

struct PassParameterView: View {
    

    @ObservedObject var mainViewModel: MainViewModel
    var selectedWeldPass: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters?
    
    @State private var selectedItemForDeletion: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters?
    @State private var addWeldParameters = false
    @State private var isExpanded = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Parameters Collected")
                        .font(.title)
                    Spacer()
                    // Add new item to list of jobs
                    Button {
                        addWeldParameters = true
                    }label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
                VStack {
                        DisclosureGroup("Expand Weld Details", isExpanded: $isExpanded) {
                            if isExpanded {
                                HStackContent()
                            }
                        }
                    }
                
                Spacer()
                
                // Define the keys in the desired order
                let orderedKeys = ["Amps", "Volts", "Distance", "Time", "ArcSpeed", "HeatInput"]
                
                // Iterate over the orderedKeys array and extract key-value pairs from the dictionary
                VStack {
                    Text("Weld Pass: \(selectedWeldPass?.passName ?? "Pass Name")") // Provide a default value in case selectedWeldPass?.passName is nil
                        .font(.largeTitle)
                        .padding()
                    
                    List {
                        ForEach(orderedKeys, id: \.self) { key in
                            KeyValueRow(key: key, value: selectedWeldPass?.collectedValues[key])
                        }
                    }
                }


                Spacer()
            }
            .onAppear(){
                if selectedWeldPass != nil {
                    mainViewModel.setSelectedWeldPass(weldPass: selectedWeldPass!)
                }
            }
            .sheet(isPresented: $addWeldParameters, content: {
                // Add new job item view
                CollectParametersView(mainViewModel: mainViewModel, isPresented: $addWeldParameters)
            })
        }
    }
    
    @ViewBuilder
    func HStackContent() -> some View {
        HStack{
            Text("Current Job: ")
            Spacer()
            Text(mainViewModel.selectedJob?.name ?? "Title")
        }
        HStack{
            Text("Current Procedure: ")
            Spacer()
            Text(mainViewModel.selectedWeldingProcedure?.name ?? "Title")
        }
        HStack{
            Text("Current Welder: ")
            Spacer()
            Text(mainViewModel.selectedWelder?.name ?? "Title")
        }
        HStack{
            Text("Current Weld Number: ")
            Spacer()
            Text(mainViewModel.selectedWeldNumber?.name ?? "Number")
        }
        HStack{
            Text("Current Pass Name: ")
            Spacer()
            Text(mainViewModel.selectedWeldPass?.passName ?? "passName")
        }
    }
}

struct PassParameterView_Preview: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        mockMainViewModel.weldingInspector = loadSample() // Initialize with default data or mock data
        
        return PassParameterView(mainViewModel: mockMainViewModel,
                                 selectedWeldPass: mockMainViewModel.weldingInspector.jobs[1].weldingProcedures[0].weldersQualified[0].welds[0].parametersCollected[0])
    }
}

