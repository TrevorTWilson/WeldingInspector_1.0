//
//  ProfileView.swift
//  RewriteVersion4
//
//  Created by Trevor Wilson on 2024-03-18.
//



import SwiftUI

struct ProfileView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    @Binding var isPresented: Bool
    @State private var lastSelection: Bool
    @State private var currentName: String
    @State private var newName: String = ""
    @State private var isAlertPresented: Bool = false
    @State private var isNamePopOverVisable: Bool = false
    @State private var isMetricPopOverVisable: Bool = false
    
    init(mainViewModel: MainViewModel, isPresented: Binding<Bool>) {
        self.mainViewModel = mainViewModel
        self._isPresented = isPresented
        self.lastSelection = mainViewModel.weldingInspector.isMetric
        self.currentName = mainViewModel.weldingInspector.name
    }
    
    func changeName(){
        print("New Inspector Name added to the model")
        mainViewModel.weldingInspector.name = newName
        isPresented = false
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        print("Quick help icon tapped!")
                        isNamePopOverVisable.toggle()
                    }
                    .popover(isPresented: $isNamePopOverVisable, attachmentAnchor: .point(.top), arrowEdge: .top)  {
                                Text("This Name will be used when connecting to nearby users when transmitting or receiving weld or welding procedure data")
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                                    .presentationCompactAdaptation((.popover))
                            }
                            .padding()
                Text("Current User Name is set to:")
            }
            
            Text(" \(currentName)")
                .font(.title)
            
            TextField("Edit Name: \(currentName)", text: $newName)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .onSubmit {
                    if newName != "" {
                        changeName()
                    } else {
                        isAlertPresented = true
                    }
                }
            HStack {
                Button("Change Name") {
                    if newName != "" {
                        changeName()
                    } else {
                        isAlertPresented = true
                    }
                }
                .disabled(newName.isEmpty)
                .buttonStyle(BorderedBlueButtonStyle())
            }
            .padding()
            
            Spacer()
            
            Picker("System", selection: $mainViewModel.weldingInspector.isMetric) {
                Text("Metric").tag(true)
                Text("Imperial").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        print("Quick help icon tapped!")
                        isMetricPopOverVisable.toggle()
                    }
                    .popover(isPresented: $isMetricPopOverVisable, attachmentAnchor: .point(.top), arrowEdge: .top)  {
                                Text("This will convert the entire database to the selected units.  Verify the data after it has been converted")
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                                    .presentationCompactAdaptation((.popover))
                            }
                            .padding()
                Text("Selected System: \(mainViewModel.weldingInspector.isMetric ? "Metric" : "Imperial")")
            }
            Button("Convert Units") {
                if mainViewModel.weldingInspector.isMetric != lastSelection {
                    print("Selection changed from \(lastSelection) to \(mainViewModel.weldingInspector.isMetric)")
                    mainViewModel.convertDataModel()
                } 
            }
            .buttonStyle(BorderedBlueButtonStyle())
            .padding()
            
            Spacer()
            
            Button("Close"){
                isPresented = false
            }
            .buttonStyle(BorderedBlueButtonStyle())
            .padding()
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text("Error"),
                message: Text("Name Change cannot be blank"),
                dismissButton: .default(Text("OK"))
            )
        }
        
    }
    


}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMainViewModel = MainViewModel()
        mockMainViewModel.weldingInspector = loadSample()
        @State var isPresented: Bool = true
        return ProfileView(mainViewModel: mockMainViewModel, isPresented: $isPresented)
    }
}
