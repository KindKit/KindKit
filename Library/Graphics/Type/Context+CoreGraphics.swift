//
//  KindKit
//

#if canImport(CoreGraphics)

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import CoreGraphics
import KindGeometry

public struct Context {
    
    public let cgContext: CGContext
    public var size: Size
    
    public init(
        cgContext: CGContext,
        size: CGSize
    ) {
        self.cgContext = cgContext
        self.size = .init(size)
    }
    
}

public extension Context {
    
    @inlinable
    var bbox: AlignedBox2 {
        return .init(
            lower: .zero,
            upper: .init(self.size)
        )
    }
    
}

public extension Context {
    
    enum Positioning {
        
        case topLeft
        case top
        case topRight
        case left
        case center
        case right
        case bottomLeft
        case bottom
        case bottomRight
        
    }
    
}

public extension Context {
    
    func apply(
        matrix: Matrix3? = nil,
        alpha: Alpha? = nil,
        fill: Fill? = nil,
        stroke: Stroke? = nil,
        block: () -> Void
    ) {
        self.cgContext.saveGState()
        if let matrix = matrix {
            self._apply(matrix: matrix)
        }
        if let alpha = alpha {
            self._apply(alpha: alpha)
        }
        if let fill = fill {
            self._apply(fill: fill)
        }
        if let stroke = stroke {
            self._apply(stroke: stroke)
        }
        block()
        self.cgContext.restoreGState()
    }
    
    func apply(
        fill: Fill? = nil,
        stroke: Stroke? = nil,
        block: () -> Void
    ) {
        self.cgContext.saveGState()
        if let fill = fill {
            self._apply(fill: fill)
        }
        if let stroke = stroke {
            self._apply(stroke: stroke)
        }
        block()
        self.cgContext.restoreGState()
    }
    
    func draw(
        circle: Circle,
        mode: DrawMode
    ) {
        self.cgContext.saveGState()
        self.cgContext.beginPath()
        self.cgContext.addEllipse(in: CGRect(
            x: CGFloat(circle.origin.x - circle.radius.value),
            y: CGFloat(circle.origin.y - circle.radius.value),
            width: CGFloat(circle.radius.value * 2),
            height: CGFloat(circle.radius.value * 2)
        ))
        self._draw(mode: mode)
        self.cgContext.restoreGState()
    }
    
    func draw(
        circles: [Circle],
        mode: DrawMode
    ) {
        guard circles.isEmpty == false else { return }
        self.cgContext.saveGState()
        self.cgContext.beginPath()
        for index in circles.indices {
            let circle = circles[index]
            self.cgContext.addEllipse(in: CGRect(
                x: CGFloat(circle.origin.x - circle.radius.value),
                y: CGFloat(circle.origin.y - circle.radius.value),
                width: CGFloat(circle.radius.value * 2),
                height: CGFloat(circle.radius.value * 2)
            ))
        }
        if self.cgContext.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self.cgContext.restoreGState()
    }
    
    func draw(
        segment: Segment2
    ) {
        self.cgContext.saveGState()
        self.cgContext.beginPath()
        self.cgContext.move(to: segment.start.cgPoint)
        self.cgContext.addLine(to: segment.end.cgPoint)
        self.cgContext.drawPath(using: .stroke)
        self.cgContext.restoreGState()
    }
    
    func draw(
        segments: [Segment2]
    ) {
        guard segments.isEmpty == false else { return }
        self.cgContext.saveGState()
        self.cgContext.beginPath()
        for segment in segments {
            self.cgContext.move(to: segment.start.cgPoint)
            self.cgContext.addLine(to: segment.end.cgPoint)
        }
        self.cgContext.drawPath(using: .stroke)
        self.cgContext.restoreGState()
    }
    
    func draw(
        polyline: Polyline2,
        mode: DrawMode
    ) {
        guard polyline.corners.isEmpty == false else { return }
        self.cgContext.saveGState()
        self.cgContext.beginPath()
        self.cgContext.move(to: polyline.corners[0].cgPoint)
        for point in polyline.corners[1 ..< polyline.corners.endIndex] {
            self.cgContext.addLine(to: point.cgPoint)
        }
        self.cgContext.closePath()
        if self.cgContext.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self.cgContext.restoreGState()
    }
    
    func draw(
        polygon: Polygon2,
        mode: DrawMode
    ) {
        guard polygon.countours.isEmpty == false else { return }
        self.cgContext.saveGState()
        self.cgContext.beginPath()
        for countour in polygon.countours {
            guard countour.corners.isEmpty == false else { continue }
            self.cgContext.move(to: countour.corners[0].cgPoint)
            for point in countour.corners[1 ..< countour.corners.endIndex] {
                self.cgContext.addLine(to: point.cgPoint)
            }
            self.cgContext.closePath()
        }
        if self.cgContext.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self.cgContext.restoreGState()
    }
    
    func draw(
        path: Path2,
        mode: DrawMode
    ) {
        guard path.elements.isEmpty == false else { return }
        self.cgContext.saveGState()
        self.cgContext.beginPath()
        for element in path.elements {
            switch element {
            case .move(let to): self.cgContext.move(to: to.cgPoint)
            case .line(let to): self.cgContext.addLine(to: to.cgPoint)
            case .quad(let to, let control): self.cgContext.addQuadCurve(to: to.cgPoint, control: control.cgPoint)
            case .cubic(let to, let control1, let control2): self.cgContext.addCurve(to: to.cgPoint, control1: control1.cgPoint, control2: control2.cgPoint)
            case .close: self.cgContext.closePath()
            }
        }
        if self.cgContext.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self.cgContext.restoreGState()
    }
    
    func draw(
        image: Image,
        positioning: Context.Positioning
    ) {
        guard let cgImage = image.cgImage else { return }
        let w = CGFloat(image.size.width)
        let h = CGFloat(image.size.height)
        let rect: CGRect
        switch positioning {
        case .topLeft:rect = CGRect(x: 0, y: 0, width: w, height: h)
        case .top: rect = CGRect(x: -(w / 2), y: 0, width: w, height: h)
        case .topRight: rect = CGRect( x: w, y: 0, width: w, height: h)
        case .left: rect = CGRect(x: 0, y: -(h / 2), width: w, height: h)
        case .center: rect = CGRect(x: -(w / 2), y: -(h / 2), width: w, height: h)
        case .right: rect = CGRect(x: -w, y: -(h / 2), width: w, height: h)
        case .bottomLeft: rect = CGRect(x: 0, y: -h, width: w, height: h)
        case .bottom: rect = CGRect(x: -(w / 2), y: -h, width: w, height: h)
        case .bottomRight: rect = CGRect(x: -w, y: -h, width: w, height: h)
        }
        self.cgContext.saveGState()
        self.cgContext.scaleBy(x: 1, y: -1)
        self.cgContext.draw(cgImage, in: rect)
        self.cgContext.restoreGState()
    }
    
    func draw(
        text: NSAttributedString,
        rect: Rect
    ) {
        self.cgContext.saveGState()
        text.draw(with: rect.cgRect, options: [ .usesLineFragmentOrigin, .usesFontLeading ], context: nil)
        self.cgContext.restoreGState()
    }

    func clear(
        rect: Rect
    ) {
        self.cgContext.clear(rect.cgRect)
    }
    
}

private extension Context {
    
    @inline(__always)
    func _apply(
        matrix: Matrix3
    ) {
        self.cgContext.concatenate(matrix.cgAffineTransform)
    }
    
    @inline(__always)
    func _apply(
        alpha: Double
    ) {
        self.cgContext.setAlpha(CGFloat(alpha))
    }
    
    @inline(__always)
    func _apply(
        fill: Fill
    ) {
        switch fill {
        case .color(let color):
            self.cgContext.setFillColor(color.cgColor)
        case .pattern(let pattern):
            if let cgPattern = pattern.cgPattern {
                var alpha: CGFloat = 1.0
                if let cs = CGColorSpace(patternBaseSpace: nil) {
                    self.cgContext.setFillColorSpace(cs)
                }
                self.cgContext.setFillPattern(cgPattern, colorComponents: &alpha)
            }
        }
    }
    
    @inline(__always)
    func _apply(
        stroke: Stroke
    ) {
        self.cgContext.setLineWidth(CGFloat(stroke.width))
        self.cgContext.setLineJoin(stroke.join.cgLineJoin)
        if let miterLimit = stroke.join.miterLimit {
            self.cgContext.setMiterLimit(CGFloat(miterLimit))
        }
        self.cgContext.setLineCap(stroke.cap.cgLineCap)
        if let dash = stroke.dash {
            self.cgContext.setLineDash(
                phase: CGFloat(dash.phase),
                lengths: dash.lengths.map({ CGFloat($0) })
            )
        } else {
            self.cgContext.setLineDash(phase: 0, lengths: [])
        }
        switch stroke.fill {
        case .color(let color):
            self.cgContext.setStrokeColor(color.cgColor)
        case .pattern(let pattern):
            if let cgPattern = pattern.cgPattern {
                var alpha: CGFloat = 1.0
                if let cs = CGColorSpace(patternBaseSpace: nil) {
                    self.cgContext.setStrokeColorSpace(cs)
                }
                self.cgContext.setStrokePattern(cgPattern, colorComponents: &alpha)
            }
        }
    }
    
    @inline(__always)
    func _draw(
        mode: DrawMode
    ) {
        if mode.contains([ .fill, .stroke ]) == true {
            self.cgContext.drawPath(using: .fillStroke)
        } else if mode.contains(.fill) == true {
            self.cgContext.drawPath(using: .fill)
        } else if mode.contains(.stroke) == true {
            self.cgContext.drawPath(using: .stroke)
        }
    }
    
}

#endif
