//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/9/23.
//

import TreeSitter

final class QueryCapture {
    let node: Node
    let index: UInt32
    
    init(node: Node, index: UInt32) {
        self.node = node
        self.index = index
    }
    
    init(queryCapture: TSQueryCapture) {
        self.node = Node(rawNode: queryCapture.node)
        self.index = queryCapture.index
    }
}
