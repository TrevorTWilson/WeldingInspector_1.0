//
//  circleSlider VC.swift
//  circleSlider
//
//  Created by trevor wilson on 2024-01-20.
//

//

import SwiftUI



struct CircleSliderVC: View {
    @State private var angleValue: Double
    @Binding var sliderValue: Double

    var minimunSliderValue : Double
    var maximunSliderValue : Double
    var minimumSliderRange : Double
    var maximumSliderRange : Double
    var knobRadius : Double
    var radius : Double
    var valueUnit: String
    
    init(minimunSliderValue: Double, maximunSliderValue: Double, minimumSliderRange: Double, maximumSliderRange: Double, knobRadius: Double, radius: Double, valueUnit: String, sliderValue: Binding<Double>) {
        self.minimunSliderValue = minimunSliderValue
        self.maximunSliderValue = maximunSliderValue
        self.minimumSliderRange = minimumSliderRange
        self.maximumSliderRange = maximumSliderRange
        self.knobRadius = knobRadius
        self.radius = radius
        self._sliderValue = sliderValue // Initialize the sliderValue state variable
        self.valueUnit = valueUnit
        angleValue = (Double(360/maximunSliderValue)*sliderValue.wrappedValue)
    }

    var body: some View {
        ZStack {
            Circle()
                .frame(width: self.radius * 2, height: self.radius * 2)
                .scaleEffect(1.20)
            
            Circle()
                .stroke(Color.gray,
                        style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [3, 23.18]))
                .frame(width: self.radius * 2, height: self.radius * 2)
            
            Circle()
                .trim(from: 0.0, to: self.sliderValue/self.maximunSliderValue)
                .stroke((self.sliderValue < self.minimumSliderRange || self.sliderValue > self.maximumSliderRange) ? Color.red : Color.blue, lineWidth: 4)

                .frame(width: self.radius * 2, height: self.radius * 2)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .fill((self.sliderValue < self.minimumSliderRange || self.sliderValue > self.maximumSliderRange) ? Color.red : Color.blue)
                .frame(width: self.knobRadius * 2, height: self.knobRadius * 2)
                .padding(10)
                .offset(y: -self.radius)
                .rotationEffect(Angle.degrees(Double(angleValue)))
                .gesture(DragGesture(minimumDistance: 0.0)
                            .onChanged({ value in
                                change(location: value.location)
                            }))
            
            Text("\(String.init(format: "%.0f", self.sliderValue)) \(valueUnit)")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
        }
    }
    
    private func change(location: CGPoint) {
        // creating vector from location point
        let vector = CGVector(dx: location.x, dy: location.y)
        
        // geting angle in radian need to subtract the knob radius and padding from the dy and dx
        let angle = atan2(vector.dy - (self.knobRadius + 10), vector.dx - (self.knobRadius + 10)) + .pi/2.0
        
        // convert angle range from (-pi to pi) to (0 to 2pi)
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        // convert angle value to temperature value
        let value = fixedAngle / (2.0 * .pi) * self.maximunSliderValue
        
        if value >= self.minimunSliderValue && value <= self.maximunSliderValue {
            self.sliderValue = value
            angleValue = fixedAngle * 180 / .pi // converting to degree
        }
    }
}



struct Content_Previews: PreviewProvider {
    static var previews: some View {
        CircleSliderVC(minimunSliderValue: 0, maximunSliderValue: 400, minimumSliderRange: 100, maximumSliderRange: 300, knobRadius: 15, radius: 75, valueUnit: "?", sliderValue: .constant(10.0))
    }
}

