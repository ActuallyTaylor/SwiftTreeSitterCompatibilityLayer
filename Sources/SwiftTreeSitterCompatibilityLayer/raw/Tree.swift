//
//  Tree.swift
//  Open-Jellycore
//
//  Created by Taylor Lineman on 5/21/23.
//

import TreeSitter

public typealias TSTree = OpaquePointer

/// A wrapper over `TreeSitter`s `TSTree` structure that wraps it in memory safe swift code.
public final class Tree {
    /// A raw pointer to the `TSTree` object on the heap. `TreeSitter` does not provide `TSTree` as a struct like it does `TSNode` so a raw pointer to the memory is needed.
    let rawTreePtr: TSTree?
    
    /// Initializes a `TreeSitterTree` with a raw pointer to the memory. If the memory is invalid, an error is thrown.
    /// - Parameter rawTreePtr: The pointer to the `TSTree` in memory.
    public init(rawTreePtr: TSTree?) throws {
        guard let rawTreePtr else {
            throw CompatibilityLayerError.invalidPointer(type: "TreeSitterTree")
        }
        self.rawTreePtr = rawTreePtr
    }
    
    /// A deinit function that deletes the tree from memory to properly manage the C memory.
    deinit {
        ts_tree_delete(rawTreePtr)
    }
    
    /// Retrieves the root node of the tree
    /// - Returns: The root node of the tree
    func rootNode() -> Node {
        let node = ts_tree_root_node(rawTreePtr)
        return Node(rawNode: node)
    }
}

extension Tree {
    /// Copies this tree into another`TSTree`. It is necessary to copy if working on multiple threads because `TSTree` is not thread safe.
    /// - Returns: An optional pointer to the copied tree.
    func copy() -> TSTree? {
        return ts_tree_copy(rawTreePtr)
    }
}
