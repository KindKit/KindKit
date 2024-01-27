//
//  KindKit
//

import KindScreenUI

public struct LogUI {
    
    public static func container(
        target: Target
    ) -> Container.Stack< StackScreen > {
        return Container.Stack(
            screen: StackScreen(),
            root: Container.Screen(Screen(target: target))
        )
    }
    
}
