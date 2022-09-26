//
//  KindKit
//

#if os(iOS) && targetEnvironment(simulator) && canImport(SwiftUI) && DEBUG

import UIKit
import SwiftUI

public extension UI.Container {

    @available(iOS 13, tvOS 13.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    struct Preview : UIViewRepresentable {
        
        private let viewController: UI.ViewController

        public init(
            _ viewController: UI.ViewController
        ) {
            self.viewController = viewController
        }
        
        public init(
            _ container: UI.Container.Root
        ) {
            self.viewController = .init(container)
        }
        
        public init(
            _ container: IUIRootContentContainer
        ) {
            self.viewController = .init(container)
        }
        
        public init< Screen : IUIScreen & IUIScreenViewable >(
            _ screen: Screen
        ) {
            self.viewController = .init(screen)
        }
        
        public init< Wireframe : IUIWireframe >(
            _ wireframe: Wireframe
        ) where Wireframe : AnyObject, Wireframe.Container == UI.Container.Root {
            self.viewController = .init(wireframe)
        }
        
        public init< Wireframe : IUIWireframe >(
            _ wireframe: Wireframe
        ) where Wireframe : AnyObject, Wireframe.Container : IUIRootContentContainer {
            self.viewController = .init(wireframe)
        }

        public func makeUIView(context: Context) -> some UIView {
            return self.viewController.view
        }

        public func updateUIView(_ uiView: UIViewType, context: Context) {
        }
        
    }
    
}

#endif
