//
//  KindKit
//

#if os(iOS)

import UIKit
import SwiftUI
import KindGraphics

final class KKSwiftView< Content : SwiftUI.View > : UIView {
    
    var kkDelegate: KKSwiftViewDelegate? {
        set { self._controller.kkDelegate = newValue }
        get { self._controller.kkDelegate }
    }
    
    private let _controller: KKController< Content >
    private var _isPresented = false

    public init(rootView: Content) {
        self._controller = .init(rootView: rootView)
        
        super.init(frame: .zero)
        
        self.clipsToBounds = true
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        if self.window != nil {
            self._attach()
        } else {
            self._detach()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self._isPresented == true {
            self._controller.view.frame = self.bounds
        }
    }
    
}

extension KKSwiftView {
    
    final class KKController< ContentType : SwiftUI.View > : UIHostingController< ContentType > {
        
        weak var kkDelegate: KKSwiftViewDelegate?
        
        private var _lastContentSize: CGSize?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.backgroundColor = .clear
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            let newContentSize = self.view.intrinsicContentSize
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
    
}

extension KKSwiftView {
    
    func kk_size(available: CGSize) -> CGSize {
        return self._controller.sizeThatFits(in: available)
    }
    
}

private extension KKSwiftView {
    
    func _attach() {
        guard self._isPresented == false, let vc = self._controller.kk_parent else {
            return
        }
        vc.addChild(self._controller)
        self._controller.view.frame = self.bounds
        self.addSubview(self._controller.view)
        self._controller.didMove(toParent: vc)
        self._isPresented = true
    }

    func _detach() {
        self._controller.removeFromParent()
        self._controller.view.removeFromSuperview()
        self._isPresented = false
    }
    
}

#endif
