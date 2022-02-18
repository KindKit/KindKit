//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public class LayoutItem {
    
    public var frame: RectFloat
    public private(set) var view: IView
    public private(set) var isNeedForceUpdate: Bool
    
    public init(
        view: IView
    ) {
        self.frame = .zero
        self.view = view
        self.isNeedForceUpdate = false
        
        self.view.item = self
    }
    
    deinit {
        self.view.item = nil
    }
    
}

public extension LayoutItem {
    
    @inlinable
    var isHidden: Bool {
        return self.view.isHidden
    }
    
    func setNeedForceUpdate() {
        self.isNeedForceUpdate = true
    }
    
    func resetNeedForceUpdate() {
        self.isNeedForceUpdate = false
    }
    
    @inlinable
    func size(available: SizeFloat) -> SizeFloat {
        return self.view.size(available: available)
    }
    
}
