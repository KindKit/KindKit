//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension RateView {
    
    struct Reusable : IReusable {
        
        typealias Owner = RateView
        typealias Content = KKRateView

        static var reuseIdentificator: String {
            return "RateView"
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

final class KKRateView : UIView {
    
    var kkItemSize: Size {
        didSet {
            guard self.kkItemSize != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkItemSpacing: Double {
        didSet {
            guard self.kkItemSpacing != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkRounding: RateView.Rounding {
        didSet {
            guard self.kkRounding != oldValue else { return }
            self._update()
        }
    }
    var kkNumberOfItem: UInt {
        didSet {
            guard self.kkNumberOfItem != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkStates: [RateView.State] {
        didSet {
            self._update()
        }
    }
    var kkRating: Double {
        didSet {
            guard self.kkRating != oldValue else { return }
            self._update()
        }
    }
    var kkLayers: [CALayer]
    
    override init(frame: CGRect) {
        self.kkItemSize = .zero
        self.kkItemSpacing = 0
        self.kkNumberOfItem = 0
        self.kkRounding = .down
        self.kkStates = []
        self.kkRating = 0
        self.kkLayers = []
        
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self._layout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self._layout(rebuild: true)
        self._update()
    }
    
}

extension KKRateView {
    
    func update(view: RateView) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(itemSize: view.itemSize)
        self.update(itemSpacing: view.itemSpacing)
        self.update(numberOfItem: view.numberOfItem)
        self.update(rounding: view.rounding)
        self.update(states: view.states)
        self.update(rating: view.rating)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(itemSize: Size) {
        self.kkItemSize = itemSize
    }
    
    func update(itemSpacing: Double) {
        self.kkItemSpacing = itemSpacing
    }
    
    func update(numberOfItem: UInt) {
        self.kkNumberOfItem = numberOfItem
    }
    
    func update(rounding: RateView.Rounding) {
        self.kkRounding = rounding
    }
    
    func update(states: [RateView.State]) {
        self.kkStates = states
    }
    
    func update(rating: Double) {
        self.kkRating = rating
    }
    
    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

private extension KKRateView {
    
    func _contentSize() -> Size {
        if self.kkNumberOfItem > 1 {
            return Size(
                width: (self.kkItemSize.width * Double(self.kkNumberOfItem)) + (self.kkItemSpacing * Double(self.kkNumberOfItem - 1)),
                height: self.kkItemSize.height
            )
        } else if self.kkNumberOfItem > 0 {
            return self.kkItemSize
        }
        return .zero
    }
    
    func _state(appearedItem: UInt) -> RateView.State? {
        guard let firstState = self.kkStates.first else { return nil }
        guard let lastState = self.kkStates.last else { return nil }
        if self.kkRating <= Double(appearedItem) {
            return firstState
        } else if self.kkRating >= Double(appearedItem + 1) {
            return lastState
        }
        let rate = self.kkRating - self.kkRating.rounded(.towardZero)
        var nearestState: RateView.State?
        switch self.kkRounding {
        case .up:
            for state in self.kkStates.reversed() {
                if state.rate >= rate {
                    nearestState = state
                }
            }
        case .down:
            for state in self.kkStates {
                if state.rate <= rate {
                    nearestState = state
                }
            }
        }
        return nearestState
    }
    
    func _layout(rebuild: Bool = false) {
        if rebuild == true {
            for layer in self.kkLayers {
                layer.removeFromSuperlayer()
            }
            self.kkLayers.removeAll()
        }
        let numberOfItem = Int(self.kkNumberOfItem)
        if self.kkLayers.count > numberOfItem {
            for index in (numberOfItem..<self.kkLayers.count).reversed() {
                let layer = self.kkLayers[index]
                self.kkLayers.remove(at: index)
                layer.removeFromSuperlayer()
            }
        } else if self.kkLayers.count < numberOfItem {
            for _ in self.kkLayers.count..<numberOfItem {
                let layer = CALayer()
                layer.contentsGravity = .resizeAspect
                self.kkLayers.append(layer)
                self.layer.addSublayer(layer)
            }
        }
        let bounds = Rect(self.bounds)
        let boundsCenter = bounds.center
        let contentSize = self._contentSize()
        var origin = Point(
            x: boundsCenter.x - (contentSize.width / 2),
            y: boundsCenter.y - (contentSize.height / 2)
        )
        for (index, layer) in self.kkLayers.enumerated() {
            layer.frame = CGRect(
                x: CGFloat(origin.x),
                y: CGFloat(origin.y),
                width: CGFloat(self.kkItemSize.width),
                height: CGFloat(self.kkItemSize.height)
            )
            if let state = self._state(appearedItem: UInt(index)) {
                self._update(layer: layer, state: state)
            }
            origin.x += self.kkItemSize.width + self.kkItemSpacing
        }
    }
    
    func _update() {
        for (index, layer) in self.kkLayers.enumerated() {
            if let state = self._state(appearedItem: UInt(index)) {
                self._update(layer: layer, state: state)
            }
        }
    }
    
    func _update(layer: CALayer, state: RateView.State) {
        let image: UIImage
        if let imageAsset = state.image.native.imageAsset {
            image = imageAsset.image(with: self.traitCollection)
        } else {
            image = state.image.native
        }
        layer.contents = image.cgImage
    }
    
}

extension KKRateView : ILayoutDelegate {
    
    func setNeedUpdate(_ appearedLayout: ILayout) -> Bool {
        self.setNeedsLayout()
        return true
    }
    
    func updateIfNeeded(_ appearedLayout: ILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
