//
//  WeldParameterView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-15.
//

import SwiftUI
import Combine

struct WeldPassView: View {
    
   
    @ObservedObject var mainViewModel: MainViewModel
    
    var selectedWeldNumber: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers?
    
    @State private var selectedItemForDeletion: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters?
    @State private var selectedWeldPass: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters?
    @State private var showProfileView = false
    @State private var addParametersPass = false
    @State private var editParametersPass = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Parameters Collected")
                        .font(.title)
                    Spacer()
                    // Add new item to list of jobs
                    Button {
                        addParametersPass = true
                    }label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
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
                Spacer()

                // Iterate over collectedParameters stored in the weldNumber data Model
                List {
                    if let passParameter = selectedWeldNumber?.parametersCollected, !passParameter.isEmpty {
                        ForEach(Array(passParameter.enumerated()), id: \.element.id) { index, pass in
                            NavigationLink(destination: PassParameterView(mainViewModel: mainViewModel, selectedWeldPass: pass)) {
                                Text(pass.passName)
                            }
                            .contextMenu {
                                Button(action: {
                                    // Edit action
                                    mainViewModel.setSelectedWeldPass(weldPass: pass)
                                    selectedWeldPass = pass
                                    editParametersPass = true
                                    
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button(action: {
                                    // Delete action
                                    selectedItemForDeletion = mainViewModel.selectedWeldNumber?.parametersCollected[index]
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                selectedItemForDeletion = mainViewModel.selectedWeldNumber?.parametersCollected[index]
                            }
                        }
                    } else {
                        Text("No passes available")
                        Text("Add weld pass to list of collected parameters")
                    }
                }
            }
            .onAppear{
                if selectedWeldNumber != nil {
                    mainViewModel.setSelectedWeldNumber(weldId: selectedWeldNumber!)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showProfileView = true
                        
                    }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showProfileView) {
                ProfileView(mainViewModel: mainViewModel,isPresented: $showProfileView)
            }
            .alert(item: $selectedItemForDeletion) { pass in
                Alert(
                    title: Text("Delete Weld Pass"),
                    message: Text("Are you sure you want to delete \(pass.passName)? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let index = mainViewModel.selectedWeldNumber?.parametersCollected.firstIndex(where: { $0.id == pass.id }) {
                            mainViewModel.deleteSelectedWeldPass(index: index)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $addParametersPass, content: {
                // Add new job item view
                AddParametersView(mainViewModel: mainViewModel, isPresented: $addParametersPass)
            })
            .sheet(isPresented: $editParametersPass, content: {
                // Add new job item view
                AddParametersView(mainViewModel: mainViewModel, isPresented: $editParametersPass, selectedWeldPass: selectedWeldPass)
            })
        }
    }
}






struct WeldPassView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        mockMainViewModel.weldingInspector = loadSample() // Initialize with default data or mock data

        return WeldPassView(mainViewModel: mockMainViewModel, 
                                 selectedWeldNumber: mockMainViewModel.weldingInspector.jobs[1].weldingProcedures[0].weldersQualified[0].welds[0])
    }
}

