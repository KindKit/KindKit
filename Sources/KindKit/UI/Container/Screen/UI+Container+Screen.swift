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
    
    final class Screen< Screen : IScreen & IScreenViewable > : IScreenContainer, IUIContainerScreenable {
        
        public weak var parent: IUIContainer? {
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
            return self.screen.shouldInteractive
        }
#if os(iOS)
        public var statusBar: UIStatusBarStyle {
            return self.screen.statusBar
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            return self.screen.statusBarAnimation
        }
        public var statusBarHidden: Bool {
            return self.screen.statusBarHidden
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            return self.screen.supportedOrientations
        }
        public var orientation: UIInterfaceOrientation = .unknown {
            didSet {
                guard self.orientation != oldValue else { return }
                self.screen.didChange(orientation: self.orientation)
            }
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        public let screen: Screen
        
        private let _layout = Layout()
        private let _view = UI.View.Custom()
#if os(iOS)
        private var _virtualKeyboard = VirtualKeyboard()
        private var _virtualKeyboardAnchor: Double = 0
        private var _virtualKeyboardHeight: Double = 0 {
            didSet {
                guard self._virtualKeyboardHeight != oldValue else { return }
                self.refreshParentInset()
            }
        }
        private var _virtualKeyboardAnimation: ICancellable? {
            willSet { self._virtualKeyboardAnimation?.cancel() }
        }
#endif
        
        public init(
            _ screen: Screen
        ) {
            self.isPresented = false
            self.screen = screen
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func apply(contentInset: Inset) {
        }
        
        public func contentInset() -> Inset {
            return self._contentInset()
        }
        
        public func parentInset(for container: IUIContainer) -> UI.Container.InheritedInset {
            return self._parentInset(for: container)
        }
        
        public func refreshParentInset() {
            return self._refreshParentInset()
        }
        
        public func activate() -> Bool {
            guard self.isPresented == true else { return false }
            return self.screen.activate()
        }
        
#if os(iOS)
        
        public func snake() -> Bool {
            guard self.isPresented == true else { return false }
            return self.screen.snake()
        }
        
#endif
        
        public func didChangeAppearance() {
            self.screen.didChangeAppearance()
        }
        
#if os(iOS)
        
        public func didChange(orientation: UIInterfaceOrientation) {
            self.orientation = orientation
        }
        
#endif
        
        public func prepareShow(interactive: Bool) {
#if os(iOS)
            UIApplication.shared.kk_endEditing(false)
            self._subscribeVirtualKeyboard()
#endif
            self.screen.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.screen.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.screen.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.screen.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
#if os(iOS)
            self._unsubscribeVirtualKeyboard()
#endif
            self.screen.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.screen.cancelHide(interactive: interactive)
        }
        
        public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
        public func close(container: IUIContainer, animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
    }
    
}

private extension UI.Container.Screen {
    
    func _setup() {
        self.screen.container = self
        self.screen.setup()
        
        self._layout.content = self.screen.view
        self._layout.bar = self.screen.bar
        self._view.content = self._layout
    }
    
    func _destroy() {
        self.screen.container = nil
        self.screen.destroy()
    }
    
    func _contentInset() -> Inset {
#if os(macOS)
        let contentInset = self.screen.additionalContentInset
#elseif os(iOS)
        let contentInset = Inset(
            top: self.screen.additionalContentInset.top,
            left: self.screen.additionalContentInset.left,
            right: self.screen.additionalContentInset.right,
            bottom: self.screen.additionalContentInset.bottom + self._virtualKeyboardHeight
        )
#endif
        if let bar = self.screen.bar {
            switch bar.placement {
            case .top:
                let barSize = self._layout.barSize ?? .zero
                return .init(
                    top: contentInset.top + barSize.height,
                    left: contentInset.left,
                    right: contentInset.right,
                    bottom: contentInset.bottom
                )
            case .bottom:
                let barSize = self._layout.barSize ?? .zero
                return .init(
                    top: contentInset.top,
                    left: contentInset.left,
                    right: contentInset.right,
                    bottom: contentInset.bottom + barSize.height
                )
            }
        } else {
            return contentInset
        }
    }
    
    func _parentInset(for container: IUIContainer) -> UI.Container.InheritedInset {
#if os(iOS)
        let baseParentInset = self.parentInset()
        let parentInset = UI.Container.InheritedInset(
            device: baseParentInset.device,
            virtualKeyboard: .init(
                top: baseParentInset.virtualKeyboard.top,
                left: baseParentInset.virtualKeyboard.left,
                right: baseParentInset.virtualKeyboard.right,
                bottom: max(self._virtualKeyboardHeight, baseParentInset.virtualKeyboard.bottom)
            ),
            content: baseParentInset.content
        )
#else
        let parentInset = self.parentInset()
#endif
        if let bar = self.screen.bar {
            let barSize = self._layout.barSize ?? .zero
            switch bar.placement {
            case .top:
                return .init(
                    device: parentInset.device,
                    virtualKeyboard: parentInset.virtualKeyboard,
                    content: parentInset.content.setting(top: barSize.height)
                )
            case .bottom:
                return .init(
                    device: parentInset.device,
                    virtualKeyboard: parentInset.virtualKeyboard,
                    content: parentInset.content.setting(bottom: barSize.height)
                )
            }
        } else {
            return parentInset
        }
    }
    
    func _refreshParentInset() {
#if os(iOS)
        let baseParentInset = self.parentInset()
        let parentInset = UI.Container.InheritedInset(
            device: baseParentInset.device,
            virtualKeyboard: .init(
                top: baseParentInset.virtualKeyboard.top,
                left: baseParentInset.virtualKeyboard.left,
                right: baseParentInset.virtualKeyboard.right,
                bottom: max(baseParentInset.virtualKeyboard.bottom, self._virtualKeyboardHeight)
            ),
            content: baseParentInset.content
        )
#else
        let parentInset = self.parentInset()
#endif
        self.refreshContentInset()
        if let bar = self.screen.bar {
            do {
                let barInset = parentInset.get([ .device, .virtualKeyboard, .contentStatic ])
                switch bar.placement {
                case .top:
                    bar.safeArea = .init(
                        top: barInset.top,
                        left: barInset.left,
                        right: barInset.right,
                        bottom: 0
                    )
                case .bottom:
                    bar.safeArea = .init(
                        top: 0,
                        left: barInset.left,
                        right: barInset.right,
                        bottom: barInset.bottom
                    )
                }
            }
            self._layout.updateIfNeeded()
            let barSize = self._layout.barSize ?? .zero
            switch bar.placement {
            case .top:
                self.screen.apply(inset: .init(
                    device: parentInset.device,
                    virtualKeyboard: parentInset.virtualKeyboard,
                    content: parentInset.content.setting(top: barSize.height)
                ))
            case .bottom:
                self.screen.apply(inset: .init(
                    device: parentInset.device,
                    virtualKeyboard: parentInset.virtualKeyboard,
                    content: parentInset.content.setting(bottom: barSize.height)
                ))
            }
        } else {
            self.screen.apply(inset: parentInset)
        }
    }
    
#if os(iOS)
    
    func _subscribeVirtualKeyboard() {
        self._virtualKeyboard.add(observer: self, priority: .public)
    }
    
    func _unsubscribeVirtualKeyboard() {
        self._virtualKeyboard.remove(observer: self)
        self._virtualKeyboardAnimation?.cancel()
    }
    
    func _updateVirtualKeyboardHeight(duration: TimeInterval, height: Double) {
        guard abs(self._virtualKeyboardAnchor - height) > .leastNonzeroMagnitude else { return }
        self._virtualKeyboardAnchor = height
        self._virtualKeyboardAnimation?.cancel()
        self._virtualKeyboardAnimation = Animation.default.run(
            .custom(
                duration: duration,
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._virtualKeyboardHeight = self._virtualKeyboardAnchor.lerp(height, progress: progress)
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._virtualKeyboardAnimation = nil
                    self._virtualKeyboardHeight = height
                    self.refreshParentInset()
                }
            )
        )
    }
    
#endif
    
}

#if os(iOS)

extension UI.Container.Screen : IVirtualKeyboardObserver {
    
    public func willShow(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
        self._updateVirtualKeyboardHeight(duration: info.duration, height: info.endFrame.height)
    }
    
    public func didShow(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
    }
    
    public func willHide(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
        self._updateVirtualKeyboardHeight(duration: info.duration, height: 0)
    }
    
    public func didHide(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
    }
    
}

#endif

extension UI.Container.Screen : IUIRootContentContainer {
}

extension UI.Container.Screen : IUIStackContentContainer where Screen : IScreenStackable {
    
    public var stackBar: UI.View.StackBar {
        return self.screen.stackBar
    }
    
    public var stackBarVisibility: Double {
        return max(0, min(self.screen.stackBarVisibility, 1))
    }
    
    public var stackBarHidden: Bool {
        return self.screen.stackBarHidden
    }
    
}

extension UI.Container.Screen : IUIGroupContentContainer where Screen : IScreenGroupable {
    
    public var groupItem: UI.View.GroupBar.Item {
        return self.screen.groupItem
    }
    
}

extension UI.Container.Screen : IUIPageContentContainer where Screen : IScreenPageable {
    
    public var pageItem: UI.View.PageBar.Item {
        return self.screen.pageItem
    }
    
}

extension UI.Container.Screen : IUIBookContentContainer where Screen : IScreenBookable {
    
    public var bookIdentifier: Any {
        return self.screen.bookIdentifier
    }
    
}

extension UI.Container.Screen : IUIHamburgerContentContainer {
}

extension UI.Container.Screen : IHamburgerMenuContainer where Screen : IScreenHamburgerable {
    
    public var hamburgerSize: Double {
        return self.screen.hamburgerSize
    }
    
    public var hamburgerLimit: Double {
        return self.screen.hamburgerLimit
    }
    
}

extension UI.Container.Screen : IUIModalContentContainer where Screen : IScreenModalable {
    
    public var modalColor: UI.Color {
        return self.screen.modalColor
    }
    
    public var modalSheet: UI.Modal.Presentation.Sheet? {
        switch self.screen.modalPresentation {
        case .simple: return nil
        case .sheet(let info): return info
        }
    }
    
    public func modalPressedOutside() {
        self.screen.modalPressedOutside()
    }
    
}

extension UI.Container.Screen : IUIDialogContentContainer where Screen : IScreenDialogable {
    
    public var dialogInset: Inset {
        return self.screen.dialogInset
    }
    
    public var dialogSize: UI.Dialog.Size {
        return self.screen.dialogSize
    }
    
    public var dialogAlignment: UI.Dialog.Alignment {
        return self.screen.dialogAlignment
    }
    
    public var dialogBackground: (IUIView & IUIViewAlphable)? {
        return self.screen.dialogBackgroundView
    }
    
    public func dialogPressedOutside() {
        self.screen.dialogPressedOutside()
    }
    
}

extension UI.Container.Screen : IUIPushContentContainer where Screen : IScreenPushable {
    
    public var pushPlacement: UI.Push.Placement {
        return self.screen.pushPlacement
    }
    
    public var pushOptions: UI.Push.Options {
        return self.screen.pushOptions
    }
    
    public var pushDuration: TimeInterval? {
        return self.screen.pushDuration
    }
    
}
