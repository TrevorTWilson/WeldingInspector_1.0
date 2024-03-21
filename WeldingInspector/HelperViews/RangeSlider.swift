//
//  anotherSlider.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-23.
//


import SwiftUI

struct RangeSlider : View {
    @State var width: Double = 0
    @State var width1: Double = 15
    @State private var minRangeValue: Double = 0.0
    @State private var maxRangeValue: Double = 0.0
    @Binding var isRangeSliderSheetPresented: Bool
    var onValueSelected: ((Double, Double) -> Void)? // Include the onValueSelected parameter
    
    var totalWidth = 320.0
    var attributeTitle: String
    var descriptor: String
    var minValue: Double
    var maxValue: Double
    var initialMinValue: Double
    var initialMaxValue: Double
    var mappingValue: Double
    var resolution: Double
    
    init(isRangeSliderSheetPresented: Binding<Bool>, attributeTitle: String, descriptor: String, minValue: Double, maxValue: Double, initialMinValue: Double, initialMaxValue: Double, resolution: Double, onValueSelected: ((Double, Double) -> Void)? = nil) {
        _isRangeSliderSheetPresented = isRangeSliderSheetPresented
        self.attributeTitle = attributeTitle
        self.descriptor = descriptor
        self.minValue = minValue
        self.maxValue = maxValue
        self.initialMinValue = initialMinValue
        self.initialMaxValue = initialMaxValue
        self.mappingValue = maxValue - minValue
        self.resolution = resolution
        
        let initialWidth = Double(((self.initialMinValue - self.minValue) / (self.maxValue - self.minValue) * totalWidth))
        let initialWidth1 = Double(((self.initialMaxValue - self.minValue) / (self.maxValue - self.minValue) * totalWidth))
        
        _width = State(initialValue: initialWidth)
        _width1 = State(initialValue: initialWidth1)
        
        print("MinValue: \(self.width) MaxValue: \(self.width1)")
        print("Resolution: \(self.resolution)")
        self.onValueSelected = onValueSelected
    }

    
    var body: some View {
        VStack {
            Text(attributeTitle)
                .font(.title)
                .fontWeight(.bold)
            Text(descriptor)
                .font(.title2)
                
            
            Text("\(self.getValue(value: ((self.width / self.totalWidth)*mappingValue)+minValue, resolution: self.resolution)) - \(self.getValue(value: ((self.width1 / self.totalWidth)*mappingValue)+minValue, resolution: self.resolution))")
                .fontWeight(.bold)
                .padding(.top)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.black.opacity(0.20))
                    .frame(width: self.totalWidth,height: 6)
                
                Rectangle()
                    .fill(Color.black)
                    .frame(width: self.width1 - self.width, height: 6)
                    .offset(x: self.width + 18)
                
                HStack(spacing: 0) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 18, height: 18)
                        .offset(x: self.width)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    if value.location.x >= 0 && value.location.x <= self.width1 {
                                        self.width = value.location.x
                                        self.minRangeValue = Double(getValue(value: ((self.width / self.totalWidth)*mappingValue)+minValue, resolution: self.resolution))!
                                        print(minRangeValue, maxRangeValue)
                                    }
                                })
                        )
                    
                    Circle()
                        .fill(Color.black)
                        .frame(width: 18, height: 18)
                        .offset(x: self.width1)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    if value.location.x <= self.totalWidth && value.location.x >= self.width {
                                        self.width1 = value.location.x
                                        self.maxRangeValue = Double(getValue(value: ((self.width1 / self.totalWidth)*mappingValue)+minValue, resolution: self.resolution))!
                                        print(minRangeValue, maxRangeValue)
                                    }
                                })
                        )
                }
            }
            HStack{
                Spacer()
                Button("Save") {
                    // Update the minRangeValue and maxRangeValue
                    let newMinRangeValue = Double(self.getValue(value: ((self.width / self.totalWidth) * self.mappingValue) + self.minValue, resolution: self.resolution))
                    let newMaxRangeValue = Double(self.getValue(value: ((self.width1 / self.totalWidth) * self.mappingValue) + self.minValue, resolution: self.resolution))
                    
                    if let minRangeValue = newMinRangeValue, let maxRangeValue = newMaxRangeValue {
                        self.minRangeValue = minRangeValue
                        self.maxRangeValue = maxRangeValue
                    } else {
                        // Handle the case where the conversion fails
                        print("Error converting values.")
                    }
                    
                    print("Min Value: \(self.minRangeValue), Max Value: \(self.maxRangeValue)")

                    // Return the updated minRangeValue and maxRangeValue values to the caller
                    guard let onValueSelected = onValueSelected else { return }
                    onValueSelected(self.minRangeValue, self.maxRangeValue)
                    
                    // Dismiss the view
                    //dismiss()
                    isRangeSliderSheetPresented = false
                }
                Spacer()
                Button("Cancel") {
                    // Dismiss the view
                    //dismiss()
                    isRangeSliderSheetPresented = false
                }
                Spacer()
            }
            .padding(.top, 25)
        }
        .padding()
    }
    
    private func getValue(value: Double, resolution: Double) -> String {
        var newValue = value
        if newValue < self.minValue {
            newValue = self.minValue
        } else {
            newValue = (value / resolution).rounded() * resolution // Round the value to the nearest resolution
        }
        let decimalPlaces = Int(-log10(resolution))
        let formatString = String(format: "%%.%df", decimalPlaces)
        let formattedString = String(format: formatString, newValue)
        
        return formattedString
    }


}

struct RangeSlider_Previews: PreviewProvider {
    @State static var isRangeSliderSheetPresented: Bool = false
    @State static var selectedMinValue: Double = 0.0
    @State static var selectedMaxValue: Double = 0.0
    
    static var previews: some View {
        var rangeSlider = RangeSlider(
            isRangeSliderSheetPresented: $isRangeSliderSheetPresented,
            attributeTitle: "Amps",
            descriptor: "Add New Range",
            minValue: 0.8,
            maxValue: 3.0,
            initialMinValue: 0.9,
            initialMaxValue: 2.2,
            resolution: 0.01
        )
        rangeSlider.onValueSelected = { minValue, maxValue in
            selectedMinValue = minValue
            selectedMaxValue = maxValue
            print("Min Value: \(selectedMinValue), Max Value: \(selectedMaxValue)")
        }

        return rangeSlider
    }
}







