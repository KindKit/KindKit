//
//  KindKit
//

#if canImport(SwiftUI)

import SwiftUI
import KindUI

protocol KKHostingViewDelegate : AnyObject {
    
    func didChangeSize()
    
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public final class View< Content : SwiftUI.View > {
    
    public private(set) weak var appearedLayout: ILayout?
    public var frame: Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            if self.isLoaded == true {
                self._view.frame = self.frame.cgRect
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
    public let onAppear = Signal< Void, Void >()
    public let onDisappear = Signal< Void, Void >()
    public let onVisible = Signal< Void, Void >()
    public let onInvisible = Signal< Void, Void >()
    
    private let _view: KKHostingView< Content >
    
    public init(content: Content) {
        self._view = .init(rootView: content)
        self._view.kkDelegate = self
    }
    
    public convenience init(content: () -> Content) {
        self.init(content: content())
    }
    
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension View : IView {
    
    public var native: NativeView {
        self._view
    }
    
    public var isLoaded: Bool {
        return true
    }
    
    public var bounds: Rect {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
    }
    
    public func size(available: Size) -> Size {
        guard self.isHidden == false else { return .zero }
        return .init(self._view.kk_size(available: available.cgSize))
    }
    
    public func appear(to layout: ILayout) {
        self.appearedLayout = layout
        self.onAppear.emit()
    }
    
    public func disappear() {
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

@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension View : KKHostingViewDelegate {
    
    func didChangeSize() {
        self.setNeedLayout()
    }
    
}

#endif
