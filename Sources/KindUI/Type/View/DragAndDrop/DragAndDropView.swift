//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout

public final class DragAndDropView : IView, IViewStaticSizeable,  IViewDragDestinationtable, IViewDragSourceable, IViewEnableable {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var handle: NativeView {
        return self._layout.view
    }
    
    public var isLoaded: Bool {
        return self._layout.isLoaded
    }
    
    public var size: StaticSize = .fill {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    public var dragDestination: DragAndDrop.Destination? {
        didSet {
            guard self.dragDestination !== oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(destination: self.dragDestination)
            }
        }
    }
    
    public var dragSource: DragAndDrop.Source? {
        didSet {
            guard self.dragSource !== oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(source: self.dragSource)
            }
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            guard self.isEnabled != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(enabled: self.isEnabled)
            }
        }
    }
    
    public var onAppear: Signal< Void, Bool > {
        return self._layout.onAppear
    }
    
    public var onDisappear: Signal< Void, Void > {
        return self._layout.onDisappear
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init() {
        self._layout = .init(self)
    }

}
