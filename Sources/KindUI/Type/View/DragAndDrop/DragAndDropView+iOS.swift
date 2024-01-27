//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension DragAndDropView {
    
    struct Reusable : IReusable {
        
        typealias Owner = DragAndDropView
        typealias Content = KKDragAndDropView
        
        static func name(owner: Owner) -> String {
            return "DragAndDropView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
        }
        
    }
    
}

final class KKDragAndDropView : UIView {
    
    var kkDragDestinationInteraction: UIInteraction? {
        willSet {
            guard self.kkDragDestinationInteraction !== newValue else { return }
            if let interaction = self.kkDragDestinationInteraction {
                self.removeInteraction(interaction)
            }
        }
        didSet {
            guard self.kkDragDestinationInteraction !== oldValue else { return }
            if let interaction = self.kkDragDestinationInteraction {
                self.addInteraction(interaction)
            }
        }
    }
    var kkDragDestination: DragAndDrop.Destination? {
        didSet {
            guard self.kkDragDestination !== oldValue else { return }
            if self.kkDragDestination != nil {
                self.kkDragDestinationInteraction = UIDropInteraction(delegate: self)
            } else {
                self.kkDragDestinationInteraction = nil
            }
        }
    }
    var kkDragSourceInteraction: UIInteraction? {
        willSet {
            guard self.kkDragSourceInteraction !== newValue else { return }
            if let interaction = self.kkDragSourceInteraction {
                self.removeInteraction(interaction)
            }
        }
        didSet {
            guard self.kkDragSourceInteraction !== oldValue else { return }
            if let interaction = self.kkDragSourceInteraction {
                self.addInteraction(interaction)
            }
        }
    }
    var kkDragSource: DragAndDrop.Source? {
        didSet {
            guard self.kkDragSource !== oldValue else { return }
            if self.kkDragSource != nil {
                let interaction = UIDragInteraction(delegate: self)
                self.kkDragSourceInteraction = interaction
                interaction.isEnabled = true
            } else {
                self.kkDragSourceInteraction = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKDragAndDropView {
    
    func kk_update(view: DragAndDropView) {
        self.kk_update(frame: view.frame)
        self.kk_update(destination: view.dragDestination)
        self.kk_update(source: view.dragSource)
        self.kk_update(enabled: view.isEnabled)
    }
    
    func kk_cleanup(view: DragAndDropView) {
    }
    
}

extension KKDragAndDropView {
    
    func kk_update(destination: DragAndDrop.Destination?) {
        self.kkDragDestination = destination
    }
    
    func kk_update(source: DragAndDrop.Source?) {
        self.kkDragSource = source
    }
    
    func kk_update(enabled: Bool) {
        self.isUserInteractionEnabled = enabled
    }
    
}

extension KKDragAndDropView : UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let dragSource = self.kkDragSource else { return [] }
        return dragSource.onItems.emit(default: []).compactMap({
            return UIDragItem(itemProvider: $0)
        })
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionAllowsMoveOperation session: UIDragSession) -> Bool {
        guard let dragSource = self.kkDragSource else { return false }
        return dragSource.onAllow.emit(.move, default: false)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
        guard let dragSource = self.kkDragSource else { return }
        return dragSource.onBegin.emit()
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        guard let dragSource = self.kkDragSource else { return }
        if let operation = DragAndDrop.Operation(operation) {
            dragSource.onEnd.emit(operation)
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        guard let dragSource = self.kkDragSource else { return nil }
        let view = dragSource.onPreview.emit(item.itemProvider, default: {
            let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
            let image = renderer.image(actions: { context in
                self.layer.render(in: context.cgContext)
            })
            let view = UIImageView(image: image)
            view.frame = self.bounds
            self.addSubview(view)
            return view
        })
        item.localObject = view
        let parameters = dragSource.onPreviewParameters.emit(item.itemProvider, default: {
            let parameters = UIDragPreviewParameters()
            parameters.backgroundColor = .clear
            return parameters
        })
        return UITargetedDragPreview(view: view, parameters: parameters)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        guard let dragSource = self.kkDragSource else { return }
        for item in session.items {
            dragSource.onBeginPreview.emit(item.itemProvider)
            if let view = item.localObject as? UIView {
                view.removeFromSuperview()
            }
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
        guard let dragSource = self.kkDragSource else { return }
        dragSource.onEndPreview.emit(item.itemProvider)
    }
    
}

extension KKDragAndDropView : UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        guard let dragDestination = self.kkDragDestination else { return false }
        let dragSession = DragAndDrop.Session(session, self)
        return dragDestination.onCanHandle.emit(dragSession, default: false)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        guard let dragDestination = self.kkDragDestination else { return }
        let dragSession = DragAndDrop.Session(session, self)
        dragDestination.onEnter.emit(dragSession)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        guard let dragDestination = self.kkDragDestination else { return }
        let dragSession = DragAndDrop.Session(session, self)
        dragDestination.onExit.emit(dragSession)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        guard let dragDestination = self.kkDragDestination else { return UIDropProposal(operation: .cancel) }
        let dragSession = DragAndDrop.Session(session, self)
        let operation = dragDestination.onProposal.emit(dragSession, default: .cancel)
        return UIDropProposal(operation: operation.uiDropOperation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let dragDestination = self.kkDragDestination else { return }
        let dragSession = DragAndDrop.Session(session, self)
        dragDestination.onHandle.emit(dragSession)
    }
    
}

#endif
