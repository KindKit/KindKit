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
        
        static func name(owner: Owner) -> String {
            return "ShapeView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
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
        
        self.kkShapeLayer.frame = self.bounds
    }
    
}

extension KKShapeView {
    
    func kk_update(view: ShapeView) {
        self.kk_update(frame: view.frame)
        self.kk_update(path: view.path)
        self.kk_update(fill: view.fill)
        self.kk_update(stroke: view.stroke)
        self.kk_update(line: view.line)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
    }
    
    func kk_cleanup(view: ShapeView) {
    }
    
}

extension KKShapeView {
    
    func kk_update(path: Path2?) {
        CATransaction.kk_withoutActions({
            self.kkShapeLayer.path = path?.cgPath
            self.needsLayout = true
        })
    }
    
    func kk_update(fill: ShapeView.Fill?) {
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
    
    func kk_update(stroke: ShapeView.Stroke?) {
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
    
    func kk_update(line: ShapeView.Line) {
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
    
    func kk_update(color: Color) {
        self.layer!.backgroundColor = color.cgColor
    }
    
    func kk_update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
}

#endif
