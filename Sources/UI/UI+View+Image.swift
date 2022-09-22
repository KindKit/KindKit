//
//  KindKit
//

import Foundation

public extension UI.View {

    final class Image : IUIView, IUIViewDynamicSizeable, IUIViewColorable, IUIViewTintColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public var width: UI.Size.Dynamic = .fit {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var height: UI.Size.Dynamic = .fit {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var aspectRatio: Float? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var image: KindKit.Image {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(image: self.image)
                self.setNeedForceLayout()
            }
        }
        public var mode: Mode = .aspectFit {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(mode: self.mode)
                self.setNeedForceLayout()
            }
        }
        public var color: Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var tintColor: Color? {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(tintColor: self.tintColor)
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(cornerRadius: self.cornerRadius)
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(border: self.border)
            }
        }
        public var shadow: UI.Shadow? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(shadow: self.shadow)
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
        private var _onAppear: ((UI.View.Image) -> Void)?
        private var _onDisappear: ((UI.View.Image) -> Void)?
        private var _onVisible: ((UI.View.Image) -> Void)?
        private var _onVisibility: ((UI.View.Image) -> Void)?
        private var _onInvisible: ((UI.View.Image) -> Void)?
        
        public init(
            _ image: KindKit.Image
        ) {
            self.image = image
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
        }
        
        deinit {
            self._reuse.destroy()
        }
        
        public func loadIfNeeded() {
            self._reuse.loadIfNeeded()
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            guard self.isHidden == false else { return .zero }
            return UI.Size.Dynamic.apply(
                available: available,
                width: self.width,
                height: self.height,
                sizeWithWidth: {
                    switch self.mode {
                    case .origin:
                        if let aspectRatio = self.aspectRatio {
                            return Size(width: $0, height: $0 / aspectRatio)
                        }
                        return image.size
                    case .aspectFit, .aspectFill:
                        let aspectRatio = self.aspectRatio ?? self.image.size.aspectRatio
                        return Size(width: $0, height: $0 / aspectRatio)
                    }
                },
                sizeWithHeight: {
                    switch self.mode {
                    case .origin:
                        if let aspectRatio = self.aspectRatio {
                            return Size(width: $0 * aspectRatio, height: $0)
                        }
                        return image.size
                    case .aspectFit, .aspectFill:
                        let aspectRatio = self.aspectRatio ?? self.image.size.aspectRatio
                        return Size(width: $0 * aspectRatio, height: $0)
                    }
                },
                size: {
                    switch self.mode {
                    case .origin:
                        if let aspectRatio = self.aspectRatio {
                            if available.width.isInfinite == true && available.height.isInfinite == false {
                                return Size(
                                    width: available.height * aspectRatio,
                                    height: available.height
                                )
                            } else if available.width.isInfinite == false && available.height.isInfinite == true {
                                return Size(
                                    width: available.width,
                                    height: available.width / aspectRatio
                                )
                            }
                        }
                        return self.image.size
                    case .aspectFit, .aspectFill:
                        if available.isInfinite == true {
                            return self.image.size
                        } else if available.width.isInfinite == true {
                            let aspectRatio = self.image.size.aspectRatio
                            return Size(
                                width: available.height * aspectRatio,
                                height: available.height
                            )
                        } else if available.height.isInfinite == true {
                            let aspectRatio = self.image.size.aspectRatio
                            return Size(
                                width: available.width,
                                height: available.width / aspectRatio
                            )
                        }
                        return self.image.size.aspectFit(available)
                    }
                }
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
        
        @discardableResult
        public func onAppear(_ value: ((UI.View.Image) -> Void)?) -> Self {
            self._onAppear = value
            return self
        }
        
        @discardableResult
        public func onDisappear(_ value: ((UI.View.Image) -> Void)?) -> Self {
            self._onDisappear = value
            return self
        }
        
        @discardableResult
        public func onVisible(_ value: ((UI.View.Image) -> Void)?) -> Self {
            self._onVisible = value
            return self
        }
        
        @discardableResult
        public func onVisibility(_ value: ((UI.View.Image) -> Void)?) -> Self {
            self._onVisibility = value
            return self
        }
        
        @discardableResult
        public func onInvisible(_ value: ((UI.View.Image) -> Void)?) -> Self {
            self._onInvisible = value
            return self
        }

    }
    
}

public extension UI.View.Image {
    
    @inlinable
    @discardableResult
    func aspectRatio(_ value: Float?) -> Self {
        self.aspectRatio = value
        return self
    }
    
    @inlinable
    @discardableResult
    func image(_ value: KindKit.Image) -> Self {
        self.image = value
        return self
    }
    
    @inlinable
    @discardableResult
    func mode(_ value: Mode) -> Self {
        self.mode = value
        return self
    }
    
}