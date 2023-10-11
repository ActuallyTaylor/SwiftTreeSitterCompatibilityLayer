//
//  QueryPredicateStepType.swift
//  
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter

enum QueryPredicateStepType: Int {
    case done
    case capture
    case string
    
    init?(type: TSQueryPredicateStepType) {
        switch type {
        case TSQueryPredicateStepTypeDone:
            self = .done
        case TSQueryPredicateStepTypeCapture:
            self = .capture
        case TSQueryPredicateStepTypeString:
            self = .string
        default:
            return nil
        }
    }
    
    var treeSitterValue: TSQueryPredicateStepType {
        switch self {
        case .done:
            return TSQueryPredicateStepTypeDone
        case .capture:
            return TSQueryPredicateStepTypeCapture
        case .string:
            return TSQueryPredicateStepTypeString
        }
    }
}
