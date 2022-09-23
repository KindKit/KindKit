//
//  KindKit
//

import Foundation

public struct LogUI {
    
    public static func container(
        target: Target
    ) -> IUIModalContentContainer {
        let screen = Screen(target: target)
        let stackScreen = StackScreen()
        screen.onClose = { [unowned stackScreen] in
            stackScreen.dismiss()
        }
        return UI.Container.Stack(
            screen: stackScreen,
            rootContainer: UI.Container.Screen(screen)
        )
    }
    
}

extension LogUI {
    
    final class StackScreen : IUIStackScreen, IUIScreenModalable {
        
        var container: IUIContainer?
        var modalPresentation: UI.Screen.Modal.Presentation {
            return .sheet(
                info: UI.Screen.Modal.Presentation.Sheet(
                    inset: InsetFloat(top: 80, left: 0, right: 0, bottom: 0),
                    backgroundView: self._backgroundView
                )
            )
        }
        
        private let _backgroundView: UI.View.Empty
        
        init() {
            self._backgroundView = UI.View.Empty()
                .color(.init(rgba: 0x0000007a))
        }
        
    }
    
}
