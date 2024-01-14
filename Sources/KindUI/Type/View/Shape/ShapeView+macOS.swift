//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindMath

extension ShapeView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ShapeView
        typealias Content = KKShapeView

        static var reuseIdentificator: String {
            return "ShapeView"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKShapeView : NSView {
    
    let kkShapeLayer: CAShapeLayer
    
    override init(frame: CGRect) {
        self.kkShapeLayer = CAShapeLayer()
        
        super.init(frame: frame)
        
        self.wantsLayer = true
        self.layer!.addSublayer(self.kkShapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }

    override func layout() {
        super.layout()
        
        let bounds = self.bounds
        if let path = self.kkShapeLayer.path {
            let shapeSize = path.boundingBoxOfPath.size
            self.kkShapeLayer.frame = CGRect(
                origin: CGPoint(
                    x: bounds.midX - (shapeSize.width / 2),
                    y: bounds.midY - (shapeSize.height / 2)
                ),
                size: shapeSize
            )
        } else {
            self.kkShapeLayer.frame = bounds
        }
    }
    
}

extension KKShapeView {
    
    func update(view: ShapeView) {
        self.update(frame: view.frame)
        self.update(path: view.path)
        self.update(fill: view.fill)
        self.update(stroke: view.stroke)
        self.update(line: view.line)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(path: Path2?) {
        CATransaction.kk_withoutActions({
            self.kkShapeLayer.path = path?.cgPath
            self.needsLayout = true
        })
    }
    
    func update(fill: ShapeView.Fill?) {
        CATransaction.kk_withoutActions({
            if let fill = fill {
                self.kkShapeLayer.fillColor = fill.color.cgColor
                switch fill.rule {
                case .nonZero: self.kkShapeLayer.fillRule = .nonZero
                case .evenOdd: self.kkShapeLayer.fillRule = .evenOdd
                }
            } else {
                self.kkShapeLayer.fillColor = nil
                self.kkShapeLayer.fillRule = .nonZero
            }
        })
    }
    
    func update(stroke: ShapeView.Stroke?) {
        CATransaction.kk_withoutActions({
            if let stroke = stroke {
                self.kkShapeLayer.strokeColor = stroke.color.cgColor
                self.kkShapeLayer.strokeStart = CGFloat(stroke.start)
                self.kkShapeLayer.strokeEnd = CGFloat(stroke.end)
            } else {
                self.kkShapeLayer.strokeColor = nil
                self.kkShapeLayer.strokeStart = 0
                self.kkShapeLayer.strokeEnd = 1
            }
        })
    }
    
    func update(line: ShapeView.Line) {
        CATransaction.kk_withoutActions({
            self.kkShapeLayer.lineWidth = CGFloat(line.width)
            switch line.cap {
            case .butt: self.kkShapeLayer.lineCap = .butt
            case .square: self.kkShapeLayer.lineCap = .square
            case .round: self.kkShapeLayer.lineCap = .round
            }
            switch line.join {
            case .miter(let limit):
                self.kkShapeLayer.lineJoin = .miter
                self.kkShapeLayer.miterLimit = CGFloat(limit)
            case .bevel: self.kkShapeLayer.lineJoin = .bevel
            case .round: self.kkShapeLayer.lineJoin = .round
            }
            if let dash = line.dash {
                self.kkShapeLayer.lineDashPhase = dash.phase
                self.kkShapeLayer.lineDashPattern = dash.lengths.map(NSNumber.init(value:))
            } else {
                self.kkShapeLayer.lineDashPhase = 0
                self.kkShapeLayer.lineDashPattern = nil
            }
        })
    }
    
    func update(color: Color?) {
        self.layer!.backgroundColor = color?.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
