//
//  KindKit
//

import SwiftUI
import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

protocol KKSwiftViewDelegate : AnyObject {
    
    func kk_resize()
    
}

public final class SwiftView< ContentType : SwiftUI.View > : IView {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var handle: NativeView {
        return self._layout.view
    }
    
    public var isLoaded: Bool {
        return true
    }
    
    public var onAppear: Signal< Void, Bool > {
        return self._layout.onAppear
    }
    
    public var onDisappear: Signal< Void, Void > {
        return self._layout.onDisappear
    }
    
    private var _layout: StaticLayoutItem< SwiftView< ContentType >, KKSwiftView< ContentType > >!
    
    public init(_ content: ContentType) {
        self._layout = .init(self, .init(rootView: content))
        self._layout.view.kkDelegate = self
    }
    
    public convenience init(_ content: () -> ContentType) {
        self.init(content())
    }
    
    deinit {
        self._layout.view.kkDelegate = nil
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        let available = request.available.normalized(request.container)
        let fitSize = self._layout.view.kk_size(available: available.cgSize)
        return .init(fitSize)
    }
    
}

extension SwiftView : KKSwiftViewDelegate {
    
    func kk_resize() {
        self.updateLayout(force: true)
    }
    
}
