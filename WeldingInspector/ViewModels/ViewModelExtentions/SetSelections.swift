//
//  SetSelections.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-13.
//

import Foundation

extension MainViewModel {
    
    // Methods to set selectedItems in MainViewModel
    
    func setSelectedJob(job: WeldingInspector.Job) {
        selectedJob = job
    }
    
    func setSelectedProcedure(procedure: WeldingInspector.Job.WeldingProcedure) {
        selectedWeldingProcedure = procedure
    }
    
    func setSelectedProcedurePass(weldPass: WeldingInspector.Job.WeldingProcedure.WeldPass) {
        selectedProcedurePass = weldPass
    }
    
    func setSelectedWelder(welder: WeldingInspector.Job.WeldingProcedure.Welder){
        selectedWelder = welder
    }
    
    func setSelectedWeldNumber(weldId: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers){
        selectedWeldNumber = weldId
    }
    
    func setSelectedWeldPass(weldPass: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters){
        selectedWeldPass = weldPass
    }
}
