//
//  UpdateItems.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-13.
//

import Foundation

extension MainViewModel {
    
    func updateWelder(name: String, welderId: String, pressureNumber: String, pressureExpiry: String, welds: [WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers] = []) {
        guard let updatedProcedure = selectedWeldingProcedure else {
            return
        }
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].name = name
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].welderId = welderId
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].pressureNumber = pressureNumber
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].pressureExpiry = pressureExpiry
        
        setSelectedProcedure(procedure: updatedProcedure)
    }
    
    func updateWeldNumber(name: String) {
        guard let updatedWelder = selectedWelder else {
            return
        }
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].welds[weldNumberIndex].name = name
        
        setSelectedWelder(welder: updatedWelder)
    }
    
    func updateParameters(passName: String, procedurePass: WeldingInspector.Job.WeldingProcedure.WeldPass) {
        guard let updatedWeldNumber = selectedWeldNumber else {
            return
        }
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].welds[weldNumberIndex].parametersCollected[passIndex].passName = passName
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].welds[weldNumberIndex].parametersCollected[passIndex].procedurePass = procedurePass
        
        setSelectedWeldNumber(weldId: updatedWeldNumber)
    }
    
    func updateCollectedValues(ampsValue: Double, voltsValue: Double, distanceValue: Double, arcSpeedValue: Double, heatInputValue: Double, timeValue: Double) {
        guard var updatedParameters = selectedWeldPass else {
            return
        }
        print("Amps: \(ampsValue)---Volts: \(voltsValue)---Distance: \(distanceValue)---AS: \(arcSpeedValue)---HI: \(heatInputValue)---Time: \(timeValue)")
        updatedParameters.collectedValues["Amps"] = ampsValue
        updatedParameters.collectedValues["Volts"] = voltsValue
        updatedParameters.collectedValues["Distance"] = distanceValue
        updatedParameters.collectedValues["ArcSpeed"] = arcSpeedValue
        updatedParameters.collectedValues["HeatInput"] = heatInputValue
        updatedParameters.collectedValues["Time"] = timeValue
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].welds[weldNumberIndex].parametersCollected[passIndex] = updatedParameters
        setSelectedWeldPass(weldPass: updatedParameters)
    }
    
    //  Methods to edit items on selected lists
    
  
    
    func updateProcedure(newName:String, newType: String, newUse: String, newOwner: String){
        guard var updatedProcedure = selectedWeldingProcedure else {
            return
        }
        updatedProcedure.name = newName
        updatedProcedure.type = newType
        updatedProcedure.usage = newUse
        updatedProcedure.owner = newOwner
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex] = updatedProcedure
        
        setSelectedProcedure(procedure: updatedProcedure)
    }
    
    
}
