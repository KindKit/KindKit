//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public extension UI.Container {
    
    final class None : IUIContainer, IUIContainerParentable {
        
        public unowned var parent: IUIContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if self.parent == nil || self.parent?.isPresented == true {
                    self.didChangeInsets()
                }
            }
        }
        public var shouldInteractive: Bool {
            return false
        }
#if os(iOS)
        public var statusBar: UIStatusBarStyle {
            return .default
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            return .fade
        }
        public var statusBarHidden: Bool {
            return false
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            return .all
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        
        private var _view: UI.View.Empty
        
        public init() {
            self.isPresented = false
            self._view = UI.View.Empty()
                .color(.clear)
        }
        
        public func insets(of content: IUIContainer, interactive: Bool) -> InsetFloat {
            return self.inheritedInsets(interactive: interactive)
        }
        
        public func didChangeInsets() {
        }
        
        public func activate() -> Bool {
            return false
        }
        
        public func didChangeAppearance() {
        }
        
        public func prepareShow(interactive: Bool) {
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
        }
        
        public func cancelShow(interactive: Bool) {
        }
        
        public func prepareHide(interactive: Bool) {
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
        }
        
        public func cancelHide(interactive: Bool) {
        }
        
    }
    
}

extension UI.Container.None : IUIRootContentContainer {
}
