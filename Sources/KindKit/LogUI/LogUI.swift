//
//  KindKit
//

import Foundation

public struct LogUI {
    
    public static func container(
        target: Target
    ) -> UI.Container.Stack< StackScreen > {
        return UI.Container.Stack(
            screen: StackScreen(),
            root: UI.Container.Screen(Screen(target: target))
        )
    }
    
}
