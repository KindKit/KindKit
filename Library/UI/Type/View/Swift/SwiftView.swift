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

public final class SwiftView< Content : SwiftUI.View > : IView {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    private var _layout: StaticLayoutItem< SwiftView< Content >, KKSwiftView< Content > >!
    
    public init(_ content: Content) {
        self._layout = .init(self, .init(rootView: content))
        self._layout.view.kkDelegate = self
    }
    
    public convenience init(_ content: () -> Content) {
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
