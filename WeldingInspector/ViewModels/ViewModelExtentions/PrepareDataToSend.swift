//
//  PrepareDataToSend.swift
//  WeldingInspector
//
//  Created by trevor wilson on 2024-04-03.
//

import Foundation

extension MainViewModel {
 
    func prepareJob (job: WeldingInspector.Job) -> WeldingInspector.Job {
        var updatedJob = job
        for (procedureIndex, procedure) in updatedJob.weldingProcedures.enumerated(){
            updatedJob.weldingProcedures[procedureIndex].weldersQualified = []
        }
        return updatedJob
    }
    
    func prepareProcedure (procedure: WeldingInspector.Job.WeldingProcedure) -> WeldingInspector.Job.WeldingProcedure{
        var updatedProcedure = procedure
        updatedProcedure.weldersQualified = []
        return updatedProcedure
    }
    
    func prepareWelder (welder: WeldingInspector.Job.WeldingProcedure.Welder) -> WeldingInspector.Job.WeldingProcedure.Welder {
        var updatedWelder = welder
        updatedWelder.welds = []
        return updatedWelder
    }
}
