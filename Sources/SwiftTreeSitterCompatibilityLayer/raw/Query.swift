//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter
import Foundation

typealias TSQuery = OpaquePointer

final class Query {
    let rawQueryPtr: TSQuery?
    
    var patternCount: Int {
        Int(ts_query_pattern_count(rawQueryPtr))
    }
    
    var captureCount: Int {
        Int(ts_query_capture_count(rawQueryPtr))
    }
    
    var stringCount: Int {
        Int(ts_query_string_count(rawQueryPtr))
    }

    init(language: Language, source: String) throws {
        var errorOffset: UInt32 = 0
        var errorType: TSQueryError = TSQueryErrorNone

        let languagePointer = language.getPointer()

        guard let point = ts_query_new(languagePointer, source, UInt32(source.utf8.count), &errorOffset, &errorType) else {
            throw QueryError(offset: errorOffset, internalError: InternalQueryError(queryError: errorType) ?? .none)
        }
        
        self.rawQueryPtr = point
    }
    
    deinit {
        ts_query_delete(rawQueryPtr)
    }
}

// MARK: Patterns
extension Query {
    func startByte(for patternIndex: Int) -> Int {
        return Int(ts_query_start_byte_for_pattern(rawQueryPtr, UInt32(patternIndex)))
    }
    
    func predicatesForPattern(at index: Int) {
        // TODO: Implement predicates
    }
    
    func isPatternRooted(patternIndex: Int) -> Bool {
        return ts_query_is_pattern_rooted(rawQueryPtr, UInt32(patternIndex))
    }
    
    func isPatternNonLocal(patternIndex: Int) -> Bool {
        return ts_query_is_pattern_non_local(rawQueryPtr, UInt32(patternIndex))
    }
    
    func isPatternGuaranteedAtStep(offset: Int) -> Bool {
        return ts_query_is_pattern_guaranteed_at_step(rawQueryPtr, UInt32(offset))
    }
}

// MARK: Captures
extension Query {
    func captureName(for capture: QueryCapture) throws -> (name: String, length: UInt32){
        var length: UInt32 = 0
        guard let strPtr = ts_query_capture_name_for_id(rawQueryPtr, capture.index, &length) else {
            throw CompatibilityLayerError.invalidPointer(type: "Capture Name")
        }

        return (String(cString: strPtr), length)
    }
    
    func captureQuantifier(patternIndex: Int, capture: QueryCapture) throws -> Quantifier {
        let rawQuantifier = ts_query_capture_quantifier_for_id(rawQueryPtr, UInt32(patternIndex), capture.index)
        guard let quantifier = Quantifier(quantifier: rawQuantifier) else {
            throw CompatibilityLayerError.invalidTSQuantifier
        }
        
        return quantifier
    }
    
    func stringValue(for index: Int) throws -> (value: String, length: UInt32) {
        var length: UInt32 = 0
        guard let strPtr = ts_query_string_value_for_id(rawQueryPtr, UInt32(index), &length) else {
            throw CompatibilityLayerError.invalidPointer(type: "Field Name")
        }

        return (String(cString: strPtr), length)
    }
    
    func disableCapture(name: String) {
        ts_query_disable_capture(rawQueryPtr, name, UInt32(name.utf8.count))
    }
    
    func disablePattern(index: Int) {
        ts_query_disable_pattern(rawQueryPtr, UInt32(index))
    }
}
