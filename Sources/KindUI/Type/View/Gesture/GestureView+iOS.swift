//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension GestureView {
    
    struct Reusable : IReusable {
        
        typealias Owner = GestureView
        typealias Content = KKGestureView
        
        static func name(owner: Owner) -> String {
            return "GestureView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
        }
        
    }
    
}

final class KKGestureView : UIView {
    
    var kkGestures: [IGesture] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKGestureView {
    
    func kk_update(view: GestureView) {
        self.kk_update(frame: view.frame)
        self.kk_update(gestures: view.gestures)
        self.kk_update(enabled: view.isEnabled)
    }
    
    final func kk_cleanup(view: GestureView) {
        for gesture in self.kkGestures {
            self.removeGestureRecognizer(gesture.handle)
        }
        self.kkGestures.removeAll()
    }
    
}

extension KKGestureView {
    
    func kk_update(gestures: [IGesture]) {
        for gesture in self.kkGestures {
            self.removeGestureRecognizer(gesture.handle)
        }
        self.kkGestures = gestures
        for gesture in self.kkGestures {
            self.addGestureRecognizer(gesture.handle)
        }
    }
    
    func kk_add(gesture: IGesture) {
        if self.kkGestures.contains(where: { $0 === gesture }) == false {
            self.kkGestures.append(gesture)
        }
        self.addGestureRecognizer(gesture.handle)
    }
    
    func kk_remove(gesture: IGesture) {
        if let index = self.kkGestures.firstIndex(where: { $0 === gesture }) {
            self.kkGestures.remove(at: index)
        }
        self.removeGestureRecognizer(gesture.handle)
    }
    
    func kk_update(enabled: Bool) {
        self.isUserInteractionEnabled = enabled
    }
    
}

#endif
