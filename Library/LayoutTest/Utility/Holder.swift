//
//  KindKit-Test
//

import KindLayout

final class Holder : KindLayout.Holder {
    
    private var _items: [any Item] = []
    
    init() {
    }
    
    func insert(_ item: any Item, at index: Int) {
        guard index <= self._items.count else {
            fatalError()
        }
        if let existIndex = self._items.firstIndex(where: { $0 === item }) {
            self._items.remove(at: existIndex)
            if existIndex < index {
                self._items.insert(item, at: index - 1)
            } else {
                self._items.insert(item, at: index)
            }
        } else {
            self._items.append(item)
        }
    }
    
    func remove(_ item: any Item) {
        guard let index = self._items.firstIndex(where: { $0 === item }) else {
            fatalError()
        }
        self._items.remove(at: index)
    }
    
}
