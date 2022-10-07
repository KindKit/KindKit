//
//  KindKit
//

import Foundation

public extension Polylabel2 {

    static func find(
        polyline: Polyline2< Value >
    ) -> Point< Value >
        where Value : Strideable, Value.Stride == Value
    {
            func polylabel(polygon: [[[Value]]], precision: Value = 1) -> [Value] {
                var minX: Value = .leastNormalMagnitude
                var minY: Value = .leastNormalMagnitude
                var maxX: Value = .greatestFiniteMagnitude
                var maxY: Value = .greatestFiniteMagnitude
                for i in 0..<polygon[0].count {
                    let p = polygon[0][i]
                    if i == 0 || p[0] < minX {
                        minX = p[0]
                    }
                    if i == 0 || p[1] < minY {
                        minY = p[1]
                    }
                    if i == 0 || p[0] > maxX {
                        maxX = p[0]
                    }
                    if i == 0 || p[1] > maxY {
                        maxY = p[1]
                    }
                }
                
                let width = maxX - minX
                let height = maxY - minY
                let cellSize = min(width, height)
                var h = cellSize / 2
                
                var cellQueue = Queue(data: [], compare: compareMax)
                
                if cellSize == 0 {
                    return [minX, minY]
                }
                
                for x in stride(from: minX, to: maxX, by: cellSize) {
                    for y in stride(from: minY, to: maxY, by: cellSize) {
                        cellQueue.push(item: Cell(x: x + h, y: y + h, h: h, polygon: polygon))
                    }
                }
                
                var bestCell = getCentroidCell(polygon: polygon)
                
                let bboxCell = Cell(x: minX + width / 2, y: minY + height / 2, h: 0, polygon: polygon)
                if (bboxCell.d > bestCell.d) {
                    bestCell = bboxCell
                }
                var numProbes = cellQueue.length
                
                while (cellQueue.length != 0) {
                    if let cell = cellQueue.pop() {
                        if (cell.d > bestCell.d) {
                            bestCell = cell;
                        }
                        if (cell.max - bestCell.d <= precision) {
                            continue
                        }
                        h = cell.h / 2
                        cellQueue.push(item: Cell(x: cell.x - h, y: cell.y - h, h: h, polygon: polygon))
                        cellQueue.push(item: Cell(x: cell.x + h, y: cell.y - h, h: h, polygon: polygon))
                        cellQueue.push(item: Cell(x: cell.x - h, y: cell.y + h, h: h, polygon: polygon))
                        cellQueue.push(item: Cell(x: cell.x + h, y: cell.y + h, h: h, polygon: polygon))
                        numProbes += 4
                    }
                }
                return [bestCell.x, bestCell.y]
            }
            
            func compareMax(a: Cell, b: Cell) -> Value {
                return b.max - a.max
            }
            
            func getCentroidCell(polygon:[[[Value]]]) -> Cell {
                var area: Value = 0
                var x: Value = 0
                var y: Value = 0
                let points = polygon[0]
                
                var j = points.count - 1
                for i in 0..<points.count {
                    let a = points[i]
                    let b = points[j]
                    let f = a[0] * b[1] - b[0] * a[1]
                    x += (a[0] + b[0]) * f
                    y += (a[1] + b[1]) * f
                    area += f * 3
                    j = i

                }

                if (area == 0)  {
                    return Cell(x: points[0][0], y: points[0][1], h: 0, polygon: polygon)
                }
                return Cell(x: x / area, y: y / area, h: 0, polygon: polygon);
            }
            
            func toMultiArray(corners: [Point< Value> ]) -> [[Value]] {
                return corners.map { [$0.x, $0.y] }
            }
            
            let polygon: [[[Value]]] = [toMultiArray(corners: polyline.corners)]
            
            let point = polylabel(polygon: polygon)
            
            return  Point< Value >(x: point[0], y: point[1])
    }
        
}

private extension Polylabel2 {
    
    struct Queue {
        var data: [Cell]
        var compare: (Cell, Cell) -> Value
        var length: Int {
            self.data.count
        }
        
        init(data: [Cell], compare: @escaping (Cell, Cell) -> Value) {
            self.data = data
            self.compare = compare
            if (self.length > 0) {
                for i in (0...(self.length >> 1) - 1).reversed() {
                    down(pos: i)
                }
            }
        }
        
        mutating func push(item: Cell) {
            data.append(item)
            up(pos: length - 1)
        }
        
        mutating func pop() -> Cell? {
            if length == 0 {
                return nil
            }
            let top = data[0]
            let bottom = data.removeLast()
            
            if (length > 0) {
                data[0] = bottom
                down(pos: 0)
            }
            return top
        }
        
        mutating func up(pos: Int) {
            var pos = pos
            let compare = self.compare
            let item = data[pos]
            
            while (pos > 0) {
                let parent = (pos - 1) >> 1
                let current = data[parent]
                if (compare(item, current) >= 0) {
                    break
                }
                data[pos] = current
                pos = parent
            }
            
            data[pos] = item
        }
        
        func peek() -> Cell {
            return data[0]
        }
        
        mutating func down(pos: Int) {
            var pos = pos
            let halfLength = length >> 1
            let item = data[pos]
            
            while (pos < halfLength) {
                var left = (pos << 1) + 1
                var best = data[left]
                let right = left + 1
                
                if (right < length && compare(data[right], best) < 0) {
                    left = right
                    best = data[right]
                }
                if (compare(best, item) >= 0) {
                    break
                }
                
                data[pos] = best
                pos = left
            }
            
            data[pos] = item
        }
    }

    struct Cell {
        var x: Value
        var y: Value
        var h: Value
        var polygon: [[[Value]]]
        var d: Value {
            self.pointToPolygonDist(x: x, y: y, polygon: polygon)
        }
        var max: Value {
            self.d + self.h * Value(2).sqrt
        }
        
        func pointToPolygonDist(x: Value, y: Value, polygon: [[[Value]]]) -> Value {
            var inside = false
            var minDistSq: Value = .greatestFiniteMagnitude
            for k in 0..<polygon.count {
                let ring = polygon[k]
                var j = ring.count - 1
                for i in 0..<ring.count {
                    let a = ring[i]
                    let b = ring[j]
                    
                    let ab = ((a[1] > y) != (b[1] > y))
                    let b0MinusA0 = (b[0] - a[0])
                    let yMinusA1 = (y - a[1])
                    let b1MinusA1 = (b[1] - a[1])
                    if (ab && (x < b0MinusA0 * yMinusA1 / b1MinusA1 + a[0])) {
                        inside = !inside
                    }
                    minDistSq = min(minDistSq, getSegDistSq(px: x, py: y, a: a, b: b))
                    j = i
                }
            }
            return (inside ? 1 : -1) * (minDistSq).sqrt
        }
        
        func getSegDistSq(px: Value, py: Value, a: [Value], b: [Value]) -> Value {
            var x = a[0]
            var y = a[1]
            var dx = b[0] - x
            var dy = b[1] - y
            
            if (dx != 0 || dy != 0) {
                
                let pxMinusX = (px - x)
                let pyMinusY = (py - y)
                let pxMinusXMultiplyDx = pxMinusX * dx
                let pyMinusYMultiplyDy = pyMinusY * dy
                let t = (pxMinusXMultiplyDx + pyMinusYMultiplyDy) / (dx * dx + dy * dy)
                
                if (t > 1) {
                    x = b[0]
                    y = b[1]
                    
                } else if (t > 0) {
                    x += dx * t
                    y += dy * t
                }
            }
            
            dx = px - x;
            dy = py - y;
            
            return dx * dx + dy * dy
        }
    }
}

public extension Polyline2 {

    func visualCenter() -> Point < Value > where Value : Strideable, Value.Stride == Value {
        return Polylabel2<Value>.find(polyline: self)
    }

}
