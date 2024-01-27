//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout

public final class PlatformView : IView, IViewDynamicSizeable, IViewContentable {
    
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
            self.updateLayout(force: true)
        }
    }
    
    public var content: NativeView? {
        didSet {
            guard self.content !== oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(content: self.content)
            }
            self.updateLayout(force: true)
        }
    }
    
    public var onAppear: Signal< Void, Bool > {
        return self._layout.onAppear
    }
    
    public var onDisappear: Signal< Void, Void > {
        return self._layout.onDisappear
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init() {
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.size.resolve(
            by: request,
            calculate: {
                return .init(self._layout.view.kk_sizeOf($0.cgSize))
            }
        )
    }
    
}
