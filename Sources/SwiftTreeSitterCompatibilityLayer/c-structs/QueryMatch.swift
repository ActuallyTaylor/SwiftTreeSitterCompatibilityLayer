//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/9/23.
//

import TreeSitter

final class QueryMatch {
    let id: UInt32
    let patternIndex: UInt16
    let captureCount: UInt16
    let captures: [QueryCapture]
    
    init(id: UInt32, patternIndex: UInt16, captureCount: UInt16, captures: [QueryCapture]) {
        self.id = id
        self.patternIndex = patternIndex
        self.captureCount = captureCount
        self.captures = captures
    }
    
    init?(match: TSQueryMatch) {
        self.id = match.id
        self.patternIndex = match.pattern_index
        self.captureCount = match.capture_count

        guard let pointer = UnsafeMutableRawPointer(mutating: match.captures) else {
            return nil
        }
        
        let array = pointer.toArray(to: TSQueryCapture.self, capacity: Int(captureCount))
        captures = array.compactMap{(QueryCapture(queryCapture: $0))}
    }
}

extension UnsafeMutableRawPointer {
    func toArray<T>(to type: T.Type, capacity count: Int) -> [T]{
        let pointer = bindMemory(to: type, capacity: count)
        return Array(UnsafeBufferPointer(start: pointer, count: count))
    }
}

