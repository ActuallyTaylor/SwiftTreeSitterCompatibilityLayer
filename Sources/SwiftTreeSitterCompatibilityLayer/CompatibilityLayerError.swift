//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/8/23.
//

import Foundation

enum CompatibilityLayerError: LocalizedError {
    case invalidPointer(type: String)
    case childNotFound
    case invalidTSSymbol
}
