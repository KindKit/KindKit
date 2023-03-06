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
        
        private let _instance: CGContext
        
        init(_ instance: CGContext) {
            self._instance = instance
        }
        
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
        self._instance.saveGState()
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
        self._instance.restoreGState()
    }
    
    func apply(
        fill: Graphics.Fill? = nil,
        stroke: Graphics.Stroke? = nil,
        block: () -> Void
    ) {
        self._instance.saveGState()
        if let fill = fill {
            self._apply(fill: fill)
        }
        if let stroke = stroke {
            self._apply(stroke: stroke)
        }
        block()
        self._instance.restoreGState()
    }
    
    func draw(
        circle: Circle,
        mode: Graphics.DrawMode
    ) {
        self._instance.saveGState()
        self._instance.beginPath()
        self._instance.addEllipse(in: CGRect(
            x: CGFloat(circle.origin.x - circle.radius),
            y: CGFloat(circle.origin.y - circle.radius),
            width: CGFloat(circle.radius * 2),
            height: CGFloat(circle.radius * 2)
        ))
        self._draw(mode: mode)
        self._instance.restoreGState()
    }
    
    func draw(
        circles: [Circle],
        mode: Graphics.DrawMode
    ) {
        guard circles.isEmpty == false else { return }
        self._instance.saveGState()
        self._instance.beginPath()
        for index in circles.indices {
            let circle = circles[index]
            self._instance.addEllipse(in: CGRect(
                x: CGFloat(circle.origin.x - circle.radius),
                y: CGFloat(circle.origin.y - circle.radius),
                width: CGFloat(circle.radius * 2),
                height: CGFloat(circle.radius * 2)
            ))
        }
        if self._instance.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self._instance.restoreGState()
    }
    
    func draw(
        segment: Segment2
    ) {
        self._instance.saveGState()
        self._instance.beginPath()
        self._instance.move(to: segment.start.cgPoint)
        self._instance.addLine(to: segment.end.cgPoint)
        self._instance.drawPath(using: .stroke)
        self._instance.restoreGState()
    }
    
    func draw(
        segments: [Segment2]
    ) {
        guard segments.isEmpty == false else { return }
        self._instance.saveGState()
        self._instance.beginPath()
        for segment in segments {
            self._instance.move(to: segment.start.cgPoint)
            self._instance.addLine(to: segment.end.cgPoint)
        }
        self._instance.drawPath(using: .stroke)
        self._instance.restoreGState()
    }
    
    func draw(
        polyline: Polyline2,
        mode: Graphics.DrawMode
    ) {
        guard polyline.corners.isEmpty == false else { return }
        self._instance.saveGState()
        self._instance.beginPath()
        self._instance.move(to: polyline.corners[0].cgPoint)
        for point in polyline.corners[1 ..< polyline.corners.endIndex] {
            self._instance.addLine(to: point.cgPoint)
        }
        self._instance.closePath()
        if self._instance.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self._instance.restoreGState()
    }
    
    func draw(
        polygon: Polygon2,
        mode: Graphics.DrawMode
    ) {
        guard polygon.countours.isEmpty == false else { return }
        self._instance.saveGState()
        self._instance.beginPath()
        for countour in polygon.countours {
            guard countour.corners.isEmpty == false else { continue }
            self._instance.move(to: countour.corners[0].cgPoint)
            for point in countour.corners[1 ..< countour.corners.endIndex] {
                self._instance.addLine(to: point.cgPoint)
            }
            self._instance.closePath()
        }
        if self._instance.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self._instance.restoreGState()
    }
    
    func draw(
        path: Path2,
        mode: Graphics.DrawMode
    ) {
        guard path.elements.isEmpty == false else { return }
        self._instance.saveGState()
        self._instance.beginPath()
        for element in path.elements {
            switch element {
            case .move(let to): self._instance.move(to: to.cgPoint)
            case .line(let to): self._instance.addLine(to: to.cgPoint)
            case .quad(let to, let control): self._instance.addQuadCurve(to: to.cgPoint, control: control.cgPoint)
            case .cubic(let to, let control1, let control2): self._instance.addCurve(to: to.cgPoint, control1: control1.cgPoint, control2: control2.cgPoint)
            case .close: self._instance.closePath()
            }
        }
        if self._instance.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self._instance.restoreGState()
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
        self._instance.saveGState()
        self._instance.scaleBy(x: 1, y: -1)
        self._instance.draw(cgImage, in: rect)
        self._instance.restoreGState()
    }
    
    func draw(
        text: NSAttributedString,
        rect: Rect
    ) {
        self._instance.saveGState()
        text.draw(with: rect.cgRect, options: [ .usesLineFragmentOrigin, .usesFontLeading ], context: nil)
        self._instance.restoreGState()
    }

    func clear(
        rect: Rect
    ) {
        self._instance.clear(rect.cgRect)
    }
    
}

private extension Graphics.Context {
    
    @inline(__always)
    func _apply(
        matrix: Matrix3
    ) {
        self._instance.concatenate(matrix.cgAffineTransform)
    }
    
    @inline(__always)
    func _apply(
        alpha: Double
    ) {
        self._instance.setAlpha(CGFloat(alpha))
    }
    
    @inline(__always)
    func _apply(
        fill: Graphics.Fill
    ) {
        switch fill {
        case .color(let color):
            self._instance.setFillColor(color.cgColor)
        case .pattern(let pattern):
            if let cgPattern = pattern.cgPattern {
                var alpha: CGFloat = 1.0
                if let cs = CGColorSpace(patternBaseSpace: nil) {
                    self._instance.setFillColorSpace(cs)
                }
                self._instance.setFillPattern(cgPattern, colorComponents: &alpha)
            }
        }
    }
    
    @inline(__always)
    func _apply(
        stroke: Graphics.Stroke
    ) {
        self._instance.setLineWidth(CGFloat(stroke.width))
        self._instance.setLineJoin(stroke.join.cgLineJoin)
        if let miterLimit = stroke.join.miterLimit {
            self._instance.setMiterLimit(CGFloat(miterLimit))
        }
        self._instance.setLineCap(stroke.cap.cgLineCap)
        if let dash = stroke.dash {
            self._instance.setLineDash(
                phase: CGFloat(dash.phase),
                lengths: dash.lengths.map({ CGFloat($0) })
            )
        } else {
            self._instance.setLineDash(phase: 0, lengths: [])
        }
        switch stroke.fill {
        case .color(let color):
            self._instance.setStrokeColor(color.cgColor)
        case .pattern(let pattern):
            if let cgPattern = pattern.cgPattern {
                var alpha: CGFloat = 1.0
                if let cs = CGColorSpace(patternBaseSpace: nil) {
                    self._instance.setStrokeColorSpace(cs)
                }
                self._instance.setStrokePattern(cgPattern, colorComponents: &alpha)
            }
        }
    }
    
    @inline(__always)
    func _draw(
        mode: Graphics.DrawMode
    ) {
        if mode.contains([ .fill, .stroke ]) == true {
            self._instance.drawPath(using: .fillStroke)
        } else if mode.contains(.fill) == true {
            self._instance.drawPath(using: .fill)
        } else if mode.contains(.stroke) == true {
            self._instance.drawPath(using: .stroke)
        }
    }
    
}

#endif
