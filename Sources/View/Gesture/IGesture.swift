//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGesture : AnyObject {
    
    var native: NativeGesture { get }
    
    var isEnabled: Bool { set get }
    
    var cancelsTouchesInView: Bool { set get }
    
    var delaysTouchesBegan: Bool { set get }
    
    var delaysTouchesEnded: Bool { set get }
    
    @available(iOS 9.2, *)
    var requiresExclusiveTouchType: Bool { set get }
    
    func require(toFail gesture: NativeGesture)
    
    func contains(in view: IView) -> Bool
    
    func location(in view: IView) -> PointFloat
    
    @discardableResult
    func enabled(_ value: Bool) -> Self
    
    @discardableResult
    func onShouldBegin(_ value: (() -> Bool)?) -> Self
    
    @discardableResult
    func onShouldSimultaneously(_ value: ((_ otherGesture: NativeGesture) -> Bool)?) -> Self
    
    @discardableResult
    func onShouldRequireFailure(_ value: ((_ otherGesture: NativeGesture) -> Bool)?) -> Self
    
    @discardableResult
    func onShouldBeRequiredToFailBy(_ value: ((_ otherGesture: NativeGesture) -> Bool)?) -> Self
    
}

public extension IGesture {
    
    func contains(in view: IView) -> Bool {
        let bounds = RectFloat(view.native.bounds)
        let location = PointFloat(self.native.location(in: view.native))
        return bounds.isContains(point: location)
    }
    
}
