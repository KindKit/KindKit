//
//  KindKit
//

import KindAnimation
import KindUI

public extension Container {
    
    final class State : IStateContainer {
        
        public weak var parent: IContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if let parent = self.parent {
                    if parent.isPresented == true {
                        self.refreshParentInset()
#if os(iOS)
                        self.orientation = parent.orientation
#endif
                    }
                } else {
                    self.refreshParentInset()
#if os(iOS)
                    self.orientation = .unknown
#endif
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
        public var orientation: UIInterfaceOrientation = .unknown {
            didSet {
                guard self.orientation != oldValue else { return }
                self.content?.didChange(orientation: self.orientation)
            }
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IView {
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
        private var _view: CustomView
        private var _content: ContentContainer?
        
        public init(
            _ content: ContentContainer? = nil
        ) {
            self.isPresented = false
            self._content = content
            self._layout = .init(content?.view)
            self._view = CustomView()
                .content(self._layout)
            self._setup()
        }
        
        @inlinable
        public convenience init<
            Screen : IScreen & IScreenViewable
        >(
            _ screen: Screen
        ) {
            self.init(Container.Screen(screen))
        }
        
        public func apply(contentInset: Container.AccumulateInset) {
            self.content?.apply(contentInset: contentInset)
        }
        
        public func parentInset(for container: IContainer) -> Container.AccumulateInset {
            return self.parentInset()
        }
        
        public func contentInset() -> Container.AccumulateInset {
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
        
#if os(iOS)
        
        public func didChange(orientation: UIInterfaceOrientation) {
            self.orientation = orientation
        }
        
#endif
        
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
        
        public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
        public func close(container: IContainer, animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
    }
    
}

extension Container.State : IRootContentContainer {
}

private extension Container.State {
    
    func _setup() {
        self.content?.parent = self
    }
    
}
