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
    
    final class State : IUIStateContainer {
        
        public unowned var parent: IUIContainer? {
            didSet(oldValue) {
                guard self.parent !== oldValue else { return }
                if self.parent == nil || self.parent?.isPresented == true {
                    self.didChangeInsets()
                }
            }
        }
        public var shouldInteractive: Bool {
            return self.container?.shouldInteractive ?? false
        }
#if os(iOS)
        public var statusBarHidden: Bool {
            return self.container?.statusBarHidden ?? false
        }
        public var statusBarStyle: UIStatusBarStyle {
            return self.container?.statusBarStyle ?? .default
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            return self.container?.statusBarAnimation ?? .fade
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            return self.container?.supportedOrientations ?? .all
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        public var container: ContentContainer? {
            set(value) {
                guard self._container !== value else { return }
                if let container = self._container {
                    if self.isPresented == true {
                        container.prepareHide(interactive: false)
                        container.finishHide(interactive: false)
                    }
                    container.parent = nil
                }
                self._container = value
                if let container = self._container {
                    self._layout.item = UI.Layout.Item(container.view)
                    container.parent = self
                    if self.isPresented == true {
                        container.prepareShow(interactive: false)
                        container.finishShow(interactive: false)
                    }
                } else {
                    self._layout.item = nil
                }
                if self.isPresented == true {
#if os(iOS)
                    self.setNeedUpdateOrientations()
                    self.setNeedUpdateStatusBar()
#endif
                }
            }
            get { return self._container }
        }
        
        private var _layout: Layout
        private var _view: UI.View.Custom
        private var _container: ContentContainer?
        
        public init(
            container: ContentContainer? = nil
        ) {
            self.isPresented = false
            self._container = container
            self._layout = .init(
                item: container.flatMap({ UI.Layout.Item($0.view) })
            )
            self._view = UI.View.Custom(self._layout)
            self._init()
        }
        
        public convenience init<
            Screen : IUIScreen & IUIScreenViewable
        >(
            screen: Screen
        ) {
            self.init(
                container: UI.Container.Screen(screen)
            )
        }
        
        public func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat {
            return self.inheritedInsets(interactive: interactive)
        }
        
        public func didChangeInsets() {
            self.container?.didChangeInsets()
        }
        
        public func activate() -> Bool {
            guard let container = self.container else { return false }
            return container.activate()
        }
        
        public func didChangeAppearance() {
            self.container?.didChangeAppearance()
        }
        
        public func prepareShow(interactive: Bool) {
            self.container?.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.container?.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.container?.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.container?.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.container?.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.container?.cancelHide(interactive: interactive)
        }
        
    }
    
}

extension UI.Container.State : IUIRootContentContainer {
}

private extension UI.Container.State {
    
    func _init() {
        self.container?.parent = self
    }
    
}
