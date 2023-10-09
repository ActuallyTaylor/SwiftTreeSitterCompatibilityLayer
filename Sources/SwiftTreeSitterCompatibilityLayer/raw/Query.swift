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
        let size = MemoryLayout.size(ofValue: TSLanguage.self)
        
        let languagePointer = UnsafeMutablePointer<TSLanguage>.allocate(capacity: size)
        languagePointer.initialize(from: &language.internalLanguage, count: size)
   
        guard let point = ts_query_new(languagePointer, source, UInt32(source.utf8.count), &errorOffset, &errorType) else {
            throw QueryError(offset: errorOffset, internalError: InternalQueryError(queryError: errorType) ?? .none)
        }
        
        self.rawQueryPtr = point
    }
    
    deinit {
        ts_query_delete(rawQueryPtr)
    }
}

extension Query {
    func byte(for patternIndex: Int) -> Int {
        return Int(ts_query_start_byte_for_pattern(rawQueryPtr, UInt32(patternIndex)))
    }
    
    func predicates(for patternIndex, stepCount: Int) {
        
    }
}
