//
//  MainMenu.swift
//  RewriteVersion4
//
//  Created by Trevor Wilson on 2024-02-03.
//

import SwiftUI
import Combine

struct MainJobView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var multipeerManager: MultipeerConnectivityManager
    @State private var selectedItemForDeletion: WeldingInspector.Job?
    @State private var showProfileView = false
    @State private var addNewJob = false
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
                        Text("Select a Job")
                            .font(.title)
                        Spacer()
                        // Add new item to list of jobs
                        Button {
                            addNewJob = true
                        }label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
                    }
                    Spacer()
                    List {
                        ForEach(Array(mainViewModel.weldingInspector.jobs.enumerated()), id: \.element.id) { index, job in
                            NavigationLink(destination: ProcedureView(selectedJob: job)) {
                                Text(job.name)
                            }
                            .contextMenu {
                                Button(action: {
                                    // Edit action
                                    // Implement editing functionality here
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                Button(action: {
                                    // Delete action
                                    selectedItemForDeletion = mainViewModel.weldingInspector.jobs[index]
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                selectedItemForDeletion = mainViewModel.weldingInspector.jobs[index]
                            }
                        }
                    }
                }
                .navigationTitle("Main Menu")
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
                .alert(item: $selectedItemForDeletion) { job in
                    Alert(
                        title: Text("Delete Job"),
                        message: Text("Are you sure you want to delete \(job.name)? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            if let index = mainViewModel.weldingInspector.jobs.firstIndex(where: { $0.id == job.id }) {
                                mainViewModel.deleteSelectedJob(index: index)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .sheet(isPresented: $showProfileView) {
                    ProfileView(mainViewModel: mainViewModel, isPresented: $showProfileView)
                }
                .sheet(isPresented: $addNewJob, content: {
                    // Add new job item view
                    AddJobView(mainViewModel: mainViewModel, isPresented: $addNewJob)
                })
                .onChange(of: multipeerManager.recievedInvite) {
                    newInvite = multipeerManager.recievedInvite
                }
                .onChange(of: multipeerManager.receivedWeldData) {
                    newWeld = multipeerManager.receivedWeldData
                }
                .onChange(of: multipeerManager.receivedProcedureData) {
                    newProcedure = multipeerManager.receivedProcedureData
                }
                .onChange(of: multipeerManager.receivedWelderData) {
                    newWelder = multipeerManager.receivedWelderData
                }
            }
        }
    }
}


struct MainJobView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        let mockConnectionManager = MultipeerConnectivityManager()
        
        return MainJobView()
            .environmentObject(mockMainViewModel)
            .environmentObject(mockConnectionManager)
    }
}


