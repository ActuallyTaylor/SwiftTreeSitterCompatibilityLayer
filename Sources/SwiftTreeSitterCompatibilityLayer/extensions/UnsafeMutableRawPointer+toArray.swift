//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/10/23.
//

import Foundation

extension UnsafeMutableRawPointer {
    func toArray<T>(to type: T.Type, capacity count: Int) -> [T]{
        let pointer = bindMemory(to: type, capacity: count)
        return Array(UnsafeBufferPointer(start: pointer, count: count))
    }
}

