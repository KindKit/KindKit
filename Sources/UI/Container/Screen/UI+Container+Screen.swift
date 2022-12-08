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
        
        private let _layout: Layout
        private let _view: UI.View.Custom
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
            self._layout = Layout()
            self._view = UI.View.Custom()
                .content(self._layout)
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func apply(contentInset: UI.Container.AccumulateInset) {
        }
        
        public func contentInset() -> UI.Container.AccumulateInset {
#if os(macOS)
            return .zero
#elseif os(iOS)
            return .init(
                top: 0,
                left: 0,
                right: 0,
                bottom: self._virtualKeyboardHeight
            )
#endif
        }
        
        public func parentInset(for container: IUIContainer) -> UI.Container.AccumulateInset {
            let parentInset = self.parentInset()
#if os(macOS)
            return parentInset
#elseif os(iOS)
            return parentInset.bottom(
                natural: max(self._virtualKeyboardHeight, parentInset.natural.bottom),
                interactive: max(self._virtualKeyboardHeight, parentInset.interactive.bottom)
            )
#endif
        }
        
        public func refreshParentInset() {
#if os(macOS)
            let parentInset = self.parentInset()
#elseif os(iOS)
            let baseParentInset = self.parentInset()
            let parentInset = baseParentInset.bottom(
                natural: max(self._virtualKeyboardHeight, baseParentInset.natural.bottom),
                interactive: max(self._virtualKeyboardHeight, baseParentInset.interactive.bottom)
            )
#endif
            self.refreshContentInset()
            let overlayEdge = self.screen.overlayEdge
            self._layout.inset = .init(
                top: overlayEdge.contains(.top) == false ? parentInset.interactive.top : 0,
                left: overlayEdge.contains(.left) == false ? parentInset.interactive.left : 0,
                right: overlayEdge.contains(.right) == false ? parentInset.interactive.right : 0,
                bottom: overlayEdge.contains(.bottom) == false ? parentInset.interactive.bottom : 0
            )
            self.screen.apply(inset: parentInset)
        }
        
        public func activate() -> Bool {
            guard self.isPresented == true else { return false }
            return self.screen.activate()
        }
        
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
    }
    
    func _destroy() {
#if os(iOS)
        self._unsubscribeVirtualKeyboard()
#endif
        self.screen.container = nil
        self.screen.destroy()
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
    
    public var modalCornerRadius: UI.CornerRadius {
        return self.screen.modalCornerRadius
    }
    
    public var modalSheetInset: Inset? {
        switch self.screen.modalPresentation {
        case .simple: return nil
        case .sheet(let info): return info.inset
        }
    }
    
    public var modalSheetBackground: (IUIView & IUIViewAlphable)? {
        switch self.screen.modalPresentation {
        case .simple: return nil
        case .sheet(let info): return info.background
        }
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
