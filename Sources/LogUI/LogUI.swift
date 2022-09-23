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
        screen.onClose = { [unowned stackScreen] in
            stackScreen.dismiss()
        }
        return UI.Container.Stack(
            screen: stackScreen,
            root: UI.Container.Screen(screen)
        )
    }
    
}

#if canImport(SwiftUI) && DEBUG

import SwiftUI

@available(macOS 10.15.0, *)
@available(iOS 15.0, *)
struct LogUI_Preview : PreviewProvider {
    
    static var target: LogUI.Target = {
        let target = LogUI.Target()
        Log.shared.append(target: target)
        
        Log.shared.log(level: .info, category: "Info", message: "Message #1")
        Log.shared.log(level: .debug, category: "Debug", message: "Message #2")
        Log.shared.log(level: .error, category: "Error", message: "Message #3")

        return target
    }()
    
    static var previews: some View {
        UI.Container.Preview(
            LogUI.container(
                target: Self.target
            )
        )
    }
    
}

#endif
