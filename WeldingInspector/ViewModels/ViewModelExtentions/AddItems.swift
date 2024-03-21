//
//  AddItems.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-13.
//

import Foundation

extension MainViewModel {
    
    // Methods to add new items to selected lists
    
    func addJob(name: String, weldingProcedures: [WeldingInspector.Job.WeldingProcedure] = []) {
        let newJob = WeldingInspector.Job(name: name, weldingProcedures: weldingProcedures)
        weldingInspector.jobs.append(newJob)
    }
    
    func addProcedure(name: String,
                      type: String? = nil,
                      usage: String? = nil,
                      owner: String? = nil,
                      weldPass: [WeldingInspector.Job.WeldingProcedure.WeldPass] = [],
                      weldersQualified: [WeldingInspector.Job.WeldingProcedure.Welder] = []) {
      
        guard var updatedJob = selectedJob else {
            return
        }
        
        let newProcedure = WeldingInspector.Job.WeldingProcedure(name: name,
                                                                 type: type ?? "",
                                                                 usage: usage ?? "",
                                                                 owner: owner ?? "",
                                                                 weldPass: weldPass,
                                                                 weldersQualified: weldersQualified)
        
        updatedJob.weldingProcedures.append(newProcedure)
        
        weldingInspector.jobs[jobIndex] = updatedJob
        
        setSelectedJob(job: updatedJob)
    }
    
    func addProcedurePass(name: String, minRanges: [String:Double] = [:], maxRanges: [String:Double] = [:]) {
        print("Recieved from addProcedurePass")
        guard var updatedProcedure = selectedWeldingProcedure else {
            print("FAILED, \(String(describing: selectedWeldingProcedure))")
            return
        }
        print("updated procedure = selected Job: \(weldingInspector.jobs[jobIndex].name) at index: \(jobIndex) and selected procedure \(weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].name) at index: \(procedureIndex)")
        let newPass = WeldingInspector.Job.WeldingProcedure.WeldPass(passName: name, minRanges: minRanges, maxRanges: maxRanges)
        
        updatedProcedure.weldPass.append(newPass)
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex] = updatedProcedure
        print("added \(newPass.passName) to \(weldingInspector.jobs[jobIndex].name) @index: \(jobIndex) in \(weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].name) @index: \(procedureIndex)")
        
        setSelectedProcedure(procedure: updatedProcedure)
    }
    
    func addProcedurePaasRange(key: String, minRange: Double, maxRange: Double) {
        guard var updatedProcedure = selectedWeldingProcedure else {
            print("FAILED, \(String(describing: selectedWeldingProcedure))")
            return
        }
        let newMinRange = minRange
        let newMaxRange = maxRange
        
        updatedProcedure.weldPass[weldPassIndex].minRanges[key] = newMinRange
        updatedProcedure.weldPass[weldPassIndex].maxRanges[key] = newMaxRange
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex] = updatedProcedure
        
        print("Added minRange value: \(newMinRange) and maxRange value: \(newMaxRange) to key: \(key) inside welding procedure pass: \(weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldPass[weldPassIndex].passName)")
        
        setSelectedProcedure(procedure: updatedProcedure)
    }
    
    func addWelder(name: String, welderId: String, pressureNumber: String, pressureExpiry: String, welds: [WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers] = []) {
        guard var updatedProcedure = selectedWeldingProcedure else {
            return
        }
        
        let newWelder = WeldingInspector.Job.WeldingProcedure.Welder(name: name, welderId: welderId, pressureNumber: pressureNumber, pressureExpiry: pressureExpiry, welds: welds)
        
        updatedProcedure.weldersQualified.append(newWelder)
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex] = updatedProcedure
        setSelectedProcedure(procedure: updatedProcedure)
    }
    
    func addWeldNumber(name: String, parametersCollected: [WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters] = []) {
        guard var updatedWelder = selectedWelder else {
            return
        }
        
        let newWeldNumber = WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers(name: name, parametersCollected: parametersCollected)
        
        updatedWelder.welds.append(newWeldNumber)
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex] = updatedWelder
        setSelectedWelder(welder: updatedWelder)
    }
    
    func addParameters(passName: String, procedurePass: WeldingInspector.Job.WeldingProcedure.WeldPass, collectedValues: [String: Double] = [:]) {
        guard var updatedWeldNumber = selectedWeldNumber else {
            return
        }
        
        let newParameters = WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters(passName: passName, procedurePass: procedurePass, collectedValues: collectedValues)
        
        updatedWeldNumber.parametersCollected.append(newParameters)

            weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].welds[weldNumberIndex] = updatedWeldNumber
        setSelectedWeldNumber(weldId: updatedWeldNumber)
    }
    
    // Methods to add groups of items
    func addMultipleProcedures(selectedProcedures: [WeldingInspector.Job.WeldingProcedure]) {
        guard var updatedJob = selectedJob else {
            return
        }
        for procedure in selectedProcedures {
            updatedJob.weldingProcedures.append(procedure)
            weldingInspector.jobs[jobIndex] = updatedJob
        }
        
    }
    
    func addMultipleWelders(selectedWelders: [WeldingInspector.Job.WeldingProcedure.Welder]){
        guard var updatedWeldingProcedure = selectedWeldingProcedure else {
            return
        }
        for welder in selectedWelders {
            updatedWeldingProcedure.weldersQualified.append(welder)
            weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex] = updatedWeldingProcedure
        }
    }
}
