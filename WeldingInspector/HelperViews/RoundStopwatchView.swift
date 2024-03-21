//
//  RoundStopWatchView.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-18.
//

import SwiftUI

import SwiftUI

struct RoundStopwatchView: View {
    @State private var timer: Timer?
    @State private var startTime: Date?
    //@State private var elapsedTime: TimeInterval? // Define elapsedTime as an optional TimeInterval
    @State private var isRunning = false
    @Binding var elapsedTime: TimeInterval?


    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.black, lineWidth: 6)
                    .fill(Color.white)
                    .frame(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 2.5, height: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 2.5)
                 
                VStack{
                    Text(elapsedTimeString)
                        .font(.system(size: 35))
                    Button(action: startStopTimer) {
                        Text(isRunning ? "Stop" : "Start")
                            .foregroundColor(isRunning ? Color.red : Color.green)
                            .font(.system(size: 35))
                           
                    }
                    
                    Button(action: resetTimer) {
                        Text("Reset")
                            .foregroundColor(Color.blue)
              
                    }
                }
            }

            
        }
        .padding()
    }

    var elapsedTimeString: String {
        let seconds: Int
        let milliseconds: Int

        if let elapsedTime = elapsedTime {
            seconds = Int(elapsedTime)
            milliseconds = Int(elapsedTime.truncatingRemainder(dividingBy: 1) * 10)
        } else {
            // Default values when elapsedTime is nil
            seconds = 0
            milliseconds = 0
        }

        return String(format: "%0d.%01d", seconds, milliseconds)
    }



    func startStopTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
        
        isRunning.toggle()
    }
    
    func startTimer() {
            guard let previousElapsedTime = elapsedTime else {
                startTime = Date()
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    updateElapsedTime()
                }
                return
            }
            
            startTime = Date().addingTimeInterval(-previousElapsedTime)
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                updateElapsedTime()
            }
        }





    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        stopTimer()
        startTime = nil
        elapsedTime = 0.0
    }

    func updateElapsedTime() {
        if let startTime = startTime {
            elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
}


struct RoundStopwatchView_Previews: PreviewProvider {
    @State static var elapsedTime: TimeInterval? = 0.0  // Example initial elapsed time value

    static var previews: some View {
        RoundStopwatchView(elapsedTime: $elapsedTime)
    }
}

