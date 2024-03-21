//
//  WelderView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-15.
//

import SwiftUI
import Combine

struct WelderView: View {
   
    @ObservedObject var mainViewModel: MainViewModel

    var selectedWeldingProcedure: WeldingInspector.Job.WeldingProcedure?
    var selectedWelders: WeldingInspector.Job.WeldingProcedure.Welder?

    @State private var selectedItemForDeletion: WeldingInspector.Job.WeldingProcedure.Welder?
    @State private var showProfileView = false
    @State private var addNewWelder = false
    @State private var editWelder = false
    @State private var selectedWelder: WeldingInspector.Job.WeldingProcedure.Welder? = nil
    
    var body: some View {
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
                            NavigationLink(destination: WelderNumberView(mainViewModel: mainViewModel, selectedWelder: welder)) {
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
            .sheet(isPresented: $addNewWelder, content: {
                // Add new welder item view
                AddWelderView(mainViewModel: mainViewModel, isPresented: $addNewWelder)
            })
            .sheet(isPresented: $editWelder, content: {
                // Edit existing welder
                AddWelderView(mainViewModel: mainViewModel, isPresented: $editWelder, selectedWelder: selectedWelder)
            })
        }
    }
    
}

struct WelderView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        mockMainViewModel.weldingInspector = loadSample() // Initialize with default data or mock data

        return WelderView(mainViewModel: mockMainViewModel,  selectedWeldingProcedure: mockMainViewModel.weldingInspector.jobs[1].weldingProcedures[0])
    }
}
