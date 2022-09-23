//
//  KindKit
//

import Foundation

public extension LogUI {
    
    final class StackScreen : IUIStackScreen, IUIScreenModalable {
        
        public var container: IUIContainer?
        public var modalPresentation: UI.Screen.Modal.Presentation {
            return .sheet(
                info: UI.Screen.Modal.Presentation.Sheet(
                    inset: .init(top: 80, left: 0, right: 0, bottom: 0),
                    background: self._backgroundView
                )
            )
        }
        
        private let _backgroundView: UI.View.Empty
        
        init() {
            self._backgroundView = UI.View.Empty(configure: {
                $0.color = .black.with(alpha: 0.5)
            })
        }
        
    }
    
}
