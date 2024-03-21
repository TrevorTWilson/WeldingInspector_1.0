//
//  AddJobView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-15.
//

import SwiftUI
import Combine

struct AddJobView: View {

    @ObservedObject var mainViewModel: MainViewModel
    var selectedJob: WeldingInspector.Job?
    @State private var jobName = ""
    @State private var savedItems: [String: WeldingInspector.Job.WeldingProcedure] = [:]
    @State private var addProcedures: [WeldingInspector.Job.WeldingProcedure]?
    @State private var selectedWeldingProcedures: [WeldingInspector.Job.WeldingProcedure] = []
    @State private var proceduresAvailableLabel: String = ""
    @State private var isExpanded: Bool = false
    @State private var isAlertPresented = false
    
    @Binding var isPresented: Bool
    
    
    
    func addJob(){
        print("AddJob function called")
        mainViewModel.addJob(name: jobName, weldingProcedures: selectedWeldingProcedures)
        isPresented = false
    }
    
    var body: some View {
        Form {
            Section(header: Text("Job Details")){
                Text("Enter The Job Name")
                TextField("New Job Name", text: $jobName)
                    .onSubmit {
                        if jobName != "" {
                            addJob()
                        } else {
                            isAlertPresented = true
                        }
                    }
            }
            Section{
                VStack {
                    let items = mainViewModel.getAllWeldingProcedure()
                    //let items = [:]
                    if items.isEmpty {
                        Text("There are no Welding Procedures available on this device")
                            .font(.system(size: 14))
                    } else {
                        Text("Welding Procedures are available on this device")
                            .font(.system(size: 14))
                        
                            MultipleSelectionPicker(items: Array(items.keys), onSave: { selectedItems in
                                self.savedItems = items.filter { selectedItems.contains($0.key) }
                                // Extract values from the dictionary to the array
                                self.selectedWeldingProcedures = Array(self.savedItems.values)
                                print(selectedWeldingProcedures)
                            }, buttonLabel: "Add")
                        
                    }
                }
            }
            Section{
                if selectedWeldingProcedures.isEmpty {
                    Text("No Procedures linked to \(jobName)")
                } else {
                    Text("Procedures linked to \(jobName)")
                }
            }
            HStack{
                GeometryReader { geometry in
                    HStack {
                        Button("Add Job") {
                            if jobName != "" {
                                addJob()
                            } else {
                                isAlertPresented = true
                            }
                        }
                        .disabled(jobName.isEmpty)
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
        }
        .navigationTitle("Add New Job Item")
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text("Error"),
                message: Text("Job name cannot be blank"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


struct AddJobView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented: Bool = true
        AddJobView(mainViewModel: MainViewModel(), isPresented: $isPresented)
    }
}
