//
//  ProfileView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-18.
//



import SwiftUI

struct ProfileView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    @Binding var isPresented: Bool
    @State private var lastSelection: Bool
    
    init(mainViewModel: MainViewModel, isPresented: Binding<Bool>) {
        self.mainViewModel = mainViewModel
        self._isPresented = isPresented
        self.lastSelection = mainViewModel.weldingInspector.isMetric
    }
    
    var body: some View {
        VStack {
            Picker("System", selection: $mainViewModel.weldingInspector.isMetric) {
                Text("Metric").tag(true)
                Text("Imperial").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text("Selected System: \(mainViewModel.weldingInspector.isMetric ? "Metric" : "Imperial")")
            
            Button("Close") {
                if mainViewModel.weldingInspector.isMetric != lastSelection {
                    print("Selection changed from \(lastSelection) to \(mainViewModel.weldingInspector.isMetric)")
                    mainViewModel.convertDataModel()
                } else {
                    print("No Change Detected")
                }
                isPresented = false
        }
        .padding()
       
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
