//
//  KindKitGraphics
//

#if canImport(CoreGraphics)

import UIKit
import CoreGraphics
import KindKitCore
import KindKitMath
import KindKitView

public struct GraphicsContext {
    
    private let _instance: CGContext
    
    init(_ instance: CGContext) {
        self._instance = instance
    }
    
}

public extension GraphicsContext {
    
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

public extension GraphicsContext {
    
    func apply< Value : IScalar >(
        matrix: Matrix3< Value >? = nil,
        alpha: Value? = nil,
        fill: GraphicsFill? = nil,
        stroke: GraphicsStroke? = nil,
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
        fill: GraphicsFill? = nil,
        stroke: GraphicsStroke? = nil,
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
    
    func draw< Value : IScalar >(
        circle: Circle< Value >,
        mode: GraphicsDrawMode
    ) {
        self._instance.saveGState()
        self._instance.beginPath()
        self._instance.addEllipse(in: CGRect(
            x: (circle.origin.x - circle.radius).cgFloat,
            y: (circle.origin.y - circle.radius).cgFloat,
            width: (circle.radius * 2).cgFloat,
            height: (circle.radius * 2).cgFloat
        ))
        self._draw(mode: mode)
        self._instance.restoreGState()
    }
    
    func draw< Value : IScalar >(
        circles: [Circle< Value >],
        mode: GraphicsDrawMode
    ) {
        guard circles.isEmpty == false else { return }
        self._instance.saveGState()
        self._instance.beginPath()
        for index in circles.indices {
            let circle = circles[index]
            self._instance.addEllipse(in: CGRect(
                x: (circle.origin.x - circle.radius).cgFloat,
                y: (circle.origin.y - circle.radius).cgFloat,
                width: (circle.radius * 2).cgFloat,
                height: (circle.radius * 2).cgFloat
            ))
        }
        if self._instance.isPathEmpty == false {
            self._draw(mode: mode)
        }
        self._instance.restoreGState()
    }
    
    func draw< Value : IScalar >(
        segment: Segment2< Value >
    ) {
        self._instance.saveGState()
        self._instance.beginPath()
        self._instance.move(to: segment.start.cgPoint)
        self._instance.addLine(to: segment.end.cgPoint)
        self._instance.drawPath(using: .stroke)
        self._instance.restoreGState()
    }
    
    func draw< Value : IScalar >(
        segments: [Segment2< Value >]
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
    
    func draw< Value : IScalar >(
        polyline: Polyline2< Value >,
        mode: GraphicsDrawMode
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
    
    func draw< Value : IScalar >(
        polygon: Polygon2< Value >,
        mode: GraphicsDrawMode
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
    
    func draw< Value : IScalar >(
        path: Path2< Value >,
        mode: GraphicsDrawMode
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
        image: Image,
        positioning: GraphicsContext.Positioning
    ) {
        guard let cgImage = image.native.cgImage else { return }
        let w = image.size.width.cgFloat
        let h = image.size.height.cgFloat
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
    
    func draw< Value : IScalar >(
        text: NSAttributedString,
        rect: Rect< Value >
    ) {
        self._instance.saveGState()
        text.draw(with: rect.cgRect, options: [ .usesLineFragmentOrigin, .usesFontLeading ], context: nil)
        self._instance.restoreGState()
    }

    func clear< Value : IScalar >(
        rect: Rect< Value >
    ) {
        self._instance.clear(rect.cgRect)
    }
    
}

private extension GraphicsContext {
    
    @inline(__always)
    func _apply< Value : IScalar >(
        matrix: Matrix3< Value >
    ) {
        self._instance.concatenate(matrix.cgAffineTransform)
    }
    
    @inline(__always)
    func _apply< Value : IScalar >(
        alpha: Value
    ) {
        self._instance.setAlpha(alpha.cgFloat)
    }
    
    @inline(__always)
    func _apply(
        fill: GraphicsFill
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
        stroke: GraphicsStroke
    ) {
        self._instance.setLineWidth(stroke.width.cgFloat)
        self._instance.setLineJoin(stroke.join.cgLineJoin)
        self._instance.setLineCap(stroke.cap.cgLineCap)
        if let dash = stroke.dash {
            self._instance.setLineDash(
                phase: dash.phase.cgFloat,
                lengths: dash.lengths.compactMap({ $0.cgFloat })
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
        mode: GraphicsDrawMode
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
