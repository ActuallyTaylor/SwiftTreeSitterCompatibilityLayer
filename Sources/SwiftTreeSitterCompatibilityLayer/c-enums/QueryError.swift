//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter
import Foundation

enum InternalQueryError: Int {
    case none
    case syntax
    case nodeType
    case field
    case capture
    case structure
    case language
    
    init?(queryError: TSQueryError) {
        switch queryError {
        case TSQueryErrorNone:
            self = .none
        case TSQueryErrorSyntax:
            self = .syntax
        case TSQueryErrorNodeType:
            self = .nodeType
        case TSQueryErrorField:
            self = .field
        case TSQueryErrorCapture:
            self = .capture
        case TSQueryErrorStructure:
            self = .structure
        case TSQueryErrorLanguage:
            self = .language
        default:
            return nil
        }
    }
}

enum QueryError: LocalizedError {
    case none
    case syntax(offset: UInt32)
    case nodeType(offset: UInt32)
    case field(offset: UInt32)
    case capture(offset: UInt32)
    case structure(offset: UInt32)
    case language(offset: UInt32)
    
    init(offset: UInt32, internalError: InternalQueryError) {
        switch internalError {
        case .none:
            self = .none
        case .syntax:
            self = .syntax(offset: offset)
        case .nodeType:
            self = .nodeType(offset: offset)
        case .field:
            self = .field(offset: offset)
        case .capture:
            self = .capture(offset: offset)
        case .structure:
            self = .structure(offset: offset)
        case .language:
            self = .language(offset: offset)
        }
    }
}
