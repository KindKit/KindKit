//
//  KindKit
//

import Foundation

extension UI.Container.Modal.Layout {
    
    enum State : Equatable {
        
        case empty
        
        case idle(
            modal: UI.Container.ModalItem,
            detent: UI.Size.Dynamic.Dimension
        )
        
        case transition(
            modal: UI.Container.ModalItem,
            from: UI.Size.Dynamic.Dimension?,
            to: UI.Size.Dynamic.Dimension?,
            progress: Percent
        )
        
    }
    
}

extension UI.Container.Modal.Layout.State {
    
    @inlinable
    static func idle(modal: UI.Container.ModalItem) -> Self {
        return .idle(modal: modal, detent: modal.currentDetent)
    }
    
    @inlinable
    static func present(modal: UI.Container.ModalItem, progress: Percent) -> Self {
        return .transition(
            modal: modal,
            from: nil,
            to: modal.currentDetent,
            progress: progress
        )
    }
    
    @inlinable
    static func dismiss(modal: UI.Container.ModalItem, progress: Percent) -> Self {
        return .transition(
            modal: modal,
            from: modal.currentDetent,
            to: nil,
            progress: progress
        )
    }
    
}

extension UI.Container.Modal.Layout.State {
    
    @inlinable
    var modal: UI.Container.ModalItem? {
        switch self {
        case .empty: return nil
        case .idle(let modal, _): return modal
        case .transition(let modal, _, _, _): return modal
        }
    }
    
}
