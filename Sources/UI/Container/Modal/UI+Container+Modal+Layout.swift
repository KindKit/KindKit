//
//  KindKit
//

import Foundation

extension UI.Container.Modal {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var state: State = .empty {
            didSet {
                guard self.state != oldValue else { return }
                if let oldModal = oldValue.modal {
                    if self.state.modal != oldModal {
                        oldModal.reset()
                    }
                }
                self.setNeedUpdate()
            }
        }
        var inset: Inset = .zero {
            didSet {
                guard self.inset != oldValue else { return }
                self.state.modal?.reset()
                self.setNeedUpdate()
            }
        }
        var hook: IUIView {
            didSet {
                guard self.hook !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }

        init(
            _ hook: IUIView,
            _ content: IUIView?
        ) {
            self.hook = hook
            self.content = content
        }
        
        public func invalidate() {
            self.state.modal?.reset()
        }
        
        public func invalidate(_ view: IUIView) {
            if let modal = self.state.modal {
                if modal.view === view {
                    modal.reset()
                }
            }
        }
        
        func layout(bounds: Rect) -> Size {
            if let content = self.content {
                content.frame = bounds
            }
            self.hook.frame = bounds
            switch self.state {
            case .empty:
                break
            case .idle(let modal, let detent):
                let modalInset: Inset
                if let sheet = modal.sheet {
                    modalInset = Inset(
                        top: self.inset.top + sheet.inset.top,
                        left: sheet.inset.left,
                        right: sheet.inset.right,
                        bottom: sheet.inset.bottom
                    )
                    sheet.background.frame = bounds
                    sheet.background.alpha = 1
                } else {
                    modalInset = .zero
                }
                let modalBounds = bounds.inset(modalInset)
                let modalSize = modal.size(of: detent, available: modalBounds.size)
                let frame = Rect(bottom: modalBounds.bottom, size: modalSize)
                modal.view.frame = frame
                if let grabber = modal.sheet?.grabber {
                    grabber.frame = Rect(
                        top: frame.top,
                        size: grabber.size(
                            available: frame.size
                        )
                    )
                }
            case .transition(let modal, let from, let to, var progress):
                let modalInset: Inset
                if let sheet = modal.sheet {
                    modalInset = Inset(
                        top: self.inset.top + sheet.inset.top,
                        left: sheet.inset.left,
                        right: sheet.inset.right,
                        bottom: sheet.inset.bottom
                    )
                    sheet.background.frame = bounds
                    if from == nil {
                        sheet.background.alpha = progress.value
                    } else if to == nil {
                        sheet.background.alpha = progress.invert.value
                    } else {
                        sheet.background.alpha = 1
                    }
                } else {
                    modalInset = .zero
                }
                let modalBounds = bounds.inset(modalInset)
                let fromRect: Rect
                let toRect: Rect
                if let from = from, let to = to {
                    let fromSize = modal.size(of: from, available: modalBounds.size)
                    let toSize = modal.size(of: to, available: modalBounds.size)
                    fromRect = Rect(bottom: bounds.bottom, size: fromSize)
                    toRect = Rect(bottom: bounds.bottom, size: toSize)
                } else if let from = from {
                    let fromSize = modal.size(of: from, available: modalBounds.size)
                    let toSize = modal.minSize(available: modalBounds.size)
                    fromRect = Rect(bottom: modalBounds.bottom, size: fromSize)
                    toRect = Rect(top: bounds.bottom, size: toSize)
                } else if let to = to {
                    if progress > .one {
                        progress -= .one
                        let fromSize = modal.size(of: to, available: modalBounds.size)
                        let toSize = Size(width: fromSize.width, height: fromSize.height * 2)
                        fromRect = Rect(bottom: modalBounds.bottom, size: fromSize)
                        toRect = Rect(bottom: modalBounds.bottom, size: toSize)
                    } else {
                        let fromSize = modal.minSize(available: modalBounds.size)
                        let toSize = modal.size(of: to, available: modalBounds.size)
                        fromRect = Rect(top: bounds.bottom, size: fromSize)
                        toRect = Rect(bottom: modalBounds.bottom, size: toSize)
                    }
                } else {
                    fromRect = .zero
                    toRect = .zero
                }
                let frame = fromRect.lerp(toRect, progress: progress)
                modal.view.frame = frame
                if let grabber = modal.sheet?.grabber {
                    grabber.frame = Rect(
                        top: frame.top,
                        size: grabber.size(
                            available: frame.size
                        )
                    )
                }
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return available
        }
        
        func views(bounds: Rect) -> [IUIView] {
            var views: [IUIView] = []
            if let content = self.content {
                views.append(content)
            }
            views.append(self.hook)
            if let modal = self.state.modal {
                if let sheet = modal.sheet {
                    views.append(contentsOf: [ sheet.background, modal.view ])
                    if let view = sheet.grabber {
                        views.append(view)
                    }
                } else {
                    views.append(modal.view)
                }
            }
            return views
        }
        
    }
    
}

extension UI.Container.Modal.Layout {
}

extension UI.Container.Modal.Layout {
    
    func beginInteractive(
        modal: UI.Container.ModalItem
    ) {
    }
    
    func changeInteractive(
        modal: UI.Container.ModalItem,
        delta: Double
    ) {
        if modal.isSheet == true {
            if let transition = modal.sheetTransition(delta: delta) {
                self.state = .transition(
                    modal: modal,
                    from: transition.from,
                    to: transition.to,
                    progress: transition.progress
                )
            } else {
                self.state = .idle(modal: modal)
            }
        } else if let view = self.appearedView {
            if delta > 0 {
                let progress = Percent(delta / view.bounds.size.height)
                self.state = .dismiss(modal: modal, progress: progress)
            } else {
                self.state = .idle(modal: modal)
            }
        }
    }
    
    func endInteractive(
        modal: UI.Container.ModalItem,
        velocity: Double,
        delta: Double,
        animation: @escaping (Percent) -> Void,
        finish: @escaping () -> Void,
        cancel: @escaping () -> Void
    ) -> ICancellable? {
        let transition: (
            from: UI.Size.Dynamic.Dimension?,
            to: UI.Size.Dynamic.Dimension?,
            size: Double,
            progress: Percent
        )?
        if modal.isSheet == true {
            transition = modal.sheetTransition(delta: delta)
        } else if let view = self.appearedView {
            if delta > 0 {
                let size = view.bounds.size.height
                let progress = Percent(delta / size)
                transition = (
                    from: modal.currentDetent,
                    to: nil,
                    size: size,
                    progress: progress
                )
            } else {
                transition = nil
            }
        } else {
            transition = nil
        }
        guard let transition = transition else {
            self.state = .idle(modal: modal)
            cancel()
            return nil
        }
        let baseProgress = transition.progress
        let estimateProgress = .one - baseProgress
        if baseProgress >= Percent(0.25) {
            let duration = (transition.size * estimateProgress.value) / velocity
            return Animation.default.run(
                .custom(
                    duration: duration,
                    processing: { [weak self] animationProgress in
                        guard let self = self else { return }
                        let progress = baseProgress + (estimateProgress * animationProgress)
                        self.state = .transition(
                            modal: modal,
                            from: transition.from,
                            to: transition.to,
                            progress: progress
                        )
                        self.updateIfNeeded()
                        animation(progress)
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        if let detent = transition.to {
                            self.state = .idle(modal: modal, detent: detent)
                            modal.currentDetent = detent
                            cancel()
                        } else {
                            self.state = .empty
                            finish()
                        }
                    }
                )
            )
        } else {
            let duration = (transition.size * baseProgress.value) / velocity
            return Animation.default.run(
                .custom(
                    duration: duration,
                    processing: { [weak self] animationProgress in
                        guard let self = self else { return }
                        let progress = estimateProgress + (baseProgress * animationProgress)
                        self.state = .transition(
                            modal: modal,
                            from: transition.to,
                            to: transition.from,
                            progress: progress
                        )
                        self.updateIfNeeded()
                        animation(progress)
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        if let detent = transition.from {
                            self.state = .idle(modal: modal, detent: detent)
                            modal.currentDetent = detent
                            cancel()
                        } else {
                            self.state = .idle(modal: modal)
                            cancel()
                        }
                    }
                )
            )
        }
    }
    
}
