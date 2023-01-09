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
    
    final class Screen< Screen : IUIScreen & IUIScreenViewable > : IUIScreenContainer, IUIContainerScreenable {
        
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
        
        public func apply(contentInset: UI.Container.AccumulateInset) {
        }
        
        public func contentInset() -> UI.Container.AccumulateInset {
            return self._contentInset()
        }
        
        public func parentInset(for container: IUIContainer) -> UI.Container.AccumulateInset {
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
        
        public func prepareShow(interactive: Bool) {
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
            self.screen.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.screen.cancelHide(interactive: interactive)
        }
        
    }
    
}

private extension UI.Container.Screen {
    
    func _setup() {
#if os(iOS)
        self._subscribeVirtualKeyboard()
#endif
        self.screen.container = self
        self.screen.setup()
        
        self._layout.content = self.screen.view
        self._layout.bar = self.screen.bar
        self._view.content = self._layout
    }
    
    func _destroy() {
#if os(iOS)
        self._unsubscribeVirtualKeyboard()
#endif
        self.screen.container = nil
        self.screen.destroy()
    }
    
    func _contentInset() -> UI.Container.AccumulateInset {
#if os(macOS)
        let contentInset = UI.Container.AccumulateInset(
            self.screen.additionalContentInset
        )
#elseif os(iOS)
        let contentInset = UI.Container.AccumulateInset(
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
                    natural: .init(
                        top: contentInset.natural.top + barSize.height,
                        left: contentInset.natural.left,
                        right: contentInset.natural.right,
                        bottom: contentInset.natural.bottom
                    ),
                    interactive: .init(
                        top: contentInset.interactive.top + barSize.height,
                        left: contentInset.interactive.left,
                        right: contentInset.interactive.right,
                        bottom: contentInset.interactive.bottom
                    )
                )
            case .bottom:
                let barSize = self._layout.barSize ?? .zero
                return .init(
                    natural: .init(
                        top: contentInset.natural.top,
                        left: contentInset.natural.left,
                        right: contentInset.natural.right,
                        bottom: contentInset.natural.bottom + barSize.height
                    ),
                    interactive: .init(
                        top: contentInset.interactive.top,
                        left: contentInset.interactive.left,
                        right: contentInset.interactive.right,
                        bottom: contentInset.interactive.bottom + barSize.height
                    )
                )
            }
        } else {
            return contentInset
        }
    }
    
    func _parentInset(for container: IUIContainer) -> UI.Container.AccumulateInset {
#if os(iOS)
        let baseParentInset = self.parentInset()
        let parentInset = UI.Container.AccumulateInset(
            natural: .init(
                top: baseParentInset.natural.top,
                left: baseParentInset.natural.left,
                right: baseParentInset.natural.right,
                bottom: max(self._virtualKeyboardHeight, baseParentInset.natural.bottom)
            ),
            interactive: .init(
                top: baseParentInset.interactive.top,
                left: baseParentInset.interactive.left,
                right: baseParentInset.interactive.right,
                bottom: max(self._virtualKeyboardHeight, baseParentInset.interactive.bottom)
            )
        )
#else
        let parentInset = self.parentInset()
#endif
        if let bar = self.screen.bar {
            let barSize = self._layout.barSize ?? .zero
            switch bar.placement {
            case .top:
                return .init(
                    natural: .init(
                        top: barSize.height,
                        left: parentInset.natural.left,
                        right: parentInset.natural.right,
                        bottom: parentInset.natural.bottom
                    ),
                    interactive: .init(
                        top: barSize.height,
                        left: parentInset.interactive.left,
                        right: parentInset.interactive.right,
                        bottom: parentInset.interactive.bottom
                    )
                )
            case .bottom:
                return .init(
                    natural: .init(
                        top: parentInset.natural.top,
                        left: parentInset.natural.left,
                        right: parentInset.natural.right,
                        bottom: barSize.height
                    ),
                    interactive: .init(
                        top: parentInset.interactive.top,
                        left: parentInset.interactive.left,
                        right: parentInset.interactive.right,
                        bottom: barSize.height
                    )
                )
            }
        } else {
            return parentInset
        }
    }
    
    func _refreshParentInset() {
#if os(iOS)
        let baseParentInset = self.parentInset()
        let parentInset = UI.Container.AccumulateInset(
            natural: .init(
                top: baseParentInset.natural.top,
                left: baseParentInset.natural.left,
                right: baseParentInset.natural.right,
                bottom: max(self._virtualKeyboardHeight, baseParentInset.natural.bottom)
            ),
            interactive: .init(
                top: baseParentInset.interactive.top,
                left: baseParentInset.interactive.left,
                right: baseParentInset.interactive.right,
                bottom: max(self._virtualKeyboardHeight, baseParentInset.interactive.bottom)
            )
        )
#else
        let parentInset = self.parentInset()
#endif
        self.refreshContentInset()
        if let bar = self.screen.bar {
            switch bar.placement {
            case .top:
                bar.safeArea = .init(
                    top: parentInset.natural.top,
                    left: parentInset.natural.left,
                    right: parentInset.natural.right,
                    bottom: 0
                )
            case .bottom:
                bar.safeArea = .init(
                    top: 0,
                    left: parentInset.natural.left,
                    right: parentInset.natural.right,
                    bottom: parentInset.natural.bottom
                )
            }
            self._layout.updateIfNeeded()
            let barSize = self._layout.barSize ?? .zero
            switch bar.placement {
            case .top:
                self.screen.apply(inset: .init(
                    natural: .init(
                        top: barSize.height,
                        left: parentInset.natural.left,
                        right: parentInset.natural.right,
                        bottom: parentInset.natural.bottom
                    ),
                    interactive: .init(
                        top: barSize.height,
                        left: parentInset.interactive.left,
                        right: parentInset.interactive.right,
                        bottom: parentInset.interactive.bottom
                    )
                ))
            case .bottom:
                self.screen.apply(inset: .init(
                    natural: .init(
                        top: parentInset.natural.top,
                        left: parentInset.natural.left,
                        right: parentInset.natural.right,
                        bottom: barSize.height
                    ),
                    interactive: .init(
                        top: parentInset.interactive.top,
                        left: parentInset.interactive.left,
                        right: parentInset.interactive.right,
                        bottom: barSize.height
                    )
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
        guard abs(self._virtualKeyboardHeight - height) > .leastNonzeroMagnitude else { return }
        self._virtualKeyboardAnimation?.cancel()
        self._virtualKeyboardAnimation = Animation.default.run(
            .custom(
                duration: duration,
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._virtualKeyboardHeight = self._virtualKeyboardHeight.lerp(height, progress: progress)
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

extension UI.Container.Screen : IUIStackContentContainer where Screen : IUIScreenStackable {
    
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

extension UI.Container.Screen : IUIGroupContentContainer where Screen : IUIScreenGroupable {
    
    public var groupItem: UI.View.GroupBar.Item {
        return self.screen.groupItem
    }
    
}

extension UI.Container.Screen : IUIPageContentContainer where Screen : IUIScreenPageable {
    
    public var pageItem: UI.View.PageBar.Item {
        return self.screen.pageItem
    }
    
}

extension UI.Container.Screen : IUIBookContentContainer where Screen : IUIScreenBookable {
    
    public var bookIdentifier: Any {
        return self.screen.bookIdentifier
    }
    
}

extension UI.Container.Screen : IUIHamburgerContentContainer {
}

extension UI.Container.Screen : IHamburgerMenuContainer where Screen : IUIScreenHamburgerable {
    
    public var hamburgerSize: Double {
        return self.screen.hamburgerSize
    }
    
    public var hamburgerLimit: Double {
        return self.screen.hamburgerLimit
    }
    
}

extension UI.Container.Screen : IUIModalContentContainer where Screen : IUIScreenModalable {
    
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

extension UI.Container.Screen : IUIDialogContentContainer where Screen : IUIScreenDialogable {
    
    public var dialogInset: Inset {
        return self.screen.dialogInset
    }
    
    public var dialogWidth: DialogContentContainerSize {
        return self.screen.dialogWidth
    }
    
    public var dialogHeight: DialogContentContainerSize {
        return self.screen.dialogHeight
    }
    
    public var dialogAlignment: DialogContentContainerAlignment {
        return self.screen.dialogAlignment
    }
    
    public var dialogBackground: (IUIView & IUIViewAlphable)? {
        return self.screen.dialogBackgroundView
    }
    
}

extension UI.Container.Screen : IUIPushContentContainer where Screen : IUIScreenPushable {
    
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
