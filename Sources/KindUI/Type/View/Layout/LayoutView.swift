//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@KindMonadic
public final class LayoutView< LayoutType : ILayout > : IView, IViewDynamicSizeable, IViewContentable, IViewColorable, IViewAlphable {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var handle: NativeView {
        return self._layout.view
    }
    
    public var isLoaded: Bool {
        return self._layout.isLoaded
    }
    
    public var size: DynamicSize = .fit {
        didSet {
            guard self.size != oldValue else { return }
            self._layout.manager.available = self.size
            self.updateLayout(force: true)
        }
    }
    
    public var content: LayoutType? {
        set { self._layout.manager.content = newValue }
        get { self._layout.manager.content }
    }
    
    public var color: Color? {
        didSet {
            guard self.color != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(color: self.color)
            }
        }
    }
    
    public var alpha: Double = 1 {
        didSet {
            guard self.alpha != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(alpha: self.alpha)
            }
        }
    }
    
    public var onAppear: Signal< Void, Bool > {
        return self._layout.onAppear
    }
    
    public var onDisappear: Signal< Void, Void > {
        return self._layout.onDisappear
    }
    
    var holder: IHolder? {
        set { self._layout.manager.holder = newValue }
        get { self._layout.manager.holder }
    }
    
    private var _layout: ReuseRootLayoutItem< Reusable, LayoutType >!

    public init() {
        self._layout = .init(self)
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self._layout.sizeOf(request)
    }

}
