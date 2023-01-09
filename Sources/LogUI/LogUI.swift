//
//  KindKit
//

import Foundation

public struct LogUI {
    
    public static func container(
        target: Target
    ) -> UI.Container.Stack< StackScreen > {
        let screen = Screen(target: target)
        let stackScreen = StackScreen()
        screen.onClose = { [weak stackScreen] in
            guard let stackScreen = stackScreen else { return }
            if stackScreen.modalDismiss() == false {
                stackScreen.dismiss()
            }
        }
        return UI.Container.Stack(
            screen: stackScreen,
            root: UI.Container.Screen(screen)
        )
    }
    
}
