//
//  Range.swift
//
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter

final class Range {
    public let startPoint: Point
    public let endPoint: Point
    
    public let startByte: UInt32
    public let endByte: UInt32
    
    init(startPoint: Point, endPoint: Point, startByte: UInt32, endByte: UInt32) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.startByte = startByte
        self.endByte = endByte
    }
    
    init(range: TSRange) {
        self.startPoint = Point(point: range.start_point)
        self.endPoint = Point(point: range.end_point)
        self.startByte = range.start_byte
        self.endByte = range.end_byte
    }
    
    func getTSRange() -> TSRange {
        return TSRange(start_point: startPoint.getTSPoint(), end_point: endPoint.getTSPoint(), start_byte: startByte, end_byte: endByte)
    }
}
