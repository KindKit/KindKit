//
//  KindKit
//

#if os(macOS)

import AppKit
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

final class KKDragAndDropView : NSView {
    
    var kkDragDestination: DragAndDrop.Destination?
    var kkDragSource: DragAndDrop.Source? {
        willSet {
            guard self.kkDragSource !== newValue else { return }
            self.unregisterDraggedTypes()
        }
        didSet {
            guard self.kkDragSource !== oldValue else { return }
            if let dragSource = self.kkDragSource {
                self.registerForDraggedTypes(dragSource.pasteboardTypes)
            }
        }
    }
    var kkisEnabled: Bool = true
    
    override var isFlipped: Bool {
        return true
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        guard self.kkisEnabled == true else {
            return nil
        }
        return super.hitTest(point)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        if let dragSource = self.kkDragSource {
            self.beginDraggingSession(
                with: dragSource.onItems.emit(default: []).compactMap({
                    return NSDraggingItem(pasteboardWriter: $0)
                }),
                event: event,
                source: self
            )
        }
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
        self.kkisEnabled = enabled
    }
    
}

extension KKDragAndDropView : NSDraggingSource {
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .generic
    }
    
}

extension KKDragAndDropView {
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard self.kkDragDestination != nil else { return false }
        return true
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .generic
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
    }
}

#endif
