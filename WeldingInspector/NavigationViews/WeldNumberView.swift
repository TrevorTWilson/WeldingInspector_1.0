//
//  WeldNumberView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-15.
//

import SwiftUI
import Combine

struct WelderNumberView: View {
    

    @ObservedObject var mainViewModel: MainViewModel

    var selectedWelder: WeldingInspector.Job.WeldingProcedure.Welder?
    
    @State private var selectedWeldNumber: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers?
    @State private var selectedItemForDeletion: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers?
    @State private var showProfileView = false
    @State private var addNewWeldNumber = false
    @State private var editWeldNumber = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Select a Weld Number")
                        .font(.title)
                    Spacer()
                    // Add new item to list of jobs
                    Button {
                        addNewWeldNumber = true
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
                Spacer()
                // Iterate through list of procedures in instance of WeldingInspector for navigation list of each
                List {
                    if let weldNumbers = selectedWelder?.welds, !weldNumbers.isEmpty {
                        ForEach(Array(weldNumbers.enumerated()), id: \.element.id) { index, weldID in
                            NavigationLink(destination: WeldPassView(mainViewModel: mainViewModel, selectedWeldNumber: weldID)) {
                                Text(weldID.name)
                            }
                            .contextMenu {
                                Button(action: {
                                    // Edit action
                                    mainViewModel.setSelectedWeldNumber(weldId: weldID)
                                    selectedWeldNumber = weldID
                                    editWeldNumber = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button(action: {
                                    // Delete action
                                    selectedItemForDeletion = mainViewModel.selectedWelder?.welds[index]
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                selectedItemForDeletion = mainViewModel.selectedWelder?.welds[index]
                            }
                        }
                    } else {
                        Text("No Numbers available")
                        Text("Add weld number to list of collected parameters")
                    }
                }
            }
            .onAppear{
                if selectedWelder != nil {
                    mainViewModel.setSelectedWelder(welder: selectedWelder!)
                }
            }
            .alert(item: $selectedItemForDeletion) { weldId in
                Alert(
                    title: Text("Delete Weld Number"),
                    message: Text("Are you sure you want to delete \(weldId.name)? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let index = mainViewModel.selectedWelder?.welds.firstIndex(where: { $0.id == weldId.id }) {
                            mainViewModel.deleteSelectedWeldNumber(index: index)
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
            .sheet(isPresented: $addNewWeldNumber, content: {
                // Add new job item view
                AddWeldNumberView( mainViewModel: mainViewModel, isPresented: $addNewWeldNumber)
            })
            .sheet(isPresented: $editWeldNumber, content: {
                // Add new job item view
                AddWeldNumberView( mainViewModel: mainViewModel, isPresented: $editWeldNumber, selectedWeldNumber: selectedWeldNumber )
            })
        }
    }
}


struct WeldNumberView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        mockMainViewModel.weldingInspector = loadSample() // Initialize with default data or mock data

        return WelderNumberView(mainViewModel: mockMainViewModel,
                                selectedWelder: mockMainViewModel.weldingInspector.jobs[1].weldingProcedures[0].weldersQualified[0])
    }
}
