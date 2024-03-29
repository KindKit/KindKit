//
//  KindKit
//

#if os(iOS)

import Foundation

protocol KKSliderViewDelegate : AnyObject {
    
    func startEditing(_ view: KKSliderView)
    func editing(_ view: KKSliderView, value: Double)
    func endEditing(_ view: KKSliderView)
    
}

public extension UI.View {

    final class Slider {
        
        public private(set) weak var appearedLayout: IUILayout?
        public var frame: KindKit.Rect = .zero {
            didSet {
                guard self.frame != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(frame: self.frame)
                }
            }
        }
#if os(iOS)
        public var transform: UI.Transform = .init() {
            didSet {
                guard self.transform != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(transform: self.transform)
                }
            }
        }
#endif
        public var size: UI.Size.Static = .init(.fill, .fixed(40)) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public var value: Double = 0 {
            didSet {
                guard self.value != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(value: self.value, limit: self.limit)
                }
            }
        }
        public var limit: Range< Double > = 0 ..< 1 {
            didSet {
                guard self.limit != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(value: self.value, limit: self.limit)
                }
            }
        }
        public var progress: Double {
            set {
                if newValue <= 0 {
                    self.value = self.limit.lowerBound
                } else if newValue >= 1 {
                    self.value = self.limit.upperBound
                } else {
                    self.value = self.limit.lowerBound.lerp(self.limit.upperBound, progress: .init(newValue))
                }
            }
            get {
                if self.value <= self.limit.lowerBound {
                    return 0
                } else if self.value >= self.limit.upperBound {
                    return 1
                } else {
                    return (self.value - self.limit.lowerBound) / (self.limit.upperBound - self.limit.lowerBound)
                }
            }
        }
        public var progressColor: UI.Color? {
            didSet {
                guard self.progressColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(progressColor: self.progressColor)
                }
            }
        }
        public var trackColor: UI.Color? {
            didSet {
                guard self.trackColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(trackColor: self.trackColor)
                }
            }
        }
        public var thumbImage: UI.Image? {
            didSet {
                guard self.thumbImage != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(thumbImage: self.thumbImage)
                }
            }
        }
        public var thumbColor: UI.Color? {
            didSet {
                guard self.trackColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(thumbColor: self.thumbColor)
                }
            }
        }
        public var color: UI.Color? {
            didSet {
                guard self.color != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(color: self.color)
                }
            }
        }
        public var alpha: Double = 1 {
            didSet {
                guard self.alpha != oldValue else { return }
                if self.isLoaded == true {
                    self._view.kk_update(alpha: self.alpha)
                }
            }
        }
        public var isHidden: Bool = false {
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public private(set) var isEditing: Bool = false
        public let onAppear = Signal.Empty< Void >()
        public let onDisappear = Signal.Empty< Void >()
        public let onVisible = Signal.Empty< Void >()
        public let onInvisible = Signal.Empty< Void >()
        public let onBeginEditing = Signal.Empty< Void >()
        public let onEditing = Signal.Empty< Void >()
        public let onEndEditing = Signal.Empty< Void >()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        
        public init() {
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.View.Slider {
    
    @inlinable
    @discardableResult
    func progressColor(_ value: UI.Color) -> Self {
        self.progressColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func progressColor(_ value: () -> UI.Color) -> Self {
        return self.progressColor(value())
    }

    @inlinable
    @discardableResult
    func progressColor(_ value: (Self) -> UI.Color) -> Self {
        return self.progressColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func trackColor(_ value: UI.Color) -> Self {
        self.trackColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trackColor(_ value: () -> UI.Color) -> Self {
        return self.trackColor(value())
    }

    @inlinable
    @discardableResult
    func trackColor(_ value: (Self) -> UI.Color) -> Self {
        return self.trackColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func thumbImage(_ value: UI.Image) -> Self {
        self.thumbImage = value
        return self
    }
    
    @inlinable
    @discardableResult
    func thumbImage(_ value: () -> UI.Image) -> Self {
        return self.thumbImage(value())
    }

    @inlinable
    @discardableResult
    func thumbImage(_ value: (Self) -> UI.Image) -> Self {
        return self.thumbImage(value(self))
    }
    
    @inlinable
    @discardableResult
    func thumbColor(_ value: UI.Color) -> Self {
        self.thumbColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func thumbColor(_ value: () -> UI.Color) -> Self {
        return self.thumbColor(value())
    }

    @inlinable
    @discardableResult
    func thumbColor(_ value: (Self) -> UI.Color) -> Self {
        return self.thumbColor(value(self))
    }
    
}

extension UI.View.Slider : IUIView {
    
    public var native: NativeView {
        self._view
    }
    
    public var isLoaded: Bool {
        self._reuse.isLoaded
    }
    
    public var bounds: Rect {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: Size) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.size.apply(available: available)
    }
    
    public func appear(to layout: IUILayout) {
        self.appearedLayout = layout
        self.onAppear.emit()
    }
    
    public func disappear() {
        self._reuse.disappear()
        self.appearedLayout = nil
        self.onDisappear.emit()
    }
    
    public func visible() {
        self.isVisible = true
        self.onVisible.emit()
    }
    
    public func invisible() {
        self.isVisible = false
        self.onInvisible.emit()
    }
    
}

extension UI.View.Slider : IUIViewReusable {
    
    public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: UI.Reuse.Cache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

#if os(iOS)

extension UI.View.Slider : IUIViewTransformable {
}

#endif

extension UI.View.Slider : IUIViewStaticSizeable {
}

extension UI.View.Slider : IUIViewEditable {
}

extension UI.View.Slider : IUIViewProgressable {
}

extension UI.View.Slider : IUIViewColorable {
}

extension UI.View.Slider : IUIViewAlphable {
}

extension UI.View.Slider : KKSliderViewDelegate {
    
    func startEditing(_ view: KKSliderView) {
        guard self.isEditing == false else { return }
        self.isEditing = true
        self.onBeginEditing.emit()
    }
    
    func editing(_ view: KKSliderView, value: Double) {
        guard self.value != value else { return }
        self.value = value
        self.onEditing.emit()
    }
    
    func endEditing(_ view: KKSliderView) {
        guard self.isEditing == true else { return }
        self.isEditing = false
        self.onEndEditing.emit()
    }
    
}

public extension IUIView where Self == UI.View.Slider {
    
    @inlinable
    static func slider() -> Self {
        return .init()
    }
    
}

#endif
