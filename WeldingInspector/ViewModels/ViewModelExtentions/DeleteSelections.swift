//
//  DeleteSelections.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-13.
//

import Foundation

extension MainViewModel {
    
    // Methods to delete selected items
    func deleteSelectedJob(index: Int){
        weldingInspector.jobs.remove(at: index)
    }
    
    func deleteSelectedProcedure(index: Int){
        guard var updatedJob = selectedJob else {
            return
        }
        updatedJob.weldingProcedures.remove(at: index)
        
        weldingInspector.jobs[jobIndex] = updatedJob
        
        setSelectedJob(job: updatedJob)
    }
    
    func deleteSelectedProcedurePass(index: Int) {
        guard var updatedProcedure = selectedWeldingProcedure else {
            print("FAILED, \(String(describing: selectedWeldingProcedure))")
            return
        }
        updatedProcedure.weldPass.remove(at: index)
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex] = updatedProcedure
        setSelectedProcedure(procedure: updatedProcedure)
    }
    
    func deleteSelectedWelder(index: Int){
        guard var updatedProcedure = selectedWeldingProcedure else {
            return
        }
        updatedProcedure.weldersQualified.remove(at: index)
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex] = updatedProcedure
        setSelectedProcedure(procedure: updatedProcedure)
    }
    
    func deleteSelectedWeldNumber(index: Int){
        guard var updatedWelder = selectedWelder else {
            return
        }
        updatedWelder.welds.remove(at: index)
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex] = updatedWelder
        setSelectedWelder(welder: updatedWelder)
    }
    
    func deleteSelectedWeldPass(index: Int){
        guard var updatedWeldNumber = selectedWeldNumber else {
            return
        }
        updatedWeldNumber.parametersCollected.remove(at: index)
        
        weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].welds[weldNumberIndex] = updatedWeldNumber
        setSelectedWeldNumber(weldId: updatedWeldNumber)
    }
}
