//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View {

    final class Spinner : IUIView, IUIViewReusable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
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
        public private(set) unowned var appearedLayout: IUILayout?
        public unowned var appearedItem: UI.Layout.Item?
        public private(set) var isVisible: Bool = false
        public var isHidden: Bool = false {
            didSet(oldValue) {
                guard self.isHidden != oldValue else { return }
                self.setNeedForceLayout()
            }
        }
        public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
            set(value) { self._reuse.unloadBehaviour = value }
            get { return self._reuse.unloadBehaviour }
        }
        public var reuseCache: UI.Reuse.Cache? {
            set(value) { self._reuse.cache = value }
            get { return self._reuse.cache }
        }
        public var reuseName: String? {
            set(value) { self._reuse.name = value }
            get { return self._reuse.name }
        }
        public var color: UI.Color? = nil {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(color: self.color)
            }
        }
        public var border: UI.Border = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(border: self.border)
            }
        }
        public var cornerRadius: UI.CornerRadius = .none {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(cornerRadius: self.cornerRadius)
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
        public var size: UI.Size.Static = .fixed(40) {
            didSet {
                guard self.isLoaded == true else { return }
                self.setNeedForceLayout()
            }
        }
        public var activityColor: UI.Color? {
            didSet {
                guard self.isLoaded == true else { return }
                self._view.update(activityColor: self.activityColor)
            }
        }
        public var onAppear: ((UI.View.Spinner) -> Void)?
        public var onDisappear: ((UI.View.Spinner) -> Void)?
        public var onVisible: ((UI.View.Spinner) -> Void)?
        public var onVisibility: ((UI.View.Spinner) -> Void)?
        public var onInvisible: ((UI.View.Spinner) -> Void)?
        
        private var _reuse: UI.Reuse.Item< Reusable >
        private var _view: Reusable.Content {
            return self._reuse.content
        }
        private var _isAnimating: Bool = false
        
        public init() {
            self._reuse = UI.Reuse.Item()
            self._reuse.configure(owner: self)
        }
        
        public convenience init(
            configure: (UI.View.Spinner) -> Void
        ) {
            self.init()
            self.modify(configure)
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
                width: self.size,
                height: self.size
            )
        }
        
        public func appear(to layout: IUILayout) {
            self.appearedLayout = layout
            self.onAppear?(self)
        }
        
        public func disappear() {
            self._reuse.disappear()
            self.appearedLayout = nil
            self.onDisappear?(self)
        }
        
        public func visible() {
            self.isVisible = true
            self.onVisible?(self)
        }
        
        public func visibility() {
            self.onVisibility?(self)
        }
        
        public func invisible() {
            self.isVisible = false
            self.onInvisible?(self)
        }
        
    }
    
}
/*
public extension UI.View.Spinner {
    
    @inlinable
    @discardableResult
    func size(_ value: UI.Size.Static) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func activityColor(_ value: UI.Color?) -> Self {
        self.activityColor = value
        return self
    }
    
}
*/
#endif

#if os(iOS) && targetEnvironment(simulator) && canImport(SwiftUI) && DEBUG

import SwiftUI

@available(macOS 10.15.0, *)
@available(iOS 13.0, *)
struct UI_View_Spinner_Preview : PreviewProvider {
    
    static var previews: some View {
        UI.View.Preview(
            UI.View.Custom(.composition(
                entity: .position(
                    mode: .center,
                    entity: .view(UI.View.Spinner(configure: {
                        $0.size = .fixed(40)
                        $0.color = .alabaster
                    }))
                )
            ))
        )
    }
    
}

public extension UI.View.Spinner {
    
    @inlinable
    @discardableResult
    func onAppear(_ value: ((UI.View.Spinner) -> Void)?) -> Self {
        self.onAppear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((UI.View.Spinner) -> Void)?) -> Self {
        self.onDisappear = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((UI.View.Spinner) -> Void)?) -> Self {
        self.onVisible = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((UI.View.Spinner) -> Void)?) -> Self {
        self.onVisibility = value
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((UI.View.Spinner) -> Void)?) -> Self {
        self.onInvisible = value
        return self
    }
    
}

#endif
