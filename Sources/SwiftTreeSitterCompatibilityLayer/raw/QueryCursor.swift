//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/9/23.
//

import TreeSitter

typealias TSQueryCursor = OpaquePointer

public final class QueryCursor {
    private var rawCursorPtr: TSQueryCursor

    var didExceedMatchLimit: Bool {
        ts_query_cursor_did_exceed_match_limit(rawCursorPtr)
    }
    
    var cursorMatchLimit: UInt32 {
        get {
            ts_query_cursor_match_limit(rawCursorPtr)
        }
        set {
            ts_query_cursor_set_match_limit(rawCursorPtr, newValue)
        }
    }
    
    init(rawCursorPtr: TSQueryCursor) {
        self.rawCursorPtr = rawCursorPtr
    }

    deinit {
        ts_query_cursor_delete(rawCursorPtr)
    }
}

extension QueryCursor {
    static func new(node: Node) throws -> QueryCursor {
        QueryCursor(rawCursorPtr: ts_query_cursor_new())
    }
}

extension QueryCursor {
    func exec(query: Query, node: Node) {
        ts_query_cursor_exec(rawCursorPtr, query.rawQueryPtr, node.rawNode)
    }
}

extension QueryCursor {
    func setByteRange(startByte: UInt32, endByte: UInt32) {
        ts_query_cursor_set_byte_range(rawCursorPtr, startByte, endByte)
    }
    
    func setPointRange(startPoint: Point, endPoint: Point) {
        ts_query_cursor_set_point_range(rawCursorPtr, startPoint.getTSPoint(), endPoint.getTSPoint())
    }
    
    func setMaxStartDepth(maxDepth: Int) {
        ts_query_cursor_set_max_start_depth(rawCursorPtr, UInt32(maxDepth))
    }
}

extension QueryCursor {
    func nextCapture() throws -> QueryMatch {
        var capture: TSQueryMatch = .init()
        
        ts_query_cursor_next_match(rawCursorPtr, &capture)
        
        guard let match = QueryMatch(match: capture) else {
            throw CompatibilityLayerError.invalidQueryMatch
        }
        
        return match
    }
    
    func removeMatch(match: QueryMatch) {
        ts_query_cursor_remove_match(rawCursorPtr, match.id)
    }
    
    func removeMatch(id: Int) {
        ts_query_cursor_remove_match(rawCursorPtr, UInt32(id))
    }
    
    func nextCapture() throws -> (match: QueryMatch, index: UInt32, success: Bool) {
        var matchPointer: TSQueryMatch = .init()
        var index: UInt32 = 0
        
        let success = ts_query_cursor_next_capture(rawCursorPtr, &matchPointer, &index)
        
        guard let match = QueryMatch(match: matchPointer) else {
            throw CompatibilityLayerError.invalidCapture
        }

        return (match, index, success)
    }
}
