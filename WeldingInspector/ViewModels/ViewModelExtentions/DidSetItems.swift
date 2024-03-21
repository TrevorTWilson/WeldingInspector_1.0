//
//  DidSetItems.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-13.
//

import Foundation

extension MainViewModel {
    
    func weldingInspectorDidChange () {
        print("Welding Inspector Updated")
    }
    
    
    func selectedJobDidChange () {
        if let job = selectedJob {
            // Set the jobIndex value to use with methods in Model
            // Print to console for deBugging
            if let index = weldingInspector.jobs.firstIndex(where: { $0.id == selectedJob?.id }){
                jobIndex = index
                print("Selected job: \(job.name). Has an index of: \(jobIndex)")
            } else {
                print("Selected Job: \(job.name).  Index Failed")
            }
        } else {
            print("No job selected")
        }
    }
    
    func selectedWeldingProcedureDidChange () {
        // Perform actions when selectedJob is set or changed for deBugging
        if let procedure = selectedWeldingProcedure {
            // Print to console for deBugging
            if let index = weldingInspector.jobs[jobIndex].weldingProcedures.firstIndex(where: {$0.id == selectedWeldingProcedure?.id}){
                procedureIndex = index
                print("Selected Procedure in JobIndex: \(jobIndex), has been set to index: \(procedureIndex)")
            } else {
                print("Selected procedure: \(procedure.name)  INDEX FAILED")
            }
        } else {
            print("No procedure selected")
        }
    }
    
    func selectedProcedurePassDidChange () {
        if let weldPass = selectedProcedurePass {
            // Print to console for deBugging
            if let index = weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldPass.firstIndex(where: {$0.id == selectedProcedurePass?.id}){
                weldPassIndex = index
                print("Selected WeldPass in JobIndex: \(jobIndex), and Procedureindex: \(procedureIndex), has been set to: \(weldPassIndex)")
            } else {
                print("Selected WeldPass: \(weldPass.passName)  INDEX FAILED")
            }
        } else {
            print("No procedure selected")
        }
    }
    
    func selectedWelderDidChange () {
        if let welder = selectedWelder {
            // Print to console for deBugging
            if let index = weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified.firstIndex(where: {$0.id == selectedWelder?.id}){
                welderIndex = index
                print("Selected Welder in JobIndex: \(jobIndex) and Procedure Index: \(procedureIndex). has been set to index: \(welderIndex)")
            } else {
                print("Selected welder: \(welder.name) INDEX FAILED")
            }
        } else {
            print("No welder selected")
        }
    }
    
    func selectedWeldNumberDidChange () {
        // Perform actions when selectedJob is set or changed for deBuging
        if let number = selectedWeldNumber {
            // Print to console for deBugging
            if let index = weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].welds.firstIndex(where: {$0.id == selectedWeldNumber?.id}){
                weldNumberIndex = index
                print("Selected Weld Number in JobIndex: \(jobIndex) with Procedure Index: \(procedureIndex), and Welder Index \(welderIndex) has been set to index: \(weldNumberIndex)")
            } else{
                print("Selected weld number: \(number.name) INDEX FAILED")
            }
        } else {
            print("No weld number selected")
        }
    }
    
    func selectedWeldPassDidChange () {
        // Perform actions when selectedJob is set or changed for deBugging
        if let parameters = selectedWeldPass {
            // Print to console for deBugging
            if let index = weldingInspector.jobs[jobIndex].weldingProcedures[procedureIndex].weldersQualified[welderIndex].welds[weldNumberIndex].parametersCollected.firstIndex(where: {$0.id == selectedWeldPass?.id}){
                passIndex = index
                print("Selected passName in JobIndex: \(jobIndex) with procedureIndex: \(procedureIndex), welderIndex: \(welderIndex), weldNumberIndex: \(weldNumberIndex) has been set to index: \(passIndex)")
            } else {
                print("Selected WeldPass \(parameters.passName)  INDEX FAILED")
            }
        } else {
            print("No weld pass selected")
        }
    }
}
