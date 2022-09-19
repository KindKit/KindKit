//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View {

    final class Graphics : IUIView, IUIViewStaticSizeable, IUIViewLockable, IUIViewColorable, IUIViewAlphable {
        
        public private(set) unowned var layout: IUILayout?
        public unowned var item: UI.Layout.Item?
        public var native: NativeView {
            return self._view
        }
        public var isLoaded: Bool {
            return self._reuse.isLoaded
        }
        public var bounds: RectFloat {
            guard self.isLoaded == true else { return .zero }
            return Rect(self._view.bounds)
        }
        public private(set) var isVisible: Bool = false
        public var isHidden: Bool = false {
            didSet(oldValue) {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var width: UI.Size.Static = .fill {
            didSet(oldValue) {
                guard self.width != oldValue else { return }
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Static = .fill {
            didSet(oldValue) {
                guard self.height != oldValue else { return }
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var canvas: IGraphicsCanvas {
            willSet(oldValue) {
                guard self.canvas !== oldValue else { return }
                self.canvas.detach()
            }
            didSet(oldValue) {
                guard self.canvas !== oldValue else { return }
                self.canvas.attach(view: self)
                self._view.update(canvas: self.canvas)
            }
        }
        public var isLocked: Bool {
            set(value) {
                if self._isLocked != value {
                    self._isLocked = value
                    if self.isLoaded == true {
                        self._view.update(locked: self._isLocked)
                    }
                    self.triggeredChangeStyle(false)
                }
            }
            get { return self._isLocked }
        }
        public var color: Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var alpha: Float = 1 {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(alpha: self.alpha)
            }
        }
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content()
        }
        private var _isLocked: Bool = false
        private var _onAppear: ((UI.View.Graphics) -> Void)?
        private var _onDisappear: ((UI.View.Graphics) -> Void)?
        private var _onVisible: ((UI.View.Graphics) -> Void)?
        private var _onVisibility: ((UI.View.Graphics) -> Void)?
        private var _onInvisible: ((UI.View.Graphics) -> Void)?
        private var _onChangeStyle: ((UI.View.Graphics, Bool) -> Void)?
        
        public init(
            _ canvas: IGraphicsCanvas
        ) {
            self.canvas = canvas
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
            self.canvas.attach(view: self)
        }
        
        deinit {
            self._reuse.destroy()
        }
        
        public func loadIfNeeded() {
            self._reuse.loadIfNeeded()
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            guard self.isHidden == false else { return .zero }
            return UI.Size.Static.apply(
                available: available,
                width: self.width,
                height: self.height
            )
        }
        
        public func appear(to layout: IUILayout) {
            self.layout = layout
            self._onAppear?(self)
        }
        
        public func disappear() {
            self._reuse.disappear()
            self.layout = nil
            self._onDisappear?(self)
        }
        
        public func visible() {
            self.isVisible = true
            self._onVisible?(self)
        }
        
        public func visibility() {
            self._onVisibility?(self)
        }
        
        public func invisible() {
            self.isVisible = false
            self._onInvisible?(self)
        }
        
        public func setNeedRedraw() {
            guard self.isAppeared == true else { return }
            self._view.setNeedsDisplay()
        }
        
        public func triggeredChangeStyle(_ userInteraction: Bool) {
            self._onChangeStyle?(self, userInteraction)
        }
        
        @discardableResult
        public func onAppear(_ value: ((UI.View.Graphics) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Graphics) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Graphics) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Graphics) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Graphics) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }
        
        @discardableResult
        public func onChangeStyle(_ value: ((UI.View.Graphics, Bool) -> Void)?) -> Self {
            self._onChangeStyle = value
            return self
        }
        
    }
    
}

#endif
