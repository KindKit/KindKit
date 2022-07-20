//
//  KindKitView
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindKitCore
import KindKitMath

public final class ModalContainer : IModalContainer {
    
    public unowned var parent: IContainer? {
        didSet(oldValue) {
            guard self.parent !== oldValue else { return }
            if self.parent == nil || self.parent?.isPresented == true {
                self.didChangeInsets()
            }
        }
    }
    public var shouldInteractive: Bool {
        return self.contentContainer?.shouldInteractive ?? false
    }
    #if os(iOS)
    public var statusBarHidden: Bool {
        guard let current = self._current else {
            return self.contentContainer?.statusBarHidden ?? false
        }
        return current.container.statusBarHidden
    }
    public var statusBarStyle: UIStatusBarStyle {
        guard let current = self._current else {
            return self.contentContainer?.statusBarStyle ?? .default
        }
        return current.container.statusBarStyle
    }
    public var statusBarAnimation: UIStatusBarAnimation {
        guard let current = self._current else {
            return self.contentContainer?.statusBarAnimation ?? .fade
        }
        return current.container.statusBarAnimation
    }
    public var supportedOrientations: UIInterfaceOrientationMask {
        guard let current = self._current else {
            return self.contentContainer?.supportedOrientations ?? .all
        }
        return current.container.supportedOrientations
    }
    #endif
    public private(set) var isPresented: Bool
    public var view: IView {
        return self._view
    }
    public var contentContainer: (IContainer & IContainerParentable)? {
        didSet(oldValue) {
            if let contentContainer = self.contentContainer {
                if self.isPresented == true {
                    contentContainer.prepareHide(interactive: false)
                    contentContainer.finishHide(interactive: false)
                }
                contentContainer.parent = nil
            }
            self._view.contentLayout.contentItem = self.contentContainer.flatMap({ LayoutItem(view: $0.view) })
            if let contentContainer = self.contentContainer {
                contentContainer.parent = self
                if self.isPresented == true {
                    contentContainer.prepareHide(interactive: false)
                    contentContainer.finishHide(interactive: false)
                }
            }
        }
    }
    public var containers: [IModalContentContainer] {
        return self._items.compactMap({ return $0.container })
    }
    public var previousContainer: IModalContentContainer? {
        return self._previous?.container
    }
    public var currentContainer: IModalContentContainer? {
        return self._current?.container
    }
    public var animationVelocity: Float
    #if os(iOS)
    public var interactiveLimit: Float
    #endif
    
    private var _view: CustomView< Layout >
    #if os(iOS)
    private var _interactiveGesture: PanGesture
    private var _interactiveBeginLocation: PointFloat?
    #endif
    private var _items: [Item]
    private var _previous: Item?
    private var _current: Item? {
        didSet {
            #if os(iOS)
            self._interactiveGesture.isEnabled = self._current != nil
            #endif
        }
    }
    
    public init(
        contentContainer: (IContainer & IContainerParentable)? = nil
    ) {
        self.isPresented = false
        self.contentContainer = contentContainer
        #if os(macOS)
        self.animationVelocity = NSScreen.main!.animationVelocity
        self._view = CustomView(
            contentLayout: Layout(
                contentItem: contentContainer.flatMap({ LayoutItem(view: $0.view) }),
                state: .empty
            )
        )
        #elseif os(iOS)
        self.animationVelocity = Float(max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 3)
        self.interactiveLimit = 20
        self._interactiveGesture = PanGesture(
            isEnabled: false
        )
        self._view = CustomView(
            gestures: [ self._interactiveGesture ],
            contentLayout: Layout(
                contentItem: contentContainer.flatMap({ LayoutItem(view: $0.view) }),
                state: .empty
            )
        )
        #endif
        self._items = []
        self._init()
    }
    
    public func insets(of container: IContainer, interactive: Bool) -> InsetFloat {
        let inheritedInsets = self.inheritedInsets(interactive: interactive)
        if let current = self._current?.container {
            if current.modalSheetInset != nil {
                return InsetFloat(top: 0, left: inheritedInsets.left, right: inheritedInsets.right, bottom: inheritedInsets.bottom)
            }
        }
        return inheritedInsets
    }
    
    public func didChangeInsets() {
        self._view.contentLayout.inset = self.inheritedInsets(interactive: false)
        self.contentContainer?.didChangeInsets()
        for container in self.containers {
            container.didChangeInsets()
        }
    }
    
    public func activate() -> Bool {
        if let current = self._current?.container {
            if current.activate() == true {
                return true
            }
        }
        if let contentContainer = self.contentContainer {
            return contentContainer.activate()
        }
        return false
    }
    
    public func didChangeAppearance() {
        for container in self.containers {
            container.didChangeAppearance()
        }
        if let contentContainer = self.contentContainer {
            contentContainer.didChangeAppearance()
        }
    }
    
    public func prepareShow(interactive: Bool) {
        self.contentContainer?.prepareShow(interactive: interactive)
        self.currentContainer?.prepareShow(interactive: interactive)
    }
    
    public func finishShow(interactive: Bool) {
        self.isPresented = true
        self.contentContainer?.finishShow(interactive: interactive)
        self.currentContainer?.finishShow(interactive: interactive)
    }
    
    public func cancelShow(interactive: Bool) {
        self.contentContainer?.cancelShow(interactive: interactive)
        self.currentContainer?.cancelShow(interactive: interactive)
    }
    
    public func prepareHide(interactive: Bool) {
        self.contentContainer?.prepareHide(interactive: interactive)
        self.currentContainer?.prepareHide(interactive: interactive)
    }
    
    public func finishHide(interactive: Bool) {
        self.isPresented = false
        self.contentContainer?.finishHide(interactive: interactive)
        self.currentContainer?.finishHide(interactive: interactive)
    }
    
    public func cancelHide(interactive: Bool) {
        self.contentContainer?.cancelHide(interactive: interactive)
        self.currentContainer?.cancelHide(interactive: interactive)
    }
    
    public func present(container: IModalContentContainer, animated: Bool, completion: (() -> Void)?) {
        container.parent = self
        let item = Item(container: container)
        self._items.append(item)
        if self._current == nil {
            self._present(modal: item, animated: animated, completion: completion)
        } else {
            completion?()
        }
    }
    
    public func dismiss(container: IModalContentContainer, animated: Bool, completion: (() -> Void)?) {
        guard let index = self._items.firstIndex(where: { $0.container === container }) else {
            completion?()
            return
        }
        let item = self._items[index]
        if self._current === item {
            self._items.remove(at: index)
            self._previous = self._items.first
            self._dismiss(current: item, previous: self._previous, animated: animated, completion: {
                container.parent = nil
                completion?()
            })
        } else {
            container.parent = nil
            self._items.remove(at: index)
            completion?()
        }
    }

}

extension ModalContainer : IRootContentContainer {
}

private extension ModalContainer {
    
    func _init() {
        #if os(iOS)
        self._interactiveGesture.onShouldRequireFailure({ [unowned self] gesture -> Bool in
            guard let view = gesture.view else { return false }
            if let container = self._current?.container {
                return container.view.native.isChild(of: view, recursive: true)
            }
            return false
        }).onShouldBeRequiredToFailBy({ [unowned self] gesture -> Bool in
            guard let view = gesture.view else { return false }
            if let container = self.contentContainer {
                return container.view.native.isChild(of: view, recursive: true)
            }
            return false
        }).onShouldBegin({ [unowned self] in
            guard let current = self._current else { return false }
            guard current.container.shouldInteractive == true else { return false }
            return self._interactiveGesture.contains(in: current.container.view)
        }).onBegin({ [unowned self] in
            self._beginInteractiveGesture()
        }) .onChange({ [unowned self] in
            self._changeInteractiveGesture()
        }).onCancel({ [unowned self] in
            self._endInteractiveGesture(true)
        }).onEnd({ [unowned self] in
            self._endInteractiveGesture(false)
        })
        #endif
        self.contentContainer?.parent = self
    }
    
    func _present(current: Item?, next: Item, animated: Bool, completion: (() -> Void)?) {
        if let current = current {
            self._dismiss(modal: current, animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self._present(modal: next, animated: animated, completion: completion)
            })
        } else {
            self._present(modal: next, animated: animated, completion: completion)
        }
    }

    func _present(modal: Item, animated: Bool, completion: (() -> Void)?) {
        self._current = modal
        if animated == true {
            self._view.contentLayout.state = .present(modal: modal, progress: .zero)
            modal.container.prepareShow(interactive: false)
            Animation.default.run(
                duration: TimeInterval(self._view.bounds.size.height / self.animationVelocity),
                ease: Animation.Ease.QuadraticInOut(),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._view.contentLayout.state = .present(modal: modal, progress: progress)
                    self._view.contentLayout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    modal.container.finishShow(interactive: false)
                    self._view.contentLayout.state = .idle(modal: modal)
                    completion?()
                }
            )
        } else {
            self._view.contentLayout.state = .idle(modal: modal)
            modal.container.prepareShow(interactive: false)
            modal.container.finishShow(interactive: false)
            completion?()
        }
    }

    func _dismiss(current: Item, previous: Item?, animated: Bool, completion: (() -> Void)?) {
        self._dismiss(modal: current, animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            self._current = previous
            if let previous = previous {
                self._present(modal: previous, animated: animated, completion: completion)
            } else {
                completion?()
            }
        })
    }
    
    func _dismiss(modal: Item, animated: Bool, completion: (() -> Void)?) {
        modal.container.prepareHide(interactive: false)
        if animated == true {
            Animation.default.run(
                duration: TimeInterval(self._view.bounds.size.height / self.animationVelocity),
                ease: Animation.Ease.QuadraticInOut(),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._view.contentLayout.state = .dismiss(modal: modal, progress: progress)
                    self._view.contentLayout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    modal.container.finishHide(interactive: false)
                    self._view.contentLayout.state = .empty
                    completion?()
                }
            )
        } else {
            modal.container.finishHide(interactive: false)
            self._view.contentLayout.state = .empty
            completion?()
        }
    }
    
}

#if os(iOS)

private extension ModalContainer {
    
    func _beginInteractiveGesture() {
        guard let current = self._current else { return }
        self._interactiveBeginLocation = self._interactiveGesture.location(in: self._view)
        current.container.prepareHide(interactive: true)
    }
    
    func _changeInteractiveGesture() {
        guard let beginLocation = self._interactiveBeginLocation, let current = self._current else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation.y - beginLocation.y
        if deltaLocation > 0 {
            let progress = Percent(deltaLocation / self._view.bounds.size.height)
            self._view.contentLayout.state = .dismiss(modal: current, progress: progress)
        } else {
            self._view.contentLayout.state = .idle(modal: current)
        }
    }

    func _endInteractiveGesture(_ canceled: Bool) {
        guard let beginLocation = self._interactiveBeginLocation, let current = self._current else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation.y - beginLocation.y
        if deltaLocation > self.interactiveLimit {
            let height = self._view.bounds.size.height
            Animation.default.run(
                duration: TimeInterval(height / self.animationVelocity),
                elapsed: TimeInterval(deltaLocation / self.animationVelocity),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._view.contentLayout.state = .dismiss(modal: current, progress: progress)
                    self._view.contentLayout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._finishInteractiveAnimation()
                }
            )
        } else if deltaLocation > 0 {
            let height = self._view.bounds.size.height
            let baseProgress = Percent(deltaLocation / pow(height, 1.5))
            Animation.default.run(
                duration: TimeInterval((height * baseProgress.value) / self.animationVelocity),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._view.contentLayout.state = .present(modal: current, progress: .one + (baseProgress - (baseProgress * progress)))
                    self._view.contentLayout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._cancelInteractiveAnimation()
                }
            )
        } else {
            self._view.contentLayout.state = .idle(modal: current)
            self._cancelInteractiveAnimation()
        }
    }
    
    func _finishInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        if let current = self._current {
            current.container.finishHide(interactive: true)
            current.container.parent = nil
            if let index = self._items.firstIndex(where: { $0 === current }) {
                self._items.remove(at: index)
            }
            self._previous = self._items.first
            if let previous = self._previous {
                self._present(modal: previous, animated: true, completion: nil)
            } else {
                self._current = nil
                self._view.contentLayout.state = .empty
            }
        } else {
            self._current = nil
            self._view.contentLayout.state = .empty
        }
    }
    
    func _cancelInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        if let current = self._current {
            current.container.cancelHide(interactive: true)
            self._view.contentLayout.state = .idle(modal: current)
        } else {
            self._view.contentLayout.state = .empty
        }
    }
    
}
    
#endif

private extension ModalContainer {
    
    final class Item {
        
        var container: IModalContentContainer
        var item: LayoutItem
        var sheetInset: InsetFloat?
        var sheetBackgroundView: (IView & IViewAlphable)?
        var sheetBackgroundItem: LayoutItem?

        convenience init(container: IModalContentContainer) {
            self.init(
                container: container,
                item: LayoutItem(view: container.view),
                sheetInset: container.modalSheetInset,
                sheetBackgroundView: container.modalSheetBackgroundView
            )
        }
        
        init(
            container: IModalContentContainer,
            item: LayoutItem,
            sheetInset: InsetFloat?,
            sheetBackgroundView: (IView & IViewAlphable)?
        ) {
            self.container = container
            self.item = item
            self.sheetInset = sheetInset
            self.sheetBackgroundView = sheetBackgroundView
            self.sheetBackgroundItem = sheetBackgroundView.flatMap({ LayoutItem(view: $0) })
        }

    }
    
}

private extension ModalContainer {
    
    final class Layout : ILayout {
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var inset: InsetFloat {
            didSet { self.setNeedUpdate() }
        }
        var contentItem: LayoutItem? {
            didSet { self.setNeedUpdate() }
        }
        var state: State {
            didSet { self.setNeedUpdate() }
        }

        init(
            contentItem: LayoutItem?,
            state: State
        ) {
            self.inset = .zero
            self.contentItem = contentItem
            self.state = state
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let contentItem = self.contentItem {
                contentItem.frame = bounds
            }
            switch self.state {
            case .empty:
                break
            case .idle(let modal):
                if let sheetInset = modal.sheetInset, let view = modal.sheetBackgroundView, let item = modal.sheetBackgroundItem {
                    let inset = InsetFloat(
                        top: self.inset.top + sheetInset.top,
                        left: sheetInset.left,
                        right: sheetInset.right,
                        bottom: sheetInset.bottom
                    )
                    modal.item.frame = bounds.inset(inset)
                    view.alpha = 1
                    item.frame = bounds
                } else {
                    modal.item.frame = bounds
                }
            case .present(let modal, let progress):
                if let sheetInset = modal.sheetInset, let view = modal.sheetBackgroundView, let item = modal.sheetBackgroundItem {
                    let inset = InsetFloat(
                        top: self.inset.top + sheetInset.top,
                        left: sheetInset.left,
                        right: sheetInset.right,
                        bottom: sheetInset.bottom
                    )
                    let beginRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    let endRect = bounds.inset(inset)
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
                    view.alpha = progress.value
                    item.frame = bounds
                } else {
                    let beginRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    let endRect = bounds
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
                }
            case .dismiss(let modal, let progress):
                if let sheetInset = modal.sheetInset, let view = modal.sheetBackgroundView, let item = modal.sheetBackgroundItem {
                    let inset = InsetFloat(
                        top: self.inset.top + sheetInset.top,
                        left: sheetInset.left,
                        right: sheetInset.right,
                        bottom: sheetInset.bottom
                    )
                    let beginRect = bounds.inset(inset)
                    let endRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
                    view.alpha = progress.invert.value
                    item.frame = bounds
                } else {
                    let beginRect = bounds
                    let endRect = RectFloat(topLeft: bounds.bottomLeft, size: bounds.size)
                    modal.item.frame = beginRect.lerp(endRect, progress: progress)
                }
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            var items: [LayoutItem] = []
            if let contentItem = self.contentItem {
                items.append(contentItem)
            }
            switch self.state {
            case .empty: break
            case .idle(let modal):
                if let item = modal.sheetBackgroundItem {
                    items.append(item)
                }
                items.append(modal.item)
            case .present(let modal, _):
                if let item = modal.sheetBackgroundItem {
                    items.append(item)
                }
                items.append(modal.item)
            case .dismiss(let modal, _):
                if let item = modal.sheetBackgroundItem {
                    items.append(item)
                }
                items.append(modal.item)
            }
            return items
        }
        
    }
    
}

private extension ModalContainer.Layout {
    
    enum State {
        case empty
        case idle(modal: ModalContainer.Item)
        case present(modal: ModalContainer.Item, progress: PercentFloat)
        case dismiss(modal: ModalContainer.Item, progress: PercentFloat)
    }
    
}
