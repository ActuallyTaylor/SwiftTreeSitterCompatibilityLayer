//
//  QueryPredicateStep.swift
//
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter

final class QueryPredicateStep {
    let type: QueryPredicateStepType
    let valueID: UInt32
    
    init(type: QueryPredicateStepType, valueID: UInt32) {
        self.type = type
        self.valueID = valueID
    }
    
    init?(predicateStep: TSQueryPredicateStep) {
        guard let type = QueryPredicateStepType(type: predicateStep.type) else {
            return nil
        }
        self.type = type
        self.valueID = predicateStep.value_id
    }
}
