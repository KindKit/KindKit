//
//  KindKit
//

import Foundation

public protocol IUIGesture : AnyObject {
    
    var native: NativeGesture { get }
    
    var isLoaded: Bool { get }
    
    var isEnabled: Bool { set get }
    
#if os(macOS)
    
    var delaysPrimaryMouseButtonEvents: Bool { set get }
    
    var delaysSecondaryMouseButtonEvents: Bool { set get }
    
    var delaysOtherMouseButtonEvents: Bool { set get }
    
    var delaysKeyEvents: Bool { set get }
    
    var delaysMagnificationEvents: Bool { set get }
    
    var delaysRotationEvents: Bool { set get }
    
#elseif os(iOS)
    
    var cancelsTouchesInView: Bool { set get }
    
    var delaysTouchesBegan: Bool { set get }
    
    var delaysTouchesEnded: Bool { set get }
    
    var requiresExclusiveTouchType: Bool { set get }
        
#endif
    
    @discardableResult
    func enabled(_ value: Bool) -> Self
    
    @discardableResult
    func onShouldBegin(_ value: ((Self) -> Bool)?) -> Self
    
    @discardableResult
    func onShouldSimultaneously(_ value: ((Self, NativeGesture) -> Bool)?) -> Self
    
    @discardableResult
    func onShouldRequireFailure(_ value: ((Self, NativeGesture) -> Bool)?) -> Self
    
    @discardableResult
    func onShouldBeRequiredToFailBy(_ value: ((Self, NativeGesture) -> Bool)?) -> Self
    
}

public extension IUIGesture {
    
    @discardableResult
    func enabled(_ value: Bool) -> Self {
        self.isEnabled = value
        return self
    }


    func contains(in view: IUIView) -> Bool {
        let location = self.location(in: view)
        return view.bounds.isContains(location)
    }

    func location(in view: IUIView) -> PointFloat {
        return PointFloat(self.native.location(in: view.native))
    }

}

#if os(macOS)

public extension IUIGesture {
    
    @inlinable
    @discardableResult
    func delaysPrimaryMouseButtonEvents(_ value: Bool) -> Self {
        self.delaysPrimaryMouseButtonEvents = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysSecondaryMouseButtonEvents(_ value: Bool) -> Self {
        self.delaysSecondaryMouseButtonEvents = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysOtherMouseButtonEvents(_ value: Bool) -> Self {
        self.delaysOtherMouseButtonEvents = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysKeyEvents(_ value: Bool) -> Self {
        self.delaysKeyEvents = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysMagnificationEvents(_ value: Bool) -> Self {
        self.delaysMagnificationEvents = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysRotationEvents(_ value: Bool) -> Self {
        self.delaysRotationEvents = value
        return self
    }
    
}

#elseif os(iOS)

public extension IUIGesture {
    
    @inlinable
    @discardableResult
    func cancelsTouchesInView(_ value: Bool) -> Self {
        self.cancelsTouchesInView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysTouchesBegan(_ value: Bool) -> Self {
        self.delaysTouchesBegan = value
        return self
    }
    
    @inlinable
    @discardableResult
    func delaysTouchesEnded(_ value: Bool) -> Self {
        self.delaysTouchesEnded = value
        return self
    }
    
    @inlinable
    @discardableResult
    func requiresExclusiveTouchType(_ value: Bool) -> Self {
        self.requiresExclusiveTouchType = value
        return self
    }

    func require(toFail gesture: IUIGesture) {
        self.require(toFail: gesture.native)
    }

    func require(toFail gesture: NativeGesture) {
        self.native.require(toFail: gesture)
    }
    
}

#endif
