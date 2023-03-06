//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Shape {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Shape
        typealias Content = KKShapeView

        static var reuseIdentificator: String {
            return "UI.View.Shape"
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

final class KKShapeView : UIView {
    
    let _shapeLayer: CAShapeLayer
    
    override init(frame: CGRect) {
        self._shapeLayer = CAShapeLayer()
        
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        
        self.layer.addSublayer(self._shapeLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        if let path = self._shapeLayer.path {
            let shapeSize = path.boundingBoxOfPath.size
            self._shapeLayer.frame = CGRect(
                origin: CGPoint(
                    x: bounds.midX - (shapeSize.width / 2),
                    y: bounds.midY - (shapeSize.height / 2)
                ),
                size: shapeSize
            )
        } else {
            self._shapeLayer.frame = bounds
        }
    }
    
}

extension KKShapeView {
    
    func update(view: UI.View.Shape) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
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
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(path: Path2?) {
        CATransaction.kk_withoutActions({
            self._shapeLayer.path = path?.cgPath
            self.setNeedsLayout()
        })
    }
    
    func update(fill: UI.View.Shape.Fill?) {
        CATransaction.kk_withoutActions({
            if let fill = fill {
                self._shapeLayer.fillColor = fill.color.cgColor
                switch fill.rule {
                case .nonZero: self._shapeLayer.fillRule = .nonZero
                case .evenOdd: self._shapeLayer.fillRule = .evenOdd
                }
            } else {
                self._shapeLayer.fillColor = nil
                self._shapeLayer.fillRule = .nonZero
            }
        })
    }
    
    func update(stroke: UI.View.Shape.Stroke?) {
        CATransaction.kk_withoutActions({
            if let stroke = stroke {
                self._shapeLayer.strokeColor = stroke.color.cgColor
                self._shapeLayer.strokeStart = CGFloat(stroke.start)
                self._shapeLayer.strokeEnd = CGFloat(stroke.end)
            } else {
                self._shapeLayer.strokeColor = nil
                self._shapeLayer.strokeStart = 0
                self._shapeLayer.strokeEnd = 1
            }
        })
    }
    
    func update(line: UI.View.Shape.Line) {
        CATransaction.kk_withoutActions({
            self._shapeLayer.lineWidth = CGFloat(line.width)
            switch line.cap {
            case .butt: self._shapeLayer.lineCap = .butt
            case .square: self._shapeLayer.lineCap = .square
            case .round: self._shapeLayer.lineCap = .round
            }
            switch line.join {
            case .miter(let limit):
                self._shapeLayer.lineJoin = .miter
                self._shapeLayer.miterLimit = CGFloat(limit)
            case .bevel: self._shapeLayer.lineJoin = .bevel
            case .round: self._shapeLayer.lineJoin = .round
            }
            if let dash = line.dash {
                self._shapeLayer.lineDashPhase = dash.phase
                self._shapeLayer.lineDashPattern = dash.lengths.map(NSNumber.init(value:))
            } else {
                self._shapeLayer.lineDashPhase = 0
                self._shapeLayer.lineDashPattern = nil
            }
        })
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
