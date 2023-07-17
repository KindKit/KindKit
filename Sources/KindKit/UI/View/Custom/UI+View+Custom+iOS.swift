//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Custom {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Custom
        typealias Content = KKCustomView
        
        static var reuseIdentificator: String {
            return "UI.View.Custom"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKCustomView : UIView {
    
    weak var kkDelegate: KKCustomViewDelegate?
    var kkLayoutManager: UI.Layout.Manager!
    var kkGestures: [IUIGesture] = []
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
    var kkDragDestination: IUIDragAndDropDestination? {
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
    var kkDragSource: IUIDragAndDropSource? {
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
    var kkContentSize: Size {
        return self.kkLayoutManager.size
    }
    
    override var frame: CGRect {
        didSet {
            guard self.frame != oldValue else { return }
            if self.frame.size != oldValue.size {
                if self.window != nil {
                    self.kkLayoutManager.invalidate()
                    self._needLayout = true
                }
            }
        }
    }
    
    private var _needLayout = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self.kkLayoutManager = UI.Layout.Manager(contentView: self, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview superview: UIView?) {
        super.willMove(toSuperview: superview)
        
        if superview == nil {
            self.kkLayoutManager.clear()
            self._needLayout = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self._needLayout == true {
            self._needLayout = false
            
            let bounds = Rect(self.bounds)
            self.kkLayoutManager.layout(bounds: bounds)
            self.kkLayoutManager.visible(bounds: bounds)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView === self {
            if self.kkDelegate?.hasHit(self, point: .init(point)) == false {
                return nil
            }
        }
        return hitView
    }
    
    override func touchesBegan(_ touches: Set< UITouch >, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.kkDelegate?.shouldHighlighting(self) == true {
            self.kkDelegate?.set(self, highlighted: true)
        }
    }
    
    override func touchesEnded(_ touches: Set< UITouch >, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if self.kkDelegate?.shouldHighlighting(self) == true {
            self.kkDelegate?.set(self, highlighted: false)
        }
    }
    
    override func touchesCancelled(_ touches: Set< UITouch >, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if self.kkDelegate?.shouldHighlighting(self) == true {
            self.kkDelegate?.set(self, highlighted: false)
        }
    }
    
}

extension KKCustomView {
    
    func update(view: UI.View.Custom) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(gestures: view.gestures)
        self.update(content: view.content)
        self.update(dragDestination: view.dragDestination)
        self.update(dragSource: view.dragSource)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.update(locked: view.isLocked)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(content: IUILayout?) {
        self.kkLayoutManager.layout = content
        self.setNeedsLayout()
        self._needLayout = true
    }
    
    func update(gestures: [IUIGesture]) {
        for gesture in self.kkGestures {
            self.removeGestureRecognizer(gesture.native)
        }
        self.kkGestures = gestures
        for gesture in self.kkGestures {
            self.addGestureRecognizer(gesture.native)
        }
    }
    
    func update(dragDestination: IUIDragAndDropDestination?) {
        self.kkDragDestination = dragDestination
    }
    
    func update(dragSource: IUIDragAndDropSource?) {
        self.kkDragSource = dragSource
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func update(locked: Bool) {
        self.isUserInteractionEnabled = locked == false
    }
    
    func cleanup() {
        self.kkLayoutManager.layout = nil
        for gesture in self.kkGestures {
            self.removeGestureRecognizer(gesture.native)
        }
        self.kkGestures.removeAll()
        self.kkDelegate = nil
    }
    
    func add(gesture: IUIGesture) {
        if self.kkGestures.contains(where: { $0 === gesture }) == false {
            self.kkGestures.append(gesture)
        }
        self.addGestureRecognizer(gesture.native)
    }
    
    func remove(gesture: IUIGesture) {
        if let index = self.kkGestures.firstIndex(where: { $0 === gesture }) {
            self.kkGestures.remove(at: index)
        }
        self.removeGestureRecognizer(gesture.native)
    }
    
}

extension KKCustomView : UIDragInteractionDelegate {
    
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
        if let operation = UI.DragAndDrop.Operation(operation) {
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

extension KKCustomView : UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        guard let dragDestination = self.kkDragDestination else { return false }
        let dragSession = UI.DragAndDrop.Session(session, self)
        return dragDestination.onCanHandle.emit(dragSession, default: false)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        guard let dragDestination = self.kkDragDestination else { return }
        let dragSession = UI.DragAndDrop.Session(session, self)
        dragDestination.onEnter.emit(dragSession)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        guard let dragDestination = self.kkDragDestination else { return }
        let dragSession = UI.DragAndDrop.Session(session, self)
        dragDestination.onExit.emit(dragSession)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        guard let dragDestination = self.kkDragDestination else { return UIDropProposal(operation: .cancel) }
        let dragSession = UI.DragAndDrop.Session(session, self)
        let operation = dragDestination.onProposal.emit(dragSession, default: .cancel)
        return UIDropProposal(operation: operation.uiDropOperation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let dragDestination = self.kkDragDestination else { return }
        let dragSession = UI.DragAndDrop.Session(session, self)
        dragDestination.onHandle.emit(dragSession)
    }
    
}

extension KKCustomView : IUILayoutDelegate {
    
    func setNeedUpdate(_ appearedLayout: IUILayout) -> Bool {
        self._needLayout = true
        self.setNeedsLayout()
        return true
    }
    
    func updateIfNeeded(_ appearedLayout: IUILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
