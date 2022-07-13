//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGesture : AnyObject {
    
    var native: NativeGesture { get }
    
    var isEnabled: Bool { set get }
    
    #if os(macOS)
    
    var delaysPrimaryMouseButtonEvents: Bool { get }

    var delaysSecondaryMouseButtonEvents: Bool { get }

    var delaysOtherMouseButtonEvents: Bool { get }

    var delaysKeyEvents: Bool { get }

    var delaysMagnificationEvents: Bool { get }

    var delaysRotationEvents: Bool { get }
    
    #elseif os(iOS)
    
    var cancelsTouchesInView: Bool { set get }
    
    var delaysTouchesBegan: Bool { set get }
    
    var delaysTouchesEnded: Bool { set get }
    
    var requiresExclusiveTouchType: Bool { set get }
    
    func require(toFail gesture: NativeGesture)
    
    #endif
    
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
        let location = self.location(in: view)
        return view.bounds.isContains(location)
    }
    
}
