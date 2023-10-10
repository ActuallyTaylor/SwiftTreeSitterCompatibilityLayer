//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/10/23.
//

import TreeSitter
import System

public typealias TSParser = OpaquePointer
public typealias TSCancellationFlag = UnsafePointer<Int>

public final class Parser {
    private var rawParserPtr: TSParser
    
    public var language: Language {
        get {
            Language(internalLanguage: ts_parser_language(rawParserPtr).pointee)
        }
        set {
            ts_parser_set_language(rawParserPtr, newValue.getPointer())
        }
    }
    
    public var includedRanges: [Range] {
        get {
            var count: UInt32 = 0
            let ranges = ts_parser_included_ranges(rawParserPtr, &count)
            guard let pointer = UnsafeMutableRawPointer(mutating: ranges) else {
                return []
            }
            
            let array = pointer.toArray(to: TSRange.self, capacity: Int(count))
            return array.compactMap{(Range(range: $0))}
        }
        set {
            ts_parser_set_included_ranges(rawParserPtr, newValue.compactMap({$0.getTSRange()}), UInt32(newValue.count))
        }
    }
    
    public var timeoutMS: UInt64 {
        get {
            ts_parser_timeout_micros(rawParserPtr)
        }
        set {
            ts_parser_set_timeout_micros(rawParserPtr, newValue)
        }
    }
    
    public var cancellationFlag: TSCancellationFlag {
        get {
            ts_parser_cancellation_flag(rawParserPtr)
        }
        set {
            ts_parser_set_cancellation_flag(rawParserPtr, newValue)
        }
    }
    
    #warning("Implement a wrapper for TSLogger")
    public var logger: TSLogger {
        get {
            ts_parser_logger(rawParserPtr)
        }
        set {
            ts_parser_set_logger(rawParserPtr, newValue)
        }
    }
    
    public init(rawParserPtr: TSParser) {
        self.rawParserPtr = rawParserPtr
    }

    deinit {
        ts_parser_delete(rawParserPtr)
    }
}

extension Parser {
    public static func new() -> Parser {
        return Parser(rawParserPtr: ts_parser_new())
    }
}

extension Parser {
    public func reset() {
        ts_parser_reset(rawParserPtr)
    }
}

extension Parser {
    // TODO: Implement the `ts_parser_parse` function
//    func parse(oldTree: Tree?, input: Input) {
//        
//    }
    
    public func parseString(oldTree: Tree?, string: String, encoding: InputEncoding = .utf8) throws -> Tree {
        guard let cstr = string.cString(using: encoding.swiftValue) else {
            throw CompatibilityLayerError.failedToCreateCString
        }
        let stringByteLength = string.count
        let buffer = Array(cstr)
        
        let treePointer: TSTree? = ts_parser_parse_string_encoding(rawParserPtr, nil, buffer, UInt32(stringByteLength), TSInputEncodingUTF8)
        return try Tree(rawTreePtr: treePointer)
    }
}

extension Parser {
    @available(macOS 11.0, *)
    public func setDotGraphFileDescriptor(descriptor: FileDescriptor) {
        ts_parser_print_dot_graphs(rawParserPtr, descriptor.rawValue)
    }
}
