//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindEvent
import KindLayout

public final class StaticLayoutItem< ControllerType : IView, ViewType : NativeView > : ILayoutItem {
    
    public unowned(unsafe) var layout: ILayout?
    
    public unowned let controller: ControllerType
    
    public let view: ViewType
    
    public var isLoaded: Bool {
        return true
    }

    public var handle: NativeView {
        return self.view
    }
    
    public var position: Position? {
        didSet {
            guard self.position != oldValue else { return }
            if let position = oldValue {
                self.onDisappear.emit()
                position.disappear(self)
            }
            if let position = self.position {
                position.appear(self)
                self.onAppear.emit(self._numberOfAppeared == 0)
                self._numberOfAppeared += 1
            }
        }
    }
    
    public var frame: Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            self.view.kk_update(frame: self.frame)
        }
    }
    
    public var isHidden: Bool = false {
        didSet {
            guard self.isHidden != oldValue else { return }
            self.update(force: true)
        }
    }
    
    public var isLocked: Bool = false
    
    public let onAppear = Signal< Void, Bool >()
    
    public let onDisappear = Signal< Void, Void >()
    
    private var _numberOfAppeared: UInt = 0
    
    public init(_ controller: ControllerType, _ view: ViewType) {
        self.controller = controller
        self.view = view
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.controller.sizeOf(request)
    }
    
}
