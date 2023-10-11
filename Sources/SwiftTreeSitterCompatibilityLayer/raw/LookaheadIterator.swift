//
//  File.swift
//
//
//  Created by Taylor Lineman on 10/9/23.
//

import TreeSitter

public final class LookaheadIterator: IteratorProtocol {
    public typealias Element = TSSymbol
    
    private var rawLookaheadIterator: TSLookaheadIterator
        
    var language: Language {
        let pointer = ts_lookahead_iterator_language(rawLookaheadIterator).pointee
        return Language(internalLanguage: pointer)
    }
    
    init(rawLookaheadIterator: TSLookaheadIterator) {
        self.rawLookaheadIterator = rawLookaheadIterator
    }
    
    deinit {
        ts_lookahead_iterator_delete(rawLookaheadIterator)
    }
}

extension LookaheadIterator {
    static func new(language: Language, stateID: TSStateID) throws -> LookaheadIterator {
        let languagePointer = language.getPointer()
        
        guard let iterator = ts_lookahead_iterator_new(languagePointer, stateID) else {
            throw CompatibilityLayerError.invalidIterator

        }
        return LookaheadIterator(rawLookaheadIterator: iterator)
    }
}

extension LookaheadIterator {
    func reset(newState: TSStateID) {
        ts_lookahead_iterator_reset_state(rawLookaheadIterator, newState)
    }
    
    func reset(newLanguage: Language, newState: TSStateID) -> Bool {
        return ts_lookahead_iterator_reset(rawLookaheadIterator, newLanguage.getPointer(), newState)
    }
}

extension LookaheadIterator {
    public func next() -> TSSymbol? {
        guard ts_lookahead_iterator_next(rawLookaheadIterator) else {
            return nil
        }
        
        return ts_lookahead_iterator_current_symbol(rawLookaheadIterator)
    }
    
    func currentName() throws -> String {
        guard let strPtr = ts_lookahead_iterator_current_symbol_name(rawLookaheadIterator) else {
            throw CompatibilityLayerError.invalidPointer(type: "Current Symbol Name")
        }

        return String(cString: strPtr)
    }
}
