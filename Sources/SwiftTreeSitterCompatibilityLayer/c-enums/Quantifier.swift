//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/9/23.
//

import TreeSitter

enum Quantifier: Int {
    case zero
    case zeroOrOne
    case zeroOrMore
    case one
    case oneOrMore
    
    init?(quantifier: TSQuantifier) {
        switch quantifier {
        case TSQuantifierZero:
            self = .zero
        case TSQuantifierZeroOrOne:
            self = .zeroOrOne
        case TSQuantifierZeroOrMore:
            self = .zeroOrMore
        case TSQuantifierOne:
            self = .one
        case TSQuantifierOneOrMore:
            self = .oneOrMore
        default:
            return nil
        }
        
    }
}
