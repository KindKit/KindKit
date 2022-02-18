//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IScreenModalable : AnyObject {
    
    var modalPresentation: ScreenModalPresentation { get }
    
}

public enum ScreenModalPresentation {
    
    case simple
    case sheet(info: Sheet)
    
}

public extension ScreenModalPresentation {
    
    struct Sheet {
        
        public let inset: InsetFloat
        public let backgroundView: IView & IViewAlphable
        
        public init(
            inset: InsetFloat,
            backgroundView: IView & IViewAlphable
        ) {
            self.inset = inset
            self.backgroundView = backgroundView
        }
        
    }
    
}

public extension IScreenModalable {
    
    var modalPresentation: ScreenModalPresentation {
        return .simple
    }
    
}

public extension IScreenModalable where Self : IScreen {
    
    @inlinable
    var modalContentContainer: IModalContentContainer? {
        guard let contentContainer = self.container as? IModalContentContainer else { return nil }
        return contentContainer
    }
    
    @inlinable
    var modalContainer: IModalContainer? {
        return self.modalContentContainer?.modalContainer
    }
    
    @inlinable
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.modalContentContainer?.dismiss(animated: animated, completion: completion)
    }
    
}
