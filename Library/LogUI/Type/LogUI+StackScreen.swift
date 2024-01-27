//
//  KindKit
//

import KindScreenUI

public extension LogUI {
    
    final class StackScreen : IStackScreen, IScreenModalable {
        
        public var container: IContainer?
        public var modalPresentation: Modal.Presentation {
            return .sheet(
                inset: .init(top: 80, left: 0, right: 0, bottom: 0),
                cornerRadius: .manual(radius: 10),
                background: RectView()
                    .fill(.black.with(alpha: 0.5))
            )
        }
        
        init() {
        }
        
    }
    
}
