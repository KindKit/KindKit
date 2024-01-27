//
//  KindKit
//

import KindGeometry

protocol ISequenceCacheDelegate : AnyObject {
    
    func commit(_ listHelper: SequenceCache)
    
}

final class SequenceCache {
    
    weak var delegate: ISequenceCacheDelegate?
    
    private var _content: [any Layout] = []
    private var _cache: [ElementCache] = []
    
    init() {
    }
    
}

extension SequenceCache {
    
    func invalidate() {
        for cache in self._cache {
            cache.reset()
        }
    }
    
    func invalidate(_ layout: any Layout) {
        guard let index = self.index(layout) else { return }
        self._content[index].invalidate()
        self._cache[index].reset()
    }
    
}

extension SequenceCache {
    
    func `each`(_ block: (Int) -> Void) {
        for index in 0 ..< self._content.count {
            block(index)
        }
    }
    
    func `each`(_ block: (any Layout) -> Void) {
        for content in self._content {
            block(content)
        }
    }
    
    func `each`(_ block: (Int, any Layout) -> Void) {
        for index in 0 ..< self._content.count {
            block(index, self._content[index])
        }
    }
    
    func map< Result >(_ block: (Int) -> Result) -> [Result] {
        var result: [Result] = .kk_make(reserve: self._content.count)
        for index in 0 ..< self._content.count {
            result.append(block(index))
        }
        return result
    }
    
    func map< Result >(_ block: (any Layout) -> Result) -> [Result] {
        return self._content.map(block)
    }
    
    func replace(_ will: (any Layout) -> Void, _ content: [any Layout], _ did: (any Layout) -> Void) {
        for content in self._content {
            will(content)
        }
        self._content = content
        self._cache = .kk_make(new: { .init() }, count: content.count)
        for content in self._content {
            did(content)
        }
    }
    
    func count() -> Int {
        return self._content.count
    }
    
    func content(_ index: Int) -> any Layout {
        return self._content[index]
    }
    
    func content() -> [any Layout] {
        return self._content
    }
    
    func size(of request: SizeRequest, at index: Int) -> Size {
        let content = self._content[index]
        let cache = self._cache[index]
        return cache.sizeOf(request, content: content)
    }
    
    func arrange(_ frames: SequenceHelper.Frames) {
        for index in 0 ..< self._content.count {
            let content = self._content[index]
            _ = content.arrange(.init(
                container: frames.content[index]
            ))
        }
    }
    
    func arrange(_ frames: SequenceHelper.RowsFrames) {
        var index = Int.zero
        for row in frames.content {
            for cell in row.content {
                let content = self._content[index]
                _ = content.arrange(.init(
                    container: cell
                ))
                index += 1
            }
        }
    }
    
    func collect(_ collector: Collector) {
        guard self._content.count > 0 else { return }
        for index in 0 ..< self._content.count {
            let content = self._content[index]
            content.collect(collector)
        }
    }
    
    func collect(_ collector: Collector, predicate: (Rect, Rect) -> BinarySearch.Predicate) {
        guard self._content.count > 0 else { return }
        let bounds = collector.bounds
        if let range = BinarySearch.range(self._content, predicate: { predicate(bounds, $0.frame) }) {
            for index in range {
                let content = self._content[index]
                content.collect(collector)
            }
        }
    }
    
    func hCollect(_ collector: Collector) {
        self.collect(collector, predicate: { container, element in
            let containerLower = container.minX
            let containerUpper = container.maxX
            let elementLower = element.minX
            let elementUpper = element.maxX
            if elementUpper <= containerLower {
                return .less
            } else if elementLower >= containerUpper {
                return .more
            }
            return .same
        })
    }
    
    func vCollect(_ collector: Collector) {
        self.collect(collector, predicate: { container, element in
            let containerLower = container.minY
            let containerUpper = container.maxY
            let elementLower = element.minY
            let elementUpper = element.maxY
            if elementUpper <= containerLower {
                return .less
            } else if elementLower >= containerUpper {
                return .more
            }
            return .same
        })
    }
    
}

extension SequenceCache {
    
    func contains(_ content: any Layout) -> Bool {
        return self._content.contains(where: { $0 === content })
    }
    
    func index(_ content: any Layout) -> Int? {
        return self._content.firstIndex(where: { $0 === content })
    }
    
    func index(`where`: (any Layout) -> Bool) -> Int? {
        return self._content.firstIndex(where: `where`)
    }
    
    func index< Find : Layout >(`as` type: Find.Type, `where`: (Find) -> Bool) -> Int? {
        return self._content.firstIndex(where: {
            switch $0 {
            case let content as Find: return `where`(content)
            default: return false
            }
        })
    }
    
    func indices(_ content: [any Layout]) -> [Int] {
        let indices = content.compactMap({ content in
            self._content.firstIndex(where: { $0 === content })
        })
        return indices.sorted()
    }
    
    func indices< Find : Layout >(`as` type: Find.Type, `where`: (Find) -> Bool) -> [Int] {
        var result: [Int] = []
        for index in 0 ..< self._content.count {
            switch self._content[index] {
            case let content as Find:
                if `where`(content) == true {
                    result.append(index)
                }
            default: break
            }
        }
        return result
    }
    
    func insert(_ content: any Layout, at index: Int) {
        let safeIndex = max(0, min(index, self._content.count))
        self._content.insert(content, at: safeIndex)
        self._cache.insert(.init(), at: safeIndex)
        self.delegate?.commit(self)
    }
    
    func insert(_ content: [any Layout], at index: Int) {
        let safeIndex = max(0, min(index, self._content.count))
        self._content.insert(contentsOf: content, at: safeIndex)
        self._cache.insert(contentsOf: Array.kk_make(new: { .init() }, count: content.count), at: safeIndex)
        self.delegate?.commit(self)
    }
    
    func delete(_ index: Int) {
        guard index < self._content.count else { return }
        self._content.remove(at: index)
        self._cache.remove(at: index)
        self.delegate?.commit(self)
    }
    
    func delete(_ content: any Layout) {
        guard let index = self.index(content) else { return }
        self.delete(index)
    }
    
    func delete(_ content: [any Layout]) {
        let indices = self.indices(content)
        guard indices.count > 0 else { return }
        for index in indices.reversed() {
            self._content.remove(at: index)
            self._cache.remove(at: index)
        }
        self.delegate?.commit(self)
    }
    
    func delete(_ range: Range< Int >) {
        let range = Range< Int >(uncheckedBounds: (
            lower: min(max(range.lowerBound, 0), self._content.count),
            upper: min(max(range.upperBound, 0), self._content.count)
        ))
        guard range.isEmpty == false else {
            return
        }
        self._content.removeSubrange(range)
        self._cache.removeSubrange(range)
        self.delegate?.commit(self)
    }
    
}
