//
//  Tree.swift
//  Open-Jellycore
//
//  Created by Taylor Lineman on 5/21/23.
//

import TreeSitter
import System

/// A wrapper over `TreeSitter`s `TSTree` structure that wraps it in memory safe swift code.
public final class Tree {
    /// A raw pointer to the `TSTree` object on the heap. `TreeSitter` does not provide `TSTree` as a struct like it does `TSNode` so a raw pointer to the memory is needed.
    let rawTreePtr: TSTree?
    
    public var tree: Language? {
        get {
            guard let language = ts_tree_language(rawTreePtr) else {
                return nil
            }
            return Language(internalLanguage: language.pointee)
        }
    }
    
    public var includedRanges: [Range] {
        get {
            var count: UInt32 = 0
            let ranges = ts_tree_included_ranges(rawTreePtr, &count)
            guard let pointer = UnsafeMutableRawPointer(mutating: ranges) else {
                return []
            }
            
            let array = pointer.toArray(to: TSRange.self, capacity: Int(count))
            return array.compactMap{(Range(range: $0))}
        }
    }
    
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
}

extension Tree {
    /// Copies this tree into another`TSTree`. It is necessary to copy if working on multiple threads because `TSTree` is not thread safe.
    /// - Returns: An optional pointer to the copied tree.
    public func copy() -> TSTree? {
        return ts_tree_copy(rawTreePtr)
    }
    
    @available(macOS 11.0, *)
    public func printDotGraph(descriptor: FileDescriptor) {
        ts_tree_print_dot_graph(rawTreePtr, descriptor.rawValue)
    }
}

extension Tree {
    /// Retrieves the root node of the tree
    /// - Returns: The root node of the tree
    public func rootNode() -> Node {
        let node = ts_tree_root_node(rawTreePtr)
        return Node(rawNode: node)
    }

    public func rootNode(with offset: Int, extent: Point) -> Node {
        let node = ts_tree_root_node_with_offset(rawTreePtr, UInt32(offset), extent.getTSPoint())
        return Node(rawNode: node)
    }
}

extension Tree {
    public func edit(edit: InputEdit) {
        var edit = edit.getTSInputEdit()
        ts_tree_edit(rawTreePtr, &edit)
    }
}

extension Tree {
    public static func getChangedRanges(oldTree: Tree, newTree: Tree) -> [Range] {
        var count: UInt32 = 0
        let ranges = ts_tree_get_changed_ranges(oldTree.rawTreePtr, newTree.rawTreePtr, &count)
        guard let pointer = UnsafeMutableRawPointer(mutating: ranges) else {
            return []
        }
        
        let array = pointer.toArray(to: TSRange.self, capacity: Int(count))
        return array.compactMap{(Range(range: $0))}
    }
}
