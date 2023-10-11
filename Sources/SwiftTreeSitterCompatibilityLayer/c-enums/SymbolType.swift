//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter

public enum SymbolType: Int {
    case regular = 0
    case anonymous = 1
    case auxiliary = 2
    
    init?(symbolType: TSSymbolType) {
        switch symbolType {
        case TSSymbolTypeRegular:
            self = .regular
        case TSSymbolTypeAnonymous:
            self = .anonymous
        case TSSymbolTypeAuxiliary:
            self = .auxiliary
        default:
            return nil
        }
    }
    
    var treeSitterValue: TSSymbolType {
        switch self {
        case .regular:
            return TSSymbolTypeRegular
        case .anonymous:
            return TSSymbolTypeAnonymous
        case .auxiliary:
            return TSSymbolTypeAuxiliary
        }
    }
}
