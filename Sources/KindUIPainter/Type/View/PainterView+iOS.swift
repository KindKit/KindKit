//
//  KindKit
//

#if os(iOS)

import UIKit
import KindUI

extension PainterView {
    
    struct Reusable : IReusable {
        
        typealias Owner = PainterView
        typealias Content = KKPainterView
        
        static func name(owner: Owner) -> String {
            return "PainterView"
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

final class KKPainterView : UIView {
    
    var kkDelegate: KKPainterViewDelegate?
    var kkTapGestures: [Gesture : UITapGestureRecognizer] = [:]
    var kkLongPressGestures: [Gesture : UILongPressGestureRecognizer] = [:]
    var kkPanGestures: [Gesture : UIPanGestureRecognizer] = [:]
    var kkPreviousPanLocation: [Gesture : CGPoint] = [:]
    var kkPinchGesture: UIPinchGestureRecognizer!
    var kkPreviousPinchLocation: CGPoint?
    var kkPreviousPinchScale: CGFloat?
    var kkRotationGesture: UIRotationGestureRecognizer!
    var kkPreviousRotationLocation: CGPoint?
    var kkPreviousRotationAngle: CGFloat?
    var kkSimultaneouslyGestures: [UIGestureRecognizer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        for canvasGesture in Gesture.allCases {
            let numberOfTouches = canvasGesture.numberOfTouches
            do {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self._handleTapGesture(_:)))
                gesture.numberOfTouchesRequired = numberOfTouches
                self.kkTapGestures[canvasGesture] = gesture
                self.addGestureRecognizer(gesture)
            }
            do {
                let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self._handleLongPressGesture(_:)))
                gesture.numberOfTouchesRequired = numberOfTouches
                self.kkLongPressGestures[canvasGesture] = gesture
                self.addGestureRecognizer(gesture)
            }
            do {
                let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handlePanGesture(_:)))
                gesture.minimumNumberOfTouches = numberOfTouches
                gesture.maximumNumberOfTouches = numberOfTouches
                self.kkPanGestures[canvasGesture] = gesture
                self.addGestureRecognizer(gesture)
                self.kkSimultaneouslyGestures.append(gesture)
            }
        }
        
        self.kkPinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self._handlePinchGesture))
        self.addGestureRecognizer(self.kkPinchGesture)
        self.kkSimultaneouslyGestures.append(self.kkPinchGesture)
        
        self.kkRotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(self._handleRotationGesture))
        self.addGestureRecognizer(self.kkRotationGesture)
        self.kkSimultaneouslyGestures.append(self.kkRotationGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let delegate = self.kkDelegate else { return }
        guard let cgContext = UIGraphicsGetCurrentContext() else { return }
        delegate.kk_draw(.init(cgContext, size: self.bounds.size))
    }

}

extension KKPainterView {
    
    final func kk_update(view: PainterView) {
        self.kk_update(frame: view.frame)
        self.kk_update(enabled: view.isEnabled)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    final func kk_cleanup(view: PainterView) {
        self.kkDelegate = nil
    }
    
}

extension KKPainterView {
    
    final func kk_update(enabled: Bool) {
        self.isUserInteractionEnabled = enabled
    }
    
    final func kk_update(color: Color) {
        self.backgroundColor = color.native
    }
    
    final func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
}

private extension KKPainterView {
    
    @objc
    func _handleTapGesture(_ gesture: UIGestureRecognizer) {
        guard let delegate = self.kkDelegate else { return }
        guard let found = self.kkTapGestures.first(where: { $0.value === gesture }) else { return }
        delegate.kk_handle(event: .tap(
            gesture: found.key,
            location: .init(found.value.location(in: self))
        ))
    }
    
    @objc
    func _handleLongPressGesture(_ gesture: UIGestureRecognizer) {
        guard let delegate = self.kkDelegate else { return }
        guard let found = self.kkLongPressGestures.first(where: { $0.value === gesture }) else { return }
        delegate.kk_handle(event: .longTap(
            gesture: found.key,
            location: .init(found.value.location(in: self))
        ))
    }
    
    @objc
    func _handlePanGesture(_ gesture: UIGestureRecognizer) {
        guard let delegate = self.kkDelegate else { return }
        guard let found = self.kkPanGestures.first(where: { $0.value === gesture }) else { return }
        switch found.value.state {
        case .possible: 
            break
        case .began:
            let location = found.value.location(in: self)
            self.kkPreviousPanLocation[found.key] = location
            delegate.kk_handle(event: .pan(
                gesture: found.key,
                state: .begin,
                location: .init(location)
            ))
        case .changed:
            if found.value.numberOfTouches != found.value.minimumNumberOfTouches {
                found.value.isEnabled = false
            } else {
                let location = found.value.location(in: self)
                self.kkPreviousPanLocation[found.key] = location
                delegate.kk_handle(event: .pan(
                    gesture: found.key,
                    state: .change,
                    location: .init(location)
                ))
            }
        case .ended, .cancelled, .failed:
            if let location = self.kkPreviousPanLocation[found.key] {
                self.kkPreviousPanLocation[found.key] = nil
                delegate.kk_handle(event: .pan(
                    gesture: found.key,
                    state: .end,
                    location: .init(location)
                ))
            }
            found.value.isEnabled = true
        @unknown default: break
        }
    }
    
    @objc
    func _handlePinchGesture() {
        guard let delegate = self.kkDelegate else { return }
        switch self.kkPinchGesture.state {
        case .possible: break
        case .began:
            let location = self.kkPinchGesture.location(in: self)
            let scale = self.kkPinchGesture.scale
            self.kkPreviousPinchLocation = location
            self.kkPreviousPinchScale = scale
            delegate.kk_handle(event: .pinch(
                state: .begin,
                location: .init(location),
                scale: .init(scale)
            ))
        case .changed:
            if self.kkPinchGesture.numberOfTouches != 2 {
                self.kkPinchGesture.isEnabled = false
            } else {
                let location = self.kkPinchGesture.location(in: self)
                let scale = self.kkPinchGesture.scale
                self.kkPreviousPinchLocation = location
                self.kkPreviousPinchScale = scale
                delegate.kk_handle(event: .pinch(
                    state: .change,
                    location: .init(location),
                    scale: .init(scale)
                ))
            }
        case .ended, .cancelled, .failed:
            if let location = self.kkPreviousPinchLocation, let scale = self.kkPreviousPinchScale {
                self.kkPreviousPinchLocation = nil
                self.kkPreviousPinchScale = nil
                delegate.kk_handle(event: .pinch(
                    state: .end,
                    location: .init(location),
                    scale: .init(scale)
                ))
            }
            self.kkPinchGesture.isEnabled = true
        @unknown default: break
        }
    }
    
    @objc
    func _handleRotationGesture() {
        guard let delegate = self.kkDelegate else { return }
        switch self.kkRotationGesture.state {
        case .possible: break
        case .began:
            let location = self.kkRotationGesture.location(in: self)
            let angle = self.kkRotationGesture.rotation
            self.kkPreviousRotationLocation = location
            self.kkPreviousRotationAngle = angle
            delegate.kk_handle(event: .rotation(
                state: .begin,
                location: .init(location),
                angle: .init(radians: .init(angle))
            ))
        case .changed:
            if self.kkRotationGesture.numberOfTouches != 2 {
                self.kkRotationGesture.isEnabled = false
            } else {
                let location = self.kkRotationGesture.location(in: self)
                let angle = self.kkRotationGesture.rotation
                self.kkPreviousRotationLocation = location
                self.kkPreviousRotationAngle = angle
                delegate.kk_handle(event: .rotation(
                    state: .change,
                    location: .init(location),
                    angle: .init(radians: .init(angle))
                ))
            }
        case .ended, .cancelled, .failed:
            if let location = self.kkPreviousRotationLocation, let angle = self.kkPreviousRotationAngle {
                self.kkPreviousRotationLocation = nil
                self.kkPreviousRotationAngle = nil
                delegate.kk_handle(event: .rotation(
                    state: .end,
                    location: .init(location),
                    angle: .init(radians: .init(angle))
                ))
            }
            self.kkRotationGesture.isEnabled = true
        @unknown default: break
        }
    }
    
}

extension KKPainterView : UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let delegate = self.kkDelegate else { return false }
        if let found = self.kkTapGestures.first(where: { $0.value === gestureRecognizer }) {
            return delegate.kk_should(event: .tap(gesture: found.key))
        } else if let found = self.kkLongPressGestures.first(where: { $0.value === gestureRecognizer }) {
            return delegate.kk_should(event: .longTap(gesture: found.key))
        } else if let found = self.kkPanGestures.first(where: { $0.value === gestureRecognizer }) {
            return delegate.kk_should(event: .pan(gesture: found.key))
        } else if gestureRecognizer === self.kkPinchGesture {
            return delegate.kk_should(event: .pinch)
        } else if gestureRecognizer === self.kkRotationGesture {
            return delegate.kk_should(event: .rotation)
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard self.kkSimultaneouslyGestures.contains(gestureRecognizer) == true else { return false }
        guard self.kkSimultaneouslyGestures.contains(otherGestureRecognizer) == true else { return false }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.kkTapGestures.first(where: { $0.value === gestureRecognizer }) != nil {
            if self.kkLongPressGestures.first(where: { $0.value === otherGestureRecognizer }) != nil {
                return true
            }
        }
        return false
    }
    
}

#endif
