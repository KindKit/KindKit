//
//  KindKit
//

#if os(iOS)

import UIKit
import KindEvent
import KindLayout
import KindSuggestion
import KindMonadicMacro

protocol KKSuggestionViewDelegate : AnyObject {
    
    func kk_count() -> Int
    func kk_string(at index: Int) -> String
    func kk_changed(selectedIndex: Int)
    
}

@Monadic
public final class SuggestionView< Entity : KindSuggestion.IEntity, Formatter : KindCore.IFormatter > : IView, IViewSupportStaticSize where Entity.Item == Formatter.Input, Formatter.Output == String {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: StaticSize = .init(width: .fill, height: .fixed(56)) {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    @MonadicField
    public var entity: Entity {
        didSet {
            guard self.entity !== oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_reload()
            }
        }
    }
    
    @MonadicField
    public var formatter: Formatter {
        didSet {
            guard self.formatter != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_reload()
            }
        }
    }
    
    @MonadicSignal
    public let onChoice = KindEvent.Signal< Void, Entity.Item >()
    
    private var _layout: ReuseLayoutItem< Reusable >!
    private var _items: [Entity.Item] = [] {
        didSet {
            guard self._items != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_reload()
            }
        }
    }
    
    public init(
        entity: Entity,
        formatter: Formatter
    ) {
        self.entity = entity
        self.formatter = formatter
        
        self._layout = .init(self)
        
        do {
            self.entity.onItems(self, { $0._onItems($1) })
        }
    }
    
    deinit {
        self.entity.onItems(remove: self)
    }
    
}

private extension SuggestionView {
    
    func _onItems(_ items: [Entity.Item]) {
        self._items = items
    }
    
}

extension SuggestionView : KKSuggestionViewDelegate {
    
    final func kk_count() -> Int {
        return self._items.count
    }
    
    final func kk_string(at index: Int) -> String {
        return self.formatter.format(self._items[index])
    }
    
    final func kk_changed(selectedIndex: Int) {
        self.onChoice.emit(self._items[selectedIndex])
    }
    
}

#endif
