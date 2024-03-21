//
//  AddProcedurePass.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-02.
//

import SwiftUI

struct AddProcedurePass: View {
    @ObservedObject var mainViewModel: MainViewModel
    @Binding var isPresented: Bool
    @State private var passName: String = ""
    var selectedProcedure: WeldingInspector.Job.WeldingProcedure? // Optional parameter for selected procedure
    
  
    func addPass(){
        print("send to mainviewmodel")
        mainViewModel.addProcedurePass(name: passName)
       
        isPresented = false
    }
    
    var body: some View {
        Form {
            TextField("New Pass Name", text: $passName)
                .onSubmit {
                    addPass()
                }
            HStack{
                Button("Add Pass") {
                    addPass()
                }
                Spacer()
                Button("Cancel") {
                    isPresented = false
                }
            }
        }
        .navigationTitle("Add New Weld Pass")
    }
}

struct AddProcedurePass_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented: Bool = true // Define isPresented as @State variable
        AddProcedurePass(mainViewModel: MainViewModel(), isPresented: $isPresented)
    }
}
