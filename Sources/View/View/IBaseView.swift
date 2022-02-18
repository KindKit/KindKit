//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IBaseView : AnyObject {
    
    var native: NativeView { get }
    var isLoaded: Bool { get }
    var bounds: RectFloat { get }
    
    func size(available: SizeFloat) -> SizeFloat
    
    func disappear()
    
    func isChild(of view: IView, recursive: Bool) -> Bool
    
    @discardableResult
    func onAppear(_ value: (() -> Void)?) -> Self
    
    @discardableResult
    func onDisappear(_ value: (() -> Void)?) -> Self
    
}

public extension IBaseView {
    
    func isChild(of view: IView, recursive: Bool) -> Bool {
        guard self.isLoaded == true && view.isLoaded == true else { return false }
        return self.native.isChild(of: view.native, recursive: recursive)
    }
    
}
