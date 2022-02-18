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
    
    @discardableResult
    func cornerRadius(_ value: ViewCornerRadius) -> Self
    
}

extension IWidgetView where Body : IViewCornerRadiusable {
    
    public var cornerRadius: ViewCornerRadius {
        set(value) { self.body.cornerRadius = value }
        get { return self.body.cornerRadius }
    }
    
    @discardableResult
    public func cornerRadius(_ value: ViewCornerRadius) -> Self {
        self.body.cornerRadius(value)
        return self
    }
    
}
