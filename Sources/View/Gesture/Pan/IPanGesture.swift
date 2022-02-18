//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IPanGesture : IGesture {
    
    func translation(in view: IView) -> PointFloat
    
    func velocity(in view: IView) -> PointFloat
    
    @discardableResult
    func onBegin(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onChange(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onCancel(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onEnd(_ value: (() -> Void)?) -> Self
    
}
