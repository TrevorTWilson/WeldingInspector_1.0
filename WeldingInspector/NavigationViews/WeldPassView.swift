//
//  WeldParameterView.swift
//  RewriteVersion4
//
//  Created by Trevor Wilson on 2024-02-15.
//

import SwiftUI
import Combine

struct WeldPassView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var multipeerManager: MultipeerConnectivityManager
    
    var selectedWeldNumber: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers?
    
    @State private var selectedItemForDeletion: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters?
    @State private var selectedWeldPass: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters?
    @State private var showProfileView = false
    @State private var addParametersPass = false
    @State private var editParametersPass = false
    @State private var newInvite = false
    @State private var newWeld = false
    @State private var newProcedure = false
    @State private var newWelder = false
    
    var body: some View {
        
        if newInvite {
            RecievedInvite(showRecievedInvite: $newInvite)
        } else if newWeld {
            ReceiveDataView(mainViewModel: mainViewModel, showReceivedData: $newWeld, newWeldData: multipeerManager.receivedWeld)
        } else if newProcedure {
            ReceiveDataView(mainViewModel: mainViewModel, showReceivedData: $newProcedure, newProcedureData: multipeerManager.receivedProcedure)
        } else if newWelder {
            ReceiveDataView(mainViewModel: mainViewModel, showReceivedData: $newWelder, newWelderData: multipeerManager.receivedWelder)
        } else {
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
                                NavigationLink(destination: PassParameterView(selectedWeldPass: pass)) {
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
                        ReusableLeadingToolbarItemView {
                            showProfileView.toggle()
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        ReusableTrailingToolbarItemView(isDiscoverable: $multipeerManager.isDiscoverable)
                    }

                }
                .sheet(isPresented: $showProfileView) {
                    ProfileView(mainViewModel: mainViewModel, isPresented: $showProfileView)
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
                .onChange(of: multipeerManager.recievedInvite) {
                    newInvite = multipeerManager.recievedInvite
                }
                .onChange(of: multipeerManager.receivedWeldData) {
                    newWeld = multipeerManager.receivedWeldData
                    multipeerManager.receivedWeldData = false
                }
                .onChange(of: multipeerManager.receivedProcedureData) {
                    newProcedure = multipeerManager.receivedProcedureData
                    multipeerManager.receivedProcedureData = false
                }
                .onChange(of: multipeerManager.receivedWelderData) {
                    newWelder = multipeerManager.receivedWelderData
                    multipeerManager.receivedWelderData = false
                }
            }
        }
    }
}






struct WeldPassView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        let mockConnectionManager = MultipeerConnectivityManager()

        return WeldPassView(selectedWeldNumber: mockMainViewModel.weldingInspector.jobs[1].weldingProcedures[0].weldersQualified[0].welds[0])
            .environmentObject(mockMainViewModel)
            .environmentObject(mockConnectionManager)
    }
}

