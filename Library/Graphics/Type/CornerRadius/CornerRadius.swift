//
//  KindKit
//

import KindGeometry

public enum CornerRadius {
    
    case none
    case auto(percent: Percent, edges: Edge)
    case manual(radius: Coordinate, edges: Edge)
    
}

extension CornerRadius : Hashable {
}

extension CornerRadius : Equatable {
}

extension CornerRadius : Sendable {
}

public extension CornerRadius {
    
    static var auto: Self {
        return .auto(percent: .half, edges: .all)
    }
    
}

public extension CornerRadius {
    
    static func auto(edges: Edge) -> Self {
        return .auto(percent: .half, edges: edges)
    }
    
    static func manual(radius: Coordinate) -> Self {
        return .manual(radius: radius, edges: .all)
    }
    
}

public extension CornerRadius {
    
    static func path2(
        rect: Rect,
        border: Border?,
        corner: CornerRadius
    ) -> Path2 {
        let inset = border?.width ?? .zero
        return Self.path2(
            rect: rect.inset(inset),
            corner: corner
        )
    }
    
    static func path2(
        rect: Rect,
        corner: CornerRadius
    ) -> Path2 {
        var tl: Coordinate
        var tr: Coordinate
        var bl: Coordinate
        var br: Coordinate
        switch corner {
        case .none:
            tl = .zero
            tr = .zero
            bl = .zero
            br = .zero
        case .manual(let radius, let edges):
            if edges.contains(.topLeft) == true {
                tl = radius.to()
            } else {
                tl = .zero
            }
            if edges.contains(.topRight) == true {
                tr = radius.to()
            } else {
                tr = .zero
            }
            if edges.contains(.bottomLeft) == true {
                bl = radius.to()
            } else {
                bl = .zero
            }
            if edges.contains(.bottomRight) == true {
                br = radius.to()
            } else {
                br = .zero
            }
        case .auto(let percent, let edges):
            if rect.width.isMoreZero && rect.height.isMoreZero {
                let ms = (rect.width - .one).min(rect.height - .one)
                let mr = ms.roundedDown * percent
                if edges.contains(.topLeft) == true {
                    tl = mr
                } else {
                    tl = .zero
                }
                if edges.contains(.topRight) == true {
                    tr = mr
                } else {
                    tr = .zero
                }
                if edges.contains(.bottomLeft) == true {
                    bl = mr
                } else {
                    bl = .zero
                }
                if edges.contains(.bottomRight) == true {
                    br = mr
                } else {
                    br = .zero
                }
            } else {
                tl = .zero
                tr = .zero
                bl = .zero
                br = .zero
            }
        }
        return Path2.round(
            rect: rect,
            tl: tl,
            tr: tr,
            bl: bl,
            br: br
        )
    }
    
}
