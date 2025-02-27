//
//  WelderView.swift
//  RewriteVersion4
//
//  Created by Trevor Wilson on 2024-02-15.
//

import SwiftUI
import Combine

struct WelderView: View {
   
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var multipeerManager: MultipeerConnectivityManager

    var selectedWeldingProcedure: WeldingInspector.Job.WeldingProcedure?
    var selectedWelders: WeldingInspector.Job.WeldingProcedure.Welder?

    @State private var selectedItemForDeletion: WeldingInspector.Job.WeldingProcedure.Welder?
    @State private var showProfileView: Bool = false
    @State private var addNewWelder: Bool = false
    @State private var editWelder: Bool = false
    @State private var selectedWelder: WeldingInspector.Job.WeldingProcedure.Welder? = nil
    @State private var newInvite: Bool = false
    @State private var newWeld: Bool = false
    @State private var newProcedure: Bool = false
    @State private var newWelder: Bool = false
    @State private var sendWelderView: Bool = false
    
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
                        Text("Current Procedure: ")
                        Text(mainViewModel.selectedWeldingProcedure?.name ?? "Title")
                    }
                    HStack{
                        Text("Select a Welder")
                            .font(.title)
                        Spacer()
                        // Add new item to list of jobs
                        Button {
                            addNewWelder = true
                        }label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
                    }
                    Spacer()
                    // Iterate through list of procedures in instance of WeldingInspector for navigation list of each
                    List {
                        if let welders = selectedWeldingProcedure?.weldersQualified, !welders.isEmpty {
                            ForEach(Array(welders.enumerated()), id: \.element.id) { index, welder in
                                NavigationLink(destination: WelderNumberView(selectedWelder: welder)) {
                                    Text(welder.name)
                                }
                                .contextMenu {
                                    Button(action: {
                                        // Edit action
                                        mainViewModel.setSelectedWelder(welder: welder)
                                        selectedWelder = welder
                                        editWelder = true
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    
                                    Button(action: {
                                        // Delete action
                                        selectedItemForDeletion = mainViewModel.selectedWeldingProcedure?.weldersQualified[index]
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    // TODO: code send for welder
                                    Button(action: {
                                        // Send action
                                        let preparedWelder = mainViewModel.prepareWelder(welder: welder)
                                        multipeerManager.welderToSend = preparedWelder
                                        sendWelderView = true
                                    })  {
                                        Label("Send", systemImage: "square.and.arrow.up")
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                if let index = indexSet.first {
                                    selectedItemForDeletion = mainViewModel.selectedWeldingProcedure?.weldersQualified[index]
                                }
                            }
                        } else {
                            Text("No welders available")
                            Text("Add qualified welder to current procedure")
                        }
                    }
                }
                .onAppear{
                    if selectedWeldingProcedure != nil {
                        mainViewModel.setSelectedProcedure(procedure: selectedWeldingProcedure!)
                    }
                }
                
                .alert(item: $selectedItemForDeletion) { welder in
                    Alert(
                        title: Text("Delete Welder"),
                        message: Text("Are you sure you want to delete \(welder.name)? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            if let index = mainViewModel.selectedWeldingProcedure?.weldersQualified.firstIndex(where: { $0.id == welder.id }) {
                                mainViewModel.deleteSelectedWelder(index: index)
                            }
                        },
                        secondaryButton: .cancel()
                    )
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
                .sheet(isPresented: $addNewWelder, content: {
                    // Add new welder item view
                    AddWelderView(mainViewModel: mainViewModel, isPresented: $addNewWelder)
                })
                .sheet(isPresented: $editWelder, content: {
                    // Edit existing welder
                    AddWelderView(mainViewModel: mainViewModel, isPresented: $editWelder, selectedWelder: selectedWelder)
                })
                .sheet(isPresented: $sendWelderView, content: {
                    // Add new job item view
                    SendWeldDataView(isPresented: $sendWelderView)
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

struct WelderView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        let mockConnectionManager = MultipeerConnectivityManager()
        
        return WelderView(selectedWeldingProcedure: mockMainViewModel.weldingInspector.jobs[1].weldingProcedures[0])
            .environmentObject(mockMainViewModel)
            .environmentObject(mockConnectionManager)
    }
}
