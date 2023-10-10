//
//  Language.swift
//
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter

public final class Language {
    public var internalLanguage: TSLanguage
    
    public var symbolCount: Int {
        Int(ts_language_symbol_count(&internalLanguage))
    }
    
    public var stateCount: Int {
        Int(ts_language_state_count(&internalLanguage))
    }
    
    public var fieldCount: Int {
        Int(ts_language_field_count(&internalLanguage))
    }
    
    public var languageVersion: Int {
        Int(ts_language_version(&internalLanguage))
    }
    
    public init(internalLanguage: TSLanguage) {
        self.internalLanguage = internalLanguage
    }
}

extension Language {
    public func symbolName(symbol: TSSymbol) throws -> String {
        guard let strPtr = ts_language_symbol_name(&internalLanguage, symbol) else {
            throw CompatibilityLayerError.invalidPointer(type: "Symbol Name")
        }
        
        return String(cString: strPtr)
    }
    
    public func symbolForName(name: String, isNamed: Bool) {
        ts_language_symbol_for_name(&internalLanguage, name, UInt32(name.utf8.count), isNamed)
    }
    
    public func fieldName(for id: TSFieldId) throws -> String {
        guard let strPtr = ts_language_field_name_for_id(&internalLanguage, id) else {
            throw CompatibilityLayerError.invalidPointer(type: "Field Name")
        }
        
        return String(cString: strPtr)
    }
    
    public func fieldID(for name: String) -> TSFieldId {
        ts_language_field_id_for_name(&internalLanguage, name, UInt32(name.utf8.count))
    }
    
    public func symbolType(for symbol: TSSymbol) throws -> SymbolType {
        let type = ts_language_symbol_type(&internalLanguage, symbol)
        guard let symbolType = SymbolType(symbolType: type) else {
            throw CompatibilityLayerError.invalidTSSymbol
        }
        return symbolType
    }
    
    public func nextState(state: TSStateID, symbol: TSSymbol) -> TSStateID {
        return ts_language_next_state(&internalLanguage, state, symbol)
    }
}

extension Language {
    public func getPointer() -> UnsafeMutablePointer<TSLanguage> {
        let size = MemoryLayout.size(ofValue: TSLanguage.self)

        let languagePointer = UnsafeMutablePointer<TSLanguage>.allocate(capacity: size)
        languagePointer.initialize(from: &self.internalLanguage, count: size)
        return languagePointer
    }
}
