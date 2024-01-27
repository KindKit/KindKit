//
//  KindKit
//

import KindUI

extension Container.Modal.Layout {
    
    enum State : Equatable {
        
        case empty
        
        case idle(
            modal: Container.ModalItem,
            detent: DynamicSize.Dimension
        )
        
        case transition(
            modal: Container.ModalItem,
            from: DynamicSize.Dimension?,
            to: DynamicSize.Dimension?,
            progress: Percent
        )
        
    }
    
}

extension Container.Modal.Layout.State {
    
    @inlinable
    static func idle(modal: Container.ModalItem) -> Self {
        return .idle(modal: modal, detent: modal.currentDetent)
    }
    
    @inlinable
    static func present(modal: Container.ModalItem, progress: Percent) -> Self {
        return .transition(
            modal: modal,
            from: nil,
            to: modal.currentDetent,
            progress: progress
        )
    }
    
    @inlinable
    static func dismiss(modal: Container.ModalItem, progress: Percent) -> Self {
        return .transition(
            modal: modal,
            from: modal.currentDetent,
            to: nil,
            progress: progress
        )
    }
    
}

extension Container.Modal.Layout.State {
    
    @inlinable
    var modal: Container.ModalItem? {
        switch self {
        case .empty: return nil
        case .idle(let modal, _): return modal
        case .transition(let modal, _, _, _): return modal
        }
    }
    
}
