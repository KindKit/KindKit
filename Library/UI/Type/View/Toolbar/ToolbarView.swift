//
//  KindKit
//

#if os(iOS)

import UIKit
import KindEvent
import KindLayout
import KindMonadicMacro

protocol KKToolbarViewDelegate : AnyObject {
    
    func kk_pressed(_ barItem: UIBarButtonItem)
    
}

@Monadic
public final class ToolbarView : IView, IViewSupportStaticSize, IViewSupportTintColor {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: StaticSize = .init(width: .fill, height: .fixed(55)) {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    @MonadicField
    public var items: [any IToolbarItem] = [] {
        didSet {
            if self.isLoaded == true {
                self._layout.view.kk_update(items: self.items)
            }
        }
    }
    
    public var tintColor: Color? = .systemLabel {
        didSet {
            guard self.tintColor != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(tintColor: self.tintColor)
            }
        }
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init() {
        self._layout = .init(self)
    }
    
}

extension ToolbarView : KKToolbarViewDelegate {
    
    func kk_pressed(_ barItem: UIBarButtonItem) {
        guard let appearedItem = self.items.first(where: { return $0.handle == barItem }) else { return }
        appearedItem.pressed()
    }
    
}

#endif
