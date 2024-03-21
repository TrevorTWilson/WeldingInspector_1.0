//
//  CollectParametersView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-18.
//

import SwiftUI
import Combine

struct CollectParametersView: View {
    
 
    @ObservedObject var mainViewModel: MainViewModel
    
    var selectedWeldPass: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters?
    
    @State private var elapsedTime: TimeInterval?
    @State private var ampSliderValue: Double = 0.0
    @State private var voltSliderValue: Double = 0.0
    @State private var distanceSliderValue: Double = 0.0
    @State private var formattedElapsedTime: Double = 0.0
    @State private var formattedAmpSlider: Double = 0.0
    @State private var formattedDistanceSlider: Double = 0.0
    @State private var arcSpeed: Double = 0.0
    @State private var heatInput: Double = 0.0
    @State private var dataChangeTrigger = UUID()
    
    @State private var ampMinRange: Double = 0.0
    @State private var ampMaxRange: Double = 0.0
    @State private var voltMinRange: Double = 0.0
    @State private var voltMaxRange: Double = 0.0
    @State private var arcSpeedMinRange: Double = 0.0
    @State private var arcSpeedMaxRange: Double = 0.0
    @State private var heatInputMinRange: Double = 0.0
    @State private var heatInputMaxRange: Double = 0.0
    
    @State private var distanceUnit: String
    @State private var arcSpeedUnit: String
    @State private var heatInputUnit: String
    @State private var distanceRange: Double
    
    @State private var inRange = false
    @State private var failedRanges: [String] = []
    
    @Binding var isPresented: Bool
    
    var dataChangeTriggers: [UUID] {
        return [
            dataChangeTrigger,
            UUID()
        ]
    }
    
    init(mainViewModel: MainViewModel, isPresented: Binding<Bool>) {
        self.mainViewModel = mainViewModel
        self._isPresented = isPresented
        self.selectedWeldPass = mainViewModel.selectedWeldPass
        // Set initial values for Sliders and StopWatch
        if let collectedValues = selectedWeldPass?.collectedValues, let passRange = selectedWeldPass?.procedurePass{
            let collectedKeys = ["Amps", "Volts", "Distance", "Time"]
            
            for key in collectedKeys {
                if let value = collectedValues[key]{
                    switch key {
                    case "Amps":
                        self._ampSliderValue = State(initialValue: value)
                    case "Volts":
                        self._voltSliderValue = State(initialValue: value)
                    case "Distance":
                        self._distanceSliderValue = State(initialValue: value)
                    case "Time":
                        self._elapsedTime = State(initialValue: value)
                    default:
                        break
                    }
                }
            }
            let rangeKeys = ["Amps", "Volts", "HeatInput", "ArcSpeed"]
            
            for key in rangeKeys {
                if let minRanges = passRange.minRanges[key] {
                    switch key {
                    case "Amps":
                        self._ampMinRange = State(initialValue: minRanges)
                    case "Volts":
                        self._voltMinRange = State(initialValue: minRanges)
                    case "HeatInput":
                        self._heatInputMinRange = State(initialValue: minRanges)
                    case "ArcSpeed":
                        self._arcSpeedMinRange = State(initialValue: minRanges)
                    default:
                        break
                    }
                }
            }
            for key in rangeKeys {
                if let maxRanges = passRange.maxRanges[key] {
                    switch key {
                    case "Amps":
                        self._ampMaxRange = State(initialValue: maxRanges)
                    case "Volts":
                        self._voltMaxRange = State(initialValue: maxRanges)
                    case "HeatInput":
                        self._heatInputMaxRange = State(initialValue: maxRanges)
                    case "ArcSpeed":
                        self._arcSpeedMaxRange = State(initialValue: maxRanges)
                    default:
                        break
                    }
                }
            }
        } else {
            print("CollectedValues or PassRange failed")
        }
        self._distanceUnit = State(initialValue: mainViewModel.weldingInspector.unitSymbol["Distance"] ?? "")
        self._arcSpeedUnit = State(initialValue: mainViewModel.weldingInspector.unitSymbol["ArcSpeed"] ?? "")
        self._heatInputUnit = State(initialValue: mainViewModel.weldingInspector.unitSymbol["HeatInput"] ?? "")
        self._distanceRange = State(initialValue: mainViewModel.weldingInspector.distanceRange)
    }
    
    
    var body: some View {
        
        
        let amps = CircleSliderVC(minimunSliderValue: 0, maximunSliderValue: 300,minimumSliderRange: ampMinRange, maximumSliderRange: ampMaxRange, knobRadius: 15, radius: 75, valueUnit: "Amps", sliderValue: $ampSliderValue)
        
        let volts = CircleSliderVC(minimunSliderValue: 0, maximunSliderValue: 40,minimumSliderRange: voltMinRange, maximumSliderRange: voltMaxRange, knobRadius: 15, radius: 75, valueUnit: "Volts", sliderValue: $voltSliderValue)
        
        let distance = CircleSliderVC(minimunSliderValue: 0, maximunSliderValue: distanceRange, minimumSliderRange: 0, maximumSliderRange: distanceRange, knobRadius: 15, radius: 75, valueUnit: distanceUnit, sliderValue: $distanceSliderValue)
        
        let time = RoundStopwatchView(elapsedTime: $elapsedTime)
        
        ZStack {
            Rectangle()
                .fill(Color.init(red: 34/255, green: 30/255, blue: 47/255))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    amps
                    Spacer()
                    volts
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    distance
                    Spacer()
                    time
                    Spacer()
                }
                Spacer()
                HStack {
                    VStack{
                        Text("ArcSpeed Value: ")
                            Text("\(String(format: "%.1f", arcSpeed))")
                                .font(.system(size: 35))
                        Text("\(arcSpeedUnit)")
                    }
                    
                    Spacer()
                    VStack{
                        Text("HeatInput Value: ")
                            Text("\(String(format: "%.1f", heatInput))")
                                .font(.system(size: 35))
                            Text("\(heatInputUnit)")
                    }
                }
                .foregroundStyle(Color.white)
                Spacer()
                GeometryReader { geometry in
                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("Discard Data")
                                .padding()
                                .background(Color.white)
                                .foregroundColor(Color.black)
                                .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        
                        Spacer()
                        
                        Button(action: {
                            mainViewModel.updateCollectedValues(ampsValue: formattedAmpSlider, voltsValue: voltSliderValue, distanceValue: formattedDistanceSlider, arcSpeedValue: arcSpeed, heatInputValue: heatInput, timeValue: formattedElapsedTime)
                            isPresented = false
                        }) {
                            Text("Save Data")
                                .padding()
                                .background(inRange ? Color.green : Color.red)
                                .foregroundColor(inRange ? Color.white : Color.black)
                                .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            inRange = false
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        
                        
                    }
                }
                .frame(height: 50)
                Spacer()
                if failedRanges.isEmpty {
                    Text("All values are within the range.")
                        .foregroundStyle(Color.white)
                } else {
                    Text("Out of range: \(failedRanges.joined(separator: ", "))")
                        .foregroundStyle(Color.white)
                }
            }
        }
        .onAppear(){
            updateFormattedValues()
        }
        .onChange(of: elapsedTime) {
            updateFormattedValues()
        }
        .onChange(of: ampSliderValue){
            updateFormattedValues()
        }
        .onChange(of: voltSliderValue){
            updateFormattedValues()
        }
        .onChange(of: distanceSliderValue){
            updateFormattedValues()
        }
        
    }
    
    func updateFormattedValues() {
        formattedElapsedTime = convertElapsedTimeToNearestSecond()
        formattedAmpSlider = convertSliderValue(sliderValue: ampSliderValue)
        formattedDistanceSlider = convertSliderValue(sliderValue: distanceSliderValue)
        arcSpeed = calculateArcSpeed(distance: formattedDistanceSlider, time: formattedElapsedTime)
        heatInput = calculateHeatInput(distance: formattedDistanceSlider, time: formattedElapsedTime, amps: formattedAmpSlider, volts: voltSliderValue)
        failedRanges = checkRanges(ampValue: formattedAmpSlider, voltValue: voltSliderValue, arcSpeedValue: arcSpeed, heatInputValue: heatInput)
    }
    
    func convertSliderValue(sliderValue: Double) -> Double {
        let roundedSliderValue = round(sliderValue)
        return roundedSliderValue
    }
    
    func checkRanges(ampValue: Double, voltValue: Double, arcSpeedValue: Double, heatInputValue: Double) -> [String] {
        var failedConditions: [String] = []
        
        if !(ampMinRange...ampMaxRange).contains(ampValue) {
            failedConditions.append("Amps")
        }
        if !(voltMinRange...voltMaxRange).contains(voltValue) {
            failedConditions.append("Volts")
        }
        if !(arcSpeedMinRange...arcSpeedMaxRange).contains(arcSpeedValue) {
            failedConditions.append("ArcSpeed")
        }
        if !(heatInputMinRange...heatInputMaxRange).contains(heatInputValue) {
            failedConditions.append("HeatInput")
        }
        
        inRange = failedConditions.isEmpty
        
        return failedConditions
    }

    
    func convertElapsedTimeToNearestSecond() -> Double {
        if let elapsedTime = elapsedTime {
            // Convert TimeInterval to Double and round to the nearest second
            let doubleElapsedTime = Double(elapsedTime)
            let roundedElapsedTime = round(doubleElapsedTime) // Round to the nearest second
            return roundedElapsedTime
        } else {
            // Default value if elapsedTime is nil
            return 0.0
        }
    }
}


struct CollectParametersView_Previews: PreviewProvider {
    @State static var isPresented: Bool = true
    
    static var previews: some View {
        CollectParametersView(mainViewModel: MainViewModel(), isPresented: $isPresented)
    }
}




