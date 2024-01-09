//
//  KindKit
//

#if os(macOS) && canImport(SwiftUI)

import AppKit
import SwiftUI

@available(macOS 10.15, *)
final class KKHostingView< Content : SwiftUI.View > : NSHostingView< Content > {
    
    weak var kkDelegate: KKHostingViewDelegate?
    
    private var _lastContentSize: CGSize?
    
    required init(rootView: Content) {
        super.init(rootView: rootView)
        
        self.layer?.backgroundColor = .clear
        self.clipsToBounds = true
    }
    
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        
        let newContentSize = self.intrinsicContentSize
        if let lastContentSize = self._lastContentSize {
            if newContentSize != lastContentSize {
                self._lastContentSize = newContentSize
                self.kkDelegate?.didChangeSize()
            }
        } else {
            self._lastContentSize = newContentSize
        }
    }
    
}

@available(macOS 10.15, *)
extension KKHostingView {
    
    func kk_size(available: CGSize) -> CGSize {
        return self.intrinsicContentSize
    }
    
}

#endif
