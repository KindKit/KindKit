//
//  KindKit
//

#if os(macOS)

import AppKit
import SwiftUI

final class KKSwiftView< Content : SwiftUI.View > : NSHostingView< Content > {
    
    weak var kkDelegate: KKSwiftViewDelegate?
    
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
                self.kkDelegate?.kk_resize()
            }
        } else {
            self._lastContentSize = newContentSize
        }
    }
    
}

extension KKSwiftView {
    
    func kk_size(available: CGSize) -> CGSize {
        return self.intrinsicContentSize
    }
    
}

#endif
