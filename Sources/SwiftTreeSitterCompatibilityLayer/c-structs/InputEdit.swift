//
//  File.swift
//  
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter

final class InputEdit {
    public let startByte: UInt32
    public let oldEndByte: UInt32
    public let newEndByte: UInt32
    
    public let startPoint: Point
    public let oldEndPoint: Point
    public let newEndPoint: Point
    
    init(startByte: UInt32, oldEndByte: UInt32, newEndByte: UInt32, startPoint: Point, oldEndPoint: Point, newEndPoint: Point) {
        self.startByte = startByte
        self.oldEndByte = oldEndByte
        self.newEndByte = newEndByte
        self.startPoint = startPoint
        self.oldEndPoint = oldEndPoint
        self.newEndPoint = newEndPoint
    }
    
    init(inputEdit: TSInputEdit) {
        self.startByte = inputEdit.start_byte
        self.oldEndByte = inputEdit.old_end_byte
        self.newEndByte = inputEdit.new_end_byte
        self.startPoint = Point(point: inputEdit.start_point)
        self.oldEndPoint = Point(point: inputEdit.old_end_point)
        self.newEndPoint = Point(point: inputEdit.new_end_point)
    }
}
