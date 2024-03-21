//
//  HandleKeyAction.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-08.
//


import SwiftUI

func handleKeyAction(for key: String,
                     pass: WeldingInspector.Job.WeldingProcedure.WeldPass,
                     mainViewModel: MainViewModel,
                     updateKeyValues: @escaping (String, String, Double, Double, Double, Double, Double) -> Void,
                     isRangeSliderSheetPresented: Binding<Bool>) -> some View {
    
    let (selectedKey, selectedDescriptor, selectedMinRange, selectedMaxRange, selectedResolution) = setTempValuesForKey(for: key, pass: pass, mainViewModel: mainViewModel)
    
    return GeometryReader { geometry in
        if pass.minRanges[key] == nil || pass.maxRanges[key] == nil {
            Text("Add")
                .padding()
                .font(.system(size: 12))
                .frame(width: 60, height: 60)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(5)
                .onTapGesture {
                    print("Add action for key: \(key)")
                    let selectedInitialMin = selectedMinRange
                    let selectedInitialMax = selectedMaxRange
                    updateKeyValues(selectedKey, selectedDescriptor, selectedMinRange, selectedMaxRange, selectedInitialMin, selectedInitialMax, selectedResolution)
                    mainViewModel.setSelectedProcedurePass(weldPass: pass)
                    isRangeSliderSheetPresented.wrappedValue = true
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .frame(width: 60, height: 60)
        } else {
            Text("Edit")
                .padding()
                .font(.system(size: 12))
                .frame(width: 60, height: 60)
                .background(Color.green)
                .foregroundColor(.black)
                .cornerRadius(5)
                .onTapGesture {
                    print("Edit action for key: \(key)")
                    let selectedInitialMin = pass.minRanges[key] ?? 0.0
                    let selectedInitialMax = pass.maxRanges[key] ?? 0.0
                    updateKeyValues(selectedKey, selectedDescriptor, selectedMinRange, selectedMaxRange, selectedInitialMin, selectedInitialMax, selectedResolution)
                    mainViewModel.setSelectedProcedurePass(weldPass: pass)
                    isRangeSliderSheetPresented.wrappedValue = true
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .frame(width: 60, height: 60)
        }
    }
}

