//
//  Point.swift
//
//
//  Created by Taylor Lineman on 10/8/23.
//

import TreeSitter

public final class Point {
    public let row: UInt32
    public let column: UInt32
    
    public init(row: UInt32, column: UInt32) {
        self.row = row
        self.column = column
    }
    
    init(point: TSPoint) {
        self.row = point.row
        self.column = point.column
    }
    
    func getTSPoint() -> TSPoint {
        return TSPoint(row: row, column: column)
    }
}

extension Point: Comparable {
    public static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.row < rhs.row && lhs.column < rhs.column
    }
    
    public static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
}
