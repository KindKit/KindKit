//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public enum ViewCornerRadius : Equatable {
    
    case none
    case manual(radius: Float)
    case auto
    
}

public protocol IViewCornerRadiusable : AnyObject {
    
    var cornerRadius: ViewCornerRadius { set get }
    
}

public extension IViewCornerRadiusable {
    
    @inlinable
    @discardableResult
    func cornerRadius(_ value: ViewCornerRadius) -> Self {
        self.cornerRadius = value
        return self
    }
    
}

public extension IWidgetView where Body : IViewCornerRadiusable {
    
    @inlinable
    var cornerRadius: ViewCornerRadius {
        set(value) { self.body.cornerRadius = value }
        get { return self.body.cornerRadius }
    }
    
    @inlinable
    @discardableResult
    func cornerRadius(_ value: ViewCornerRadius) -> Self {
        self.body.cornerRadius(value)
        return self
    }
    
}
