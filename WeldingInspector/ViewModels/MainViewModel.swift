//
//  MainViewModel.swift
//  RewriteVersion4
//
//  Created by trevor wilson on 2024-02-13.
//

import Foundation
import Combine

class MainViewModel: ObservableObject, Equatable {
    static func == (lhs: MainViewModel, rhs: MainViewModel) -> Bool {
        // Comparison models for Equatable lhs=Left Hand Side, rhs=Right Hand Side
        return lhs.weldingInspector == rhs.weldingInspector &&
        lhs.selectedJob == rhs.selectedJob &&
        lhs.selectedWeldingProcedure == rhs.selectedWeldingProcedure &&
        lhs.selectedWelder == rhs.selectedWelder &&
        lhs.selectedWeldNumber == rhs.selectedWeldNumber &&
        lhs.selectedWeldPass == rhs.selectedWeldPass
    }
    
    // Setup for Objects to be available through scope of app
    
    @Published var weldingInspector: WeldingInspector {
        didSet {
            weldingInspectorDidChange()
        }
    }
    
    @Published var selectedJob: WeldingInspector.Job? {
        didSet {
            selectedJobDidChange()
        }
    }
    @Published var selectedWeldingProcedure: WeldingInspector.Job.WeldingProcedure?{
        didSet {
            selectedWeldingProcedureDidChange()
        }
    }
    @Published var selectedProcedurePass: WeldingInspector.Job.WeldingProcedure.WeldPass?{
        didSet {
            selectedProcedurePassDidChange()
        }
    }
    @Published var selectedWelder: WeldingInspector.Job.WeldingProcedure.Welder?{
        didSet {
            selectedWelderDidChange()
        }
    }
    @Published var selectedWeldNumber: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers?{
        didSet {
            selectedWeldNumberDidChange()
        }
    }
    @Published var selectedWeldPass: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.Parameters?{
        didSet {
            selectedWeldPassDidChange()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    var jobIndex: Int = 0
    var procedureIndex: Int = 0
    var weldPassIndex: Int = 0
    var welderIndex: Int = 0
    var weldNumberIndex: Int = 0
    var passIndex: Int = 0
    
    //Init of WeldingInspector on project launch
    init() {
        weldingInspector = StorageFunctions.retrieveInspector()
    }
    
}

