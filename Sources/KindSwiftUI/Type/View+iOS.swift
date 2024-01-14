//
//  KindKit
//

#if os(iOS) && canImport(SwiftUI)

import UIKit
import SwiftUI
import KindGraphics

@available(iOS 13.0, *)
final class KKHostingView< Content : SwiftUI.View > : UIView {
    
    var kkDelegate: KKHostingViewDelegate? {
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

@available(iOS 13.0, *)
extension KKHostingView {
    
    final class KKController< ContentType : SwiftUI.View > : UIHostingController< ContentType > {
        
        weak var kkDelegate: KKHostingViewDelegate?
        
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
                    self.kkDelegate?.didChangeSize()
                }
            } else {
                self._lastContentSize = newContentSize
            }
        }
        
    }
    
}

@available(iOS 13.0, *)
extension KKHostingView {
    
    func kk_size(available: CGSize) -> CGSize {
        return self._controller.sizeThatFits(in: available)
    }
    
}

@available(iOS 13.0, *)
private extension KKHostingView {
    
    var _parent: UIViewController? {
        var responder: UIResponder? = self.next
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder!.next
        }
        return nil
    }
    
    func _attach() {
        guard self._isPresented == false, let vc = self._parent else {
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
