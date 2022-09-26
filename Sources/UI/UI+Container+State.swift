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
            return self.content?.shouldInteractive ?? false
        }
#if os(iOS)
        public var statusBar: UIStatusBarStyle {
            return self.content?.statusBar ?? .default
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            return self.content?.statusBarAnimation ?? .fade
        }
        public var statusBarHidden: Bool {
            return self.content?.statusBarHidden ?? false
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            return self.content?.supportedOrientations ?? .all
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        public var content: ContentContainer? {
            set(value) {
                guard self._content !== value else { return }
                if let content = self._content {
                    if self.isPresented == true {
                        content.prepareHide(interactive: false)
                        content.finishHide(interactive: false)
                    }
                    content.parent = nil
                }
                self._content = value
                if let content = self._content {
                    self._layout.content = UI.Layout.Item(content.view)
                    content.parent = self
                    if self.isPresented == true {
                        content.prepareShow(interactive: false)
                        content.finishShow(interactive: false)
                    }
                } else {
                    self._layout.content = nil
                }
                if self.isPresented == true {
#if os(iOS)
                    self.setNeedUpdateOrientations()
                    self.setNeedUpdateStatusBar()
#endif
                }
            }
            get { return self._content }
        }
        
        private var _layout: Layout
        private var _view: UI.View.Custom
        private var _content: ContentContainer?
        
        public init(
            _ content: ContentContainer? = nil
        ) {
            self.isPresented = false
            self._content = content
            self._layout = .init(content.flatMap({ UI.Layout.Item($0.view) }))
            self._view = UI.View.Custom(self._layout)
            self._setup()
        }
        
        public convenience init<
            Screen : IUIScreen & IUIScreenViewable
        >(
            _ screen: Screen
        ) {
            self.init(UI.Container.Screen(screen))
        }
        
        public func insets(of content: IUIContainer, interactive: Bool) -> InsetFloat {
            return self.inheritedInsets(interactive: interactive)
        }
        
        public func didChangeInsets() {
            self.content?.didChangeInsets()
        }
        
        public func activate() -> Bool {
            guard let content = self.content else { return false }
            return content.activate()
        }
        
        public func didChangeAppearance() {
            self.content?.didChangeAppearance()
        }
        
        public func prepareShow(interactive: Bool) {
            self.content?.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.content?.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.content?.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.content?.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.content?.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.content?.cancelHide(interactive: interactive)
        }
        
    }
    
}

extension UI.Container.State : IUIRootContentContainer {
}

private extension UI.Container.State {
    
    func _setup() {
        self.content?.parent = self
    }
    
}
