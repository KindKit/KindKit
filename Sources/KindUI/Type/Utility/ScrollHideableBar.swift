//
//  KindKit
//

import Foundation
import KindAnimation
import KindEvent
import KindLayout
import KindTime
import KindMonadicMacro

@KindMonadic
public final class ScrollHideableBar< LayoutType : ILayout > {
    
    @KindMonadicProperty
    public var direction: Direction = .vertical
    
    public var visibility: Percent {
        switch self.state {
        case .show: return .one
        case .hide: return .zero
        case .hiding(let progress): return progress.invert
        }
    }
    
    @KindMonadicProperty
    public var threshold: Double = 100
    
    @KindMonadicProperty
    public var velocity: Double = 600
    
    @KindMonadicProperty
    public var source: ScrollView< LayoutType >? {
        willSet {
            guard self.source !== newValue else { return }
            self._unsubscribe()
        }
        didSet {
            guard self.source !== oldValue else { return }
            self._subscribe()
        }
    }
    
    public var isAnimating: Bool {
        return self._animation != nil
    }
    
    @KindMonadicSignal
    public let onChanged = Signal< Void, Void >()
    
    var state: State = .show {
        didSet {
            guard self.state != oldValue else { return }
            self.onChanged.emit()
        }
    }
    
    private var _anchor: Double?
    private var _animation: ICancellable? {
        willSet { self._animation?.cancel() }
    }
    
    public init() {
    }
    
    deinit {
        self._animation?.cancel()
    }
    
}

public extension ScrollHideableBar {
    
    func reset(animate: Bool, completion: (() -> Void)? = nil) {
        self._anchor = nil
        self._show(animate: animate, completion: completion)
    }
    
}

private extension ScrollHideableBar {
    
    func _subscribe() {
        guard let source = self.source else { return }
        source.onScrollToTop(self, { $0._onScrollToTop() })
        source.onDragging(self, { $0._onDragging() })
        source.onEndDragging(self, { $0._onEndDragging(decelerating: $1) })
        source.onEndDecelerating(self, { $0._onEndDecelerating() })
    }

    func _unsubscribe() {
        guard let source = self.source else { return }
        source.onEndDecelerating(remove: self)
        source.onEndDragging(remove: self)
        source.onDragging(remove: self)
        source.onScrollToTop(remove: self)
    }
    
    func _onScrollToTop() {
        self._show(animate: true, completion: nil)
    }

    func _onDragging() {
        guard self.isAnimating == false else { return }
        guard let source = self.source else { return }
        let viewSize: Double
        let contentOffset: Double
        let contentSize: Double
        switch self.direction {
        case .horizontal:
            viewSize = source.bounds.width
            contentOffset = source.contentOffset.x + source.adjustmentInset.left
            contentSize = source.adjustmentInset.left + source.contentSize.width + source.adjustmentInset.right
        case .vertical:
            viewSize = source.bounds.height
            contentOffset = source.contentOffset.y + source.adjustmentInset.top
            contentSize = source.adjustmentInset.top + source.contentSize.height + source.adjustmentInset.bottom
        }
        if contentSize > viewSize {
            let anchor: Double
            if let existAnchor = self._anchor {
                anchor = existAnchor
            } else {
                self._anchor = contentOffset
                anchor = contentOffset
            }
            let newState = self.state.proposition(
                threshold: self.threshold,
                anchor: anchor,
                viewSize: viewSize,
                contentOffset: contentOffset,
                contentSize: contentSize
            )
            if newState.isBoundary == true {
                self._anchor = max(0, contentOffset)
            }
            self.state = newState
        }
    }
    
    func _onEndDragging(decelerating: Bool) {
        if decelerating == false {
            self._end()
        }
    }
    
    func _onEndDecelerating() {
        self._end()
    }
    
}

private extension ScrollHideableBar {
    
    @inline(__always)
    func _end() {
        guard let source = self.source else { return }
        let offset: Double
        switch self.direction {
        case .horizontal: offset = source.contentOffset.x + source.adjustmentInset.left
        case .vertical: offset = source.contentOffset.y + source.adjustmentInset.top
        }
        self._end(force: offset <= self.threshold)
    }
    
    @inline(__always)
    func _end(force: Bool) {
        guard self.isAnimating == false else { return }
        self._anchor = nil
        switch self.state {
        case .show, .hide:
            break
        case .hiding(let progress):
            if progress <= .half && force == true {
                self._hide(animate: true, completion: nil)
            } else {
                self._show(animate: true, completion: nil)
            }
        }
    }
    
    @inline(__always)
    func _show(animate: Bool, completion: (() -> Void)?) {
        switch self.state {
        case .show:
            self.state = .show
            completion?()
        case .hide:
            if animate == true {
                self._animation = KindAnimation.default.run(
                    BlockAction(
                        distance: self.threshold,
                        velocity: self.velocity,
                        per: SecondsInterval.one
                    )
                    .ease(QuadraticInOutEase())
                    .onProgress(self, { owner, progress in
                        owner.state = .hiding(progress.invert)
                    })
                    .onFinish(self, { owner, _ in
                        owner._animation = nil
                        owner.state = .show
                        completion?()
                    })
                )
            } else {
                self.state = .show
                completion?()
            }
        case .hiding(let progress):
            if animate == true {
                self._animation = KindAnimation.default.run(
                    BlockAction(
                        distance: self.threshold,
                        velocity: self.velocity,
                        progress: progress.invert,
                        per: SecondsInterval.one
                    )
                    .ease(QuadraticInOutEase())
                    .onProgress(self, { owner, progress in
                        owner.state = .hiding(progress.invert)
                    })
                    .onFinish(self, { owner, _ in
                        owner._animation = nil
                        owner.state = .show
                        completion?()
                    })
                )
            } else {
                self.state = .show
                completion?()
            }
        }
    }
    
    @inline(__always)
    func _hide(animate: Bool, completion: (() -> Void)?) {
        switch self.state {
        case .show:
            if animate == true {
                self._animation = KindAnimation.default.run(
                    BlockAction(
                        distance: self.threshold,
                        velocity: self.velocity,
                        per: SecondsInterval.one
                    )
                    .ease(QuadraticInOutEase())
                    .onProgress(self, { owner, progress in
                        owner.state = .hiding(progress)
                    })
                    .onFinish(self, { owner, _ in
                        owner._animation = nil
                        owner.state = .hide
                        completion?()
                    })
                )
            } else {
                self.state = .hide
                completion?()
            }
        case .hide:
            self.state = .hide
            completion?()
        case .hiding(let progress):
            if animate == true {
                self._animation = KindAnimation.default.run(
                    BlockAction(
                        distance: self.threshold,
                        velocity: self.velocity,
                        progress: progress,
                        per: SecondsInterval.one
                    )
                    .ease(QuadraticInOutEase())
                    .onProgress(self, { owner, progress in
                        owner.state = .hiding(progress)
                    })
                    .onFinish(self, { owner, _ in
                        owner._animation = nil
                        owner.state = .hide
                        completion?()
                    })
                )
            } else {
                self.state = .hide
                completion?()
            }
        }
    }
    
}
