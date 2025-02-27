//
//  ProcedureView.swift
//  RewriteVersion4
//
//  Created by Trevor Wilson on 2024-02-13.
//

import SwiftUI
import Combine

struct ProcedureView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var multipeerManager: MultipeerConnectivityManager
    
    var selectedJob: WeldingInspector.Job?
    var selectedProcedure: WeldingInspector.Job.WeldingProcedure?
    
    @State private var selectedItemForDeletion: WeldingInspector.Job.WeldingProcedure?
    @State private var showProfileView = false
    @State private var addNewProcedure = false
    @State private var showProcedureFormView = false
    @State private var sendWeldProcedureView = false
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
                        Text("Current Job: ")
                        Text(mainViewModel.selectedJob?.name ?? "Title")
                    }
                    HStack{
                        Text("Select a Procedure")
                            .font(.title)
                        Spacer()
                        // Add new item to list of jobs
                        Button {
                            addNewProcedure = true
                        }label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
                    }
                    Spacer()
                    // Iterate through list of procedures in instance of WeldingInspector for navigation list of each
                    List {
                        
                        if let weldingProcedures = selectedJob?.weldingProcedures, !weldingProcedures.isEmpty {
                            ForEach(Array(weldingProcedures.enumerated()), id: \.element.id) { index, procedure in
                                NavigationLink(destination: WelderView(selectedWeldingProcedure: procedure)) {
                                    Text(procedure.name)
                                }
                                .contextMenu {
                                    Button(action: {
                                        // Edit action
                                        // Implement editing functionality here
                                        mainViewModel.setSelectedProcedure(procedure: procedure)
                                        showProcedureFormView = true
                                        
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    
                                    Button(action: {
                                        // Delete action
                                        print(selectedItemForDeletion as Any)
                                        //selectedItemForDeletion = mainViewModel.selectedJob?.weldingProcedures[index]
                                        selectedItemForDeletion = procedure
                                        
                                        print(selectedItemForDeletion as Any)
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    Button(action: {
                                        // Send action
                                        let preparedProcedure = mainViewModel.prepareProcedure(procedure: procedure)
                                        multipeerManager.procedureToSend = preparedProcedure
                                        sendWeldProcedureView = true
                                    })  {
                                        Label("Send", systemImage: "square.and.arrow.up")
                                    }
                                }
                            }
                            
                            
                        } else {
                            Text("No welding procedures available")
                            Text("Add welding procedures to the selected Job")
                        }
                    }
                    
                }
                .onAppear{
                    if selectedJob != nil {
                        mainViewModel.setSelectedJob(job: selectedJob!)
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
                .alert(item: $selectedItemForDeletion) { procedure in
                    Alert(
                        title: Text("Delete Procedure"),
                        message: Text("Are you sure you want to delete \(procedure.name)? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            if let index = mainViewModel.selectedJob?.weldingProcedures.firstIndex(where: { $0.id == procedure.id }) {
                                print("Alert Index: \(index)")
                                mainViewModel.deleteSelectedProcedure(index: index)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .sheet(isPresented: $showProfileView) {
                    ProfileView(mainViewModel: mainViewModel, isPresented: $showProfileView)
                }
                .sheet(isPresented: $addNewProcedure, content: {
                    AddProcedureView(mainViewModel: mainViewModel, isPresented: $addNewProcedure)
                })
                .sheet(isPresented: $showProcedureFormView) {
                    if let selectedProcedure = mainViewModel.selectedWeldingProcedure {
                        WeldingProcedureFormView(mainViewModel: mainViewModel, isPresented: $showProcedureFormView, selectedWeldingProcedure: selectedProcedure)
                    } else {
                        WeldingProcedureFormView(mainViewModel: mainViewModel, isPresented: $showProcedureFormView)
                    }
                }
                .sheet(isPresented: $sendWeldProcedureView, content: {
                    // Add new job item view
                    SendWeldDataView(isPresented: $sendWeldProcedureView)
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


struct ProcedureView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        let mockConnectionManager = MultipeerConnectivityManager()
        // set selected job in mainViewModel
        
        //mockMainViewModel.weldingInspector = loadSample() // Initialize with default data or mock data
        
        return ProcedureView(selectedJob: mockMainViewModel.weldingInspector.jobs[0])
            .environmentObject(mockMainViewModel)
            .environmentObject(mockConnectionManager)
    }
}


