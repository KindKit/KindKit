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

public extension Graphics {
    
    struct Context {
        
        public let native: CGContext
        public var size: Size
        
        init(_ native: CGContext, size: CGSize) {
            self.native = native
            self.size = .init(size)
        }
        
    }
    
}

public extension Graphics.Context {
    
    @inlinable
    var bbox: AlignedBox2 {
        return .init(lower: .zero, upper: .init(self.size))
    }
    
}

public extension Graphics.Context {
    
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

public extension Graphics.Context {
    
    func apply(
        matrix: Matrix3? = nil,
        alpha: Double? = nil,
        fill: Graphics.Fill? = nil,
        stroke: Graphics.Stroke? = nil,
        block: () -> Void
    ) {
        self.native.saveGState()
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
        self.native.restoreGState()
    }
    
    func apply(
        fill: Graphics.Fill? = nil,
        stroke: Graphics.Stroke? = nil,
        block: () -> Void
    ) {
        self.native.saveGState()
        if let fill = fill {
            self._apply(fill: fill)
        }
        if let stroke = stroke {
            self._apply(stroke: stroke)
        }
        block()
        self.native.restoreGState()
    }
    
    func draw(
        circle: Circle,
        mode: Graphics.DrawMode
    ) {
        self.native.saveGState()
        self.native.beginPath()
        self.native.addEllipse(in: CGRect(
            x: CGFloat(circle.origin.x - circle.radius.value),
            y: CGFloat(circle.origin.y - circle.radius.value),
            width: CGFloat(circle.radius.value * 2),
            height: CGFloat(circle.radius.value * 2)
        ))
        self._draw(mode: mode)
        self.native.restoreGState()
    }
    
    func draw(
        circles: [Circle],
        mode: Graphics.DrawMode
    ) {
        guard circles.isEmpty == false else { return }
        self.native.saveGState()
        self.native.beginPath()
        for index in circles.indices {
            let circle = circles[index]
            self.native.addEllipse(in: CGRect(
                x: CGFloat(circle.origin.x - circle.radius.value),
                y: CGFloat(circle.origin.y - circle.radius.value),
                width: CGFloat(circle.radius.value * 2),
                height: CGFloat(circle.radius.value * 2)
            ))
        }
        if self.native.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self.native.restoreGState()
    }
    
    func draw(
        segment: Segment2
    ) {
        self.native.saveGState()
        self.native.beginPath()
        self.native.move(to: segment.start.cgPoint)
        self.native.addLine(to: segment.end.cgPoint)
        self.native.drawPath(using: .stroke)
        self.native.restoreGState()
    }
    
    func draw(
        segments: [Segment2]
    ) {
        guard segments.isEmpty == false else { return }
        self.native.saveGState()
        self.native.beginPath()
        for segment in segments {
            self.native.move(to: segment.start.cgPoint)
            self.native.addLine(to: segment.end.cgPoint)
        }
        self.native.drawPath(using: .stroke)
        self.native.restoreGState()
    }
    
    func draw(
        polyline: Polyline2,
        mode: Graphics.DrawMode
    ) {
        guard polyline.corners.isEmpty == false else { return }
        self.native.saveGState()
        self.native.beginPath()
        self.native.move(to: polyline.corners[0].cgPoint)
        for point in polyline.corners[1 ..< polyline.corners.endIndex] {
            self.native.addLine(to: point.cgPoint)
        }
        self.native.closePath()
        if self.native.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self.native.restoreGState()
    }
    
    func draw(
        polygon: Polygon2,
        mode: Graphics.DrawMode
    ) {
        guard polygon.countours.isEmpty == false else { return }
        self.native.saveGState()
        self.native.beginPath()
        for countour in polygon.countours {
            guard countour.corners.isEmpty == false else { continue }
            self.native.move(to: countour.corners[0].cgPoint)
            for point in countour.corners[1 ..< countour.corners.endIndex] {
                self.native.addLine(to: point.cgPoint)
            }
            self.native.closePath()
        }
        if self.native.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self.native.restoreGState()
    }
    
    func draw(
        path: Path2,
        mode: Graphics.DrawMode
    ) {
        guard path.elements.isEmpty == false else { return }
        self.native.saveGState()
        self.native.beginPath()
        for element in path.elements {
            switch element {
            case .move(let to): self.native.move(to: to.cgPoint)
            case .line(let to): self.native.addLine(to: to.cgPoint)
            case .quad(let to, let control): self.native.addQuadCurve(to: to.cgPoint, control: control.cgPoint)
            case .cubic(let to, let control1, let control2): self.native.addCurve(to: to.cgPoint, control1: control1.cgPoint, control2: control2.cgPoint)
            case .close: self.native.closePath()
            }
        }
        if self.native.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self.native.restoreGState()
    }
    
    func draw(
        image: UI.Image,
        positioning: Graphics.Context.Positioning
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
        self.native.saveGState()
        self.native.scaleBy(x: 1, y: -1)
        self.native.draw(cgImage, in: rect)
        self.native.restoreGState()
    }
    
    func draw(
        text: NSAttributedString,
        rect: Rect
    ) {
        self.native.saveGState()
        text.draw(with: rect.cgRect, options: [ .usesLineFragmentOrigin, .usesFontLeading ], context: nil)
        self.native.restoreGState()
    }

    func clear(
        rect: Rect
    ) {
        self.native.clear(rect.cgRect)
    }
    
}

private extension Graphics.Context {
    
    @inline(__always)
    func _apply(
        matrix: Matrix3
    ) {
        self.native.concatenate(matrix.cgAffineTransform)
    }
    
    @inline(__always)
    func _apply(
        alpha: Double
    ) {
        self.native.setAlpha(CGFloat(alpha))
    }
    
    @inline(__always)
    func _apply(
        fill: Graphics.Fill
    ) {
        switch fill {
        case .color(let color):
            self.native.setFillColor(color.cgColor)
        case .pattern(let pattern):
            if let cgPattern = pattern.cgPattern {
                var alpha: CGFloat = 1.0
                if let cs = CGColorSpace(patternBaseSpace: nil) {
                    self.native.setFillColorSpace(cs)
                }
                self.native.setFillPattern(cgPattern, colorComponents: &alpha)
            }
        }
    }
    
    @inline(__always)
    func _apply(
        stroke: Graphics.Stroke
    ) {
        self.native.setLineWidth(CGFloat(stroke.width))
        self.native.setLineJoin(stroke.join.cgLineJoin)
        if let miterLimit = stroke.join.miterLimit {
            self.native.setMiterLimit(CGFloat(miterLimit))
        }
        self.native.setLineCap(stroke.cap.cgLineCap)
        if let dash = stroke.dash {
            self.native.setLineDash(
                phase: CGFloat(dash.phase),
                lengths: dash.lengths.map({ CGFloat($0) })
            )
        } else {
            self.native.setLineDash(phase: 0, lengths: [])
        }
        switch stroke.fill {
        case .color(let color):
            self.native.setStrokeColor(color.cgColor)
        case .pattern(let pattern):
            if let cgPattern = pattern.cgPattern {
                var alpha: CGFloat = 1.0
                if let cs = CGColorSpace(patternBaseSpace: nil) {
                    self.native.setStrokeColorSpace(cs)
                }
                self.native.setStrokePattern(cgPattern, colorComponents: &alpha)
            }
        }
    }
    
    @inline(__always)
    func _draw(
        mode: Graphics.DrawMode
    ) {
        if mode.contains([ .fill, .stroke ]) == true {
            self.native.drawPath(using: .fillStroke)
        } else if mode.contains(.fill) == true {
            self.native.drawPath(using: .fill)
        } else if mode.contains(.stroke) == true {
            self.native.drawPath(using: .stroke)
        }
    }
    
}

#endif
