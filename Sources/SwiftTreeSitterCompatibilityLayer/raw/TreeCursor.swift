//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter

final class TreeCursor {
    private var internalCursor: TSTreeCursor
    
    var currentNode: Node {
        Node(rawNode: ts_tree_cursor_current_node(&internalCursor))
    }
    
    var currentFieldName: String? {
        if let strPtr = ts_tree_cursor_current_field_name(&internalCursor) {
            return String(cString: strPtr)
        }
        return nil
    }
    
    var currentFieldID: TSFieldId {
        ts_tree_cursor_current_field_id(&internalCursor)
    }
    
    var currentDescendantIndex: Int {
        Int(ts_tree_cursor_current_descendant_index(&internalCursor))
    }
    
    var currentDepth: Int {
        Int(ts_tree_cursor_current_depth(&internalCursor))
    }

    init(internalCursor: TSTreeCursor) {
        self.internalCursor = internalCursor
    }

    deinit {
        ts_tree_cursor_delete(&internalCursor)
    }
}

extension TreeCursor {
    static func new(node: Node) throws -> TreeCursor {
        TreeCursor(internalCursor: ts_tree_cursor_new(node.rawNode))
    }
    
    static func copy(cursor: TreeCursor) -> TreeCursor {
        TreeCursor(internalCursor: ts_tree_cursor_copy(&cursor.internalCursor))
    }
}

extension TreeCursor {
    func reset(newNode: Node) {
        ts_tree_cursor_reset(&internalCursor, newNode.rawNode)
    }
    
    func resetTo(destination: TreeCursor) {
        ts_tree_cursor_reset_to(&destination.internalCursor, &internalCursor)
    }
}

extension TreeCursor {
    func gotoParent() -> Bool {
        ts_tree_cursor_goto_parent(&internalCursor)
    }
    
    func gotoNextSibling() -> Bool {
        ts_tree_cursor_goto_next_sibling(&internalCursor)
    }
    
    func gotoPreviousSibling() -> Bool {
        ts_tree_cursor_goto_previous_sibling(&internalCursor)
    }

    func gotoFirstChild() -> Bool {
        ts_tree_cursor_goto_first_child(&internalCursor)
    }
    
    func gotoLastChild() -> Bool {
        ts_tree_cursor_goto_last_child(&internalCursor)
    }
    
    func gotoDescendant(index: Int) {
        ts_tree_cursor_goto_descendant(&internalCursor, UInt32(index))
    }
    
    func gotoFirstChild(for byte: Int) throws -> Int {
        let index = ts_tree_cursor_goto_first_child_for_byte(&internalCursor, UInt32(byte))
        guard index != -1 else { throw CompatibilityLayerError.childNotFound }
        return Int(index)
    }
    
    func gotoFirstChild(for point: Point) throws -> Int {
        let index = ts_tree_cursor_goto_first_child_for_point(&internalCursor, point.getTSPoint())
        guard index != -1 else { throw CompatibilityLayerError.childNotFound }
        return Int(index)
    }
}
