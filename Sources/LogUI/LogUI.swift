//
//  KindKitLogUI
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public struct LogUI {
    
    public static func container(
        target: Target
    ) -> IModalContentContainer {
        let screen = Screen(target: target)
        let stackScreen = StackScreen()
        screen.onClose = { [unowned stackScreen] in
            stackScreen.dismiss()
        }
        return StackContainer(
            screen: stackScreen,
            rootContainer: ScreenContainer(screen: screen)
        )
    }
    
}

extension LogUI {
    
    class StackScreen : IStackScreen, IScreenModalable {
        
        var container: IContainer?
        var modalPresentation: ScreenModalPresentation {
            return .sheet(
                info: ScreenModalPresentation.Sheet(
                    inset: InsetFloat(top: 80, left: 0, right: 0, bottom: 0),
                    backgroundView: self._backgroundView
                )
            )
        }
        
        private let _backgroundView: EmptyView
        
        init() {
            self._backgroundView = EmptyView(
                width: .fill,
                height: .fill,
                color: Color(rgba: 0x0000007a)
            )
        }
        
    }
    
}
