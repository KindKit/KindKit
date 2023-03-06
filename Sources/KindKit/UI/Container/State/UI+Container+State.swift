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
        
        public weak var parent: IUIContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if let parent = self.parent {
                    if parent.isPresented == true {
                        self.refreshParentInset()
                    }
                } else {
                    self.refreshParentInset()
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
            set {
                guard self._content !== newValue else { return }
                if let content = self._content {
                    if self.isPresented == true {
                        content.prepareHide(interactive: false)
                        content.finishHide(interactive: false)
                        content.refreshParentInset()
                    }
                    content.parent = nil
                }
                self._content = newValue
                if let content = self._content {
                    self._layout.content = content.view
                    content.parent = self
                    if self.isPresented == true {
                        content.refreshParentInset()
                        content.prepareShow(interactive: false)
                        content.finishShow(interactive: false)
                    }
                } else {
                    self._layout.content = nil
                }
                if self.isPresented == true {
#if os(iOS)
                    self.refreshOrientations()
                    self.refreshStatusBar()
#endif
                }
            }
            get { self._content }
        }
        
        private var _layout: Layout
        private var _view: UI.View.Custom
        private var _content: ContentContainer?
        
        public init(
            _ content: ContentContainer? = nil
        ) {
            self.isPresented = false
            self._content = content
            self._layout = .init(content?.view)
            self._view = UI.View.Custom()
                .content(self._layout)
            self._setup()
        }
        
        @inlinable
        public convenience init<
            Screen : IUIScreen & IUIScreenViewable
        >(
            _ screen: Screen
        ) {
            self.init(UI.Container.Screen(screen))
        }
        
        public func apply(contentInset: UI.Container.AccumulateInset) {
            self.content?.apply(contentInset: contentInset)
        }
        
        public func parentInset(for container: IUIContainer) -> UI.Container.AccumulateInset {
            return self.parentInset()
        }
        
        public func contentInset() -> UI.Container.AccumulateInset {
            guard let content = self._content else { return .zero }
            return content.contentInset()
        }
        
        public func refreshParentInset() {
            self.content?.refreshParentInset()
        }
        
        public func activate() -> Bool {
            guard let content = self.content else { return false }
            return content.activate()
        }
        
#if os(iOS)
        
        public func snake() -> Bool {
            guard let content = self.content else { return false }
            return content.snake()
        }
        
#endif
        
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
