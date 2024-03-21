//
//  FunctionsToGroupItems.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-03-14.
//

import Foundation

extension MainViewModel {
    
    func getAllWeldingProcedure() -> [String : WeldingInspector.Job.WeldingProcedure] {
        var allWeldingProcedures: [String : WeldingInspector.Job.WeldingProcedure] = [:]
        
        for job in weldingInspector.jobs {
            for weldingProcedure in job.weldingProcedures {
                var updatedWeldingProcedure = weldingProcedure
                updatedWeldingProcedure.weldersQualified = []
                let label = updatedWeldingProcedure.name
                allWeldingProcedures[label] = updatedWeldingProcedure // Assign to the specified key in the dictionary
            }
        }
        
        return allWeldingProcedures
    }

    
    func getAllWelders() -> [String : WeldingInspector.Job.WeldingProcedure.Welder] {
        
        var allWelders: [String : WeldingInspector.Job.WeldingProcedure.Welder] = [:]
        
        for job in weldingInspector.jobs {
            for weldingProcedure in job.weldingProcedures {
                for welder in weldingProcedure.weldersQualified {
                    var updatedWelder = welder
                    updatedWelder.welds = []
                    let label = updatedWelder.name
                    allWelders[label] = updatedWelder
                }
            }
        }
        return allWelders
    }
}
