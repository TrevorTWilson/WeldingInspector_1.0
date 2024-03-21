//
//  ConversionFunctions.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-19.
//

import Foundation

// interate through WeldingInspectorModel and convert all values
extension MainViewModel{
    
    func convertDataModel()  {
        // setup bool state for conversion
        let metric = weldingInspector.isMetric
        let modelUnits = weldingInspector.modelUnits
        
        let passOrderedKey = ["ArcSpeed","HeatInput"]
        let collectedOrderedKey = ["Distance", "ArcSpeed", "HeatInput"]
        
        // handle direct converstion in weldingInspector
        weldingInspector.unitSymbol = metric ? [
            "Distance": "mm",
            "ArcSpeed": "mm/min",
            "HeatInput": "kJ/mm"
        ]
        : [
            "Distance": "in",
            "ArcSpeed": "in/min",
            "HeatInput": "kJ/in"
        ]
        
        weldingInspector.distanceRange = metric ? 400 : 17
        
        weldingInspector.defaultMinRange = metric ? [
            "Amps" : 30,
            "Volts" : 5,
            "ArcSpeed" : 50,
            "HeatInput" : 0.3
        ] : [
            "Amps" : 30,
            "Volts" : 5,
            "ArcSpeed" : 2,
            "HeatInput" : 7.5
        ]
        
        weldingInspector.defaultMaxRange = metric ? [
            "Amps" : 400,
            "Volts" : 38,
            "ArcSpeed" : 1000,
            "HeatInput" : 3.0
        ] : [
            "Amps" : 400,
            "Volts" : 38,
            "ArcSpeed" : 39,
            "HeatInput" : 75
        ]
        
        weldingInspector.defaultResolution = metric ? [
            "Amps" : 1.0,
            "Volts" : 0.1,
            "ArcSpeed" : 1.0,
            "HeatInput" : 0.01
        ] : [
            "Amps" : 1.0,
            "Volts" : 0.1,
            "ArcSpeed" : 0.25,
            "HeatInput" : 0.25
        ]
        
        weldingInspector.modelUnits = metric ? "Metric" : "Imperial"
        
        // iterate ofver remaining dataModel
        for (jobConversionIndex, job) in weldingInspector.jobs.enumerated() {
            // no data to convert
            for  (procedureConversionIndex, weldingProcedure) in job.weldingProcedures.enumerated() {
                //no data to convert
                for (passConversionIndex, pass) in weldingProcedure.weldPass.enumerated() {
                    // handle conversions of data
                    // ordered key = ["ArcSpeed", "Amps","HeatInput""Volts"]
                    
                    for key in passOrderedKey {
                        if metric && modelUnits == "Imperial" {
                            // convert to metric
                            let toMetric = true
                            let newMinRange = convertValue(key: key, value: pass.minRanges[key], toMetric: toMetric)
                            let newMaxRange = convertValue(key: key, value: pass.maxRanges[key], toMetric: toMetric)
                            weldingInspector.jobs[jobConversionIndex].weldingProcedures[procedureConversionIndex].weldPass[passConversionIndex].minRanges[key] = newMinRange
                            weldingInspector.jobs[jobConversionIndex].weldingProcedures[procedureConversionIndex].weldPass[passConversionIndex].maxRanges[key] = newMaxRange
                        } else if !metric && modelUnits == "Metric" {
                            // convert to imperial
                            let toMetric = false
                            let newMinRange = convertValue(key: key, value: pass.minRanges[key], toMetric: toMetric)
                            let newMaxRange = convertValue(key: key, value: pass.maxRanges[key], toMetric: toMetric)
                            weldingInspector.jobs[jobConversionIndex].weldingProcedures[procedureConversionIndex].weldPass[passConversionIndex].minRanges[key] = newMinRange
                            weldingInspector.jobs[jobConversionIndex].weldingProcedures[procedureConversionIndex].weldPass[passConversionIndex].maxRanges[key] = newMaxRange
                        }
                        
                    }
                }
                
                for (welderConversionIndex, welder) in weldingProcedure.weldersQualified.enumerated() {
                    
                    // handle conversions of data
                    
                    for (weldConversionIndex, weld) in welder.welds.enumerated() {
                        
                        // handle conversions of data
                        
                        for (parameterConversionIndex, parameters) in weld.parametersCollected.enumerated() {
                            
                            // handle conversions of data
                            // procedurePass minRange maxRange: ordered key = ["ArcSpeed", "Amps","HeatInput""Volts"]
                            for key in passOrderedKey {
                                if metric && modelUnits == "Imperial" {
                                    // convert to metric
                                    let toMetric = true
                                    let newMinRange = convertValue(key: key, value: parameters.procedurePass.minRanges[key], toMetric: toMetric)
                                    let newMaxRange = convertValue(key: key, value: parameters.procedurePass.maxRanges[key], toMetric: toMetric)
                                    weldingInspector.jobs[jobConversionIndex].weldingProcedures[procedureConversionIndex].weldersQualified[welderConversionIndex].welds[weldConversionIndex].parametersCollected[parameterConversionIndex].procedurePass.minRanges[key] = newMinRange
                                    weldingInspector.jobs[jobConversionIndex].weldingProcedures[procedureConversionIndex].weldersQualified[welderConversionIndex].welds[weldConversionIndex].parametersCollected[parameterConversionIndex].procedurePass.maxRanges[key] = newMaxRange
                                } else if !metric && modelUnits == "Metric" {
                                    // convert to imperial
                                    let toMetric = false
                                    let newMinRange = convertValue(key: key, value: parameters.procedurePass.minRanges[key], toMetric: toMetric)
                                    let newMaxRange = convertValue(key: key, value: parameters.procedurePass.minRanges[key], toMetric: toMetric)
                                    weldingInspector.jobs[jobConversionIndex].weldingProcedures[procedureConversionIndex].weldersQualified[welderConversionIndex].welds[weldConversionIndex].parametersCollected[parameterConversionIndex].procedurePass.minRanges[key] = newMinRange
                                    weldingInspector.jobs[jobConversionIndex].weldingProcedures[procedureConversionIndex].weldersQualified[welderConversionIndex].welds[weldConversionIndex].parametersCollected[parameterConversionIndex].procedurePass.maxRanges[key] = newMaxRange
                                }
                                
                            }
                            // collectedValues: orderedKey = "Amps", "Distance", "Volts", "Time", "ArcSpeed", "HeatInput"]
                            for key in collectedOrderedKey {
                                if metric && modelUnits == "Imperial" {
                                    // convert to metric
                                    let toMetric = true
                                    let newValue = convertValue(key: key, value: parameters.collectedValues[key], toMetric: toMetric)
                                    weldingInspector.jobs[jobConversionIndex].weldingProcedures[procedureConversionIndex].weldersQualified[welderConversionIndex].welds[weldConversionIndex].parametersCollected[parameterConversionIndex].collectedValues[key] = newValue
                                     } else if !metric && modelUnits == "Metric" {
                                    // convert to imperial
                                    let toMetric = false
                                         let newValue = convertValue(key: key, value: parameters.collectedValues[key], toMetric: toMetric)
                                         weldingInspector.jobs[jobConversionIndex].weldingProcedures[procedureConversionIndex].weldersQualified[welderConversionIndex].welds[weldConversionIndex].parametersCollected[parameterConversionIndex].collectedValues[key] = newValue
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
        return
    }
    
    // Function to handle the ordered keys
    func convertValue(key: String, value: Double?, toMetric: Bool) -> Double {
        guard let unWrappedValue = value else{
            return 0.0
        }
        let toMetric = toMetric
        switch key {
        case "Amps":
            return unWrappedValue
            // no change for Amps
        case "Distance":
            // Code for handling "Distance"
            let convertedValue = toMetric ? (round(unWrappedValue * 25.4)) : (round((unWrappedValue / 25.4) / 0.25) * 0.25)
            return convertedValue
        case "Volts":
            return unWrappedValue
            // no change for volts
        case "Time":
            // no change for time
            return unWrappedValue
        case "ArcSpeed":
            // Code for handling "ArcSpeed"
            let convertedValue = toMetric ? (round(unWrappedValue * 25.4)) : (round((unWrappedValue / 25.4) / 0.25) * 0.25)
            return convertedValue
        case "HeatInput":
            // Code for handling "HeatInput"
            let convertedValue = toMetric ? (round((unWrappedValue / 25.4) / 0.01) * 0.01) : (round((unWrappedValue * 25.4) / 0.25) * 0.25)
            return convertedValue
        default:
            // Default case if the key is not in the defined keys
            return unWrappedValue
        }
    }

    
}
