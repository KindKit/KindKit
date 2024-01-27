//
//  KindKit
//

import Foundation
import KindGraphics

extension Text {
    
    struct Extra : Equatable, Hashable {
        
        var styles = Ranges< Style >()
        var flags = Ranges< TextFlags >()
        var links = Ranges< URL >()
        
        init() {
        }
        
    }
    
}

extension Text.Extra {
    
    @inline(__always)
    var usageStyles: [Style] {
        return self.styles.items.map({ $0.value })
    }
    
    @inline(__always)
    var shouldLink: Bool {
        return self.links.items.isEmpty == false
    }
    
}

extension Text.Extra {
    
    @inline(__always)
    mutating func insert(
        _ position: Text.Index,
        _ count: Int
    ) {
        self.styles.insert(position, count)
        self.flags.insert(position, count)
        self.links.insert(position, count)
    }
    
    @inline(__always)
    mutating func insert(
        _ position: Text.Index,
        _ count: Int,
        _ inserts: Self
    ) {
        self.insert(position, count)
        for item in inserts.styles.items {
            self.styles.set(.init(lower: position + item.range.lower, upper: position + item.range.upper), item.value)
        }
        for item in inserts.flags.items {
            self.flags.set(.init(lower: position + item.range.lower, upper: position + item.range.upper), item.value)
        }
        for item in inserts.links.items {
            self.links.set(.init(lower: position + item.range.lower, upper: position + item.range.upper), item.value)
        }
    }
    
    @inline(__always)
    mutating func remove(
        _ range: Text.Range
    ) {
        self.styles.remove(range)
        self.flags.remove(range)
        self.links.remove(range)
    }
    
    @inline(__always)
    mutating func set(
        _ range: Text.Range,
        _ options: [Text.Option]
    ) {
        for option in options {
            switch option {
            case .style(let style):
                self.styles.set(range, style)
            case .flags(let flags):
                self.flags.set(range, flags)
            case .link(let link):
                self.links.set(range, link)
            }
        }
    }
    
    @inline(__always)
    mutating func set(
        _ range: Text.Range,
        _ option: Text.Option
    ) {
        switch option {
        case .style(let style):
            self.styles.set(range, style)
        case .flags(let flags):
            self.flags.set(range, flags)
        case .link(let link):
            self.links.set(range, link)
        }
    }
    
    @inline(__always)
    mutating func clear(
        _ range: Text.Range,
        _ options: Text.OptionSet
    ) {
        if options.contains(.style) == true {
            self.styles.clear(range)
        }
        if options.contains(.flags) == true {
            self.flags.clear(range)
        }
        if options.contains(.link) == true {
            self.links.clear(range)
        }
    }
    
    @inline(__always)
    func each(
        _ base: Text.Options,
        _ range: Text.Range,
        _ block: (Text.Range, Text.Options) -> Void
    ) {
        let styles = self.styles.items(of: range)
        let flags = self.flags.items(of: range)
        let links = self.links.items(of: range)
        var index = range.lower
        var scanIndex = range.lower
        var stylesIndex = styles.startIndex
        var flagsIndex = flags.startIndex
        var linksIndex = links.startIndex
        var options = Text.Options(
            style: styles.first?.value ?? base.style,
            flags: flags.first?.value,
            link: links.first?.value
        )
        while scanIndex != range.upper || (stylesIndex != styles.endIndex && flagsIndex != flags.endIndex && linksIndex != links.endIndex) {
            var changed = false
            styles._scan(&stylesIndex, {
                $0.range.is(contains: scanIndex)
            }, {
                if options.style != $0.value {
                    options = options.style($0.value)
                    changed = true
                }
            }, {
                if options.style != base.style {
                    options = options.style(base.style)
                    changed = true
                }
            })
            flags._scan(&flagsIndex, {
                $0.range.is(contains: scanIndex)
            }, {
                if options.flags != $0.value {
                    options = options.flags($0.value)
                    changed = true
                }
            }, {
                if options.flags != base.flags {
                    options = options.flags(base.flags)
                    changed = true
                }
            })
            links._scan(&linksIndex, {
                $0.range.is(contains: scanIndex)
            }, {
                if options.link != $0.value {
                    options = options.link($0.value)
                    changed = true
                }
            }, {
                if options.link != base.link {
                    options = options.link(base.link)
                    changed = true
                }
            })
            if changed == true && index != scanIndex {
                block(.init(lower: index, upper: scanIndex), options)
                index = scanIndex
            }
            scanIndex += 1
        }
        if index != range.upper {
            block(.init(lower: index, upper: range.upper), options)
        }
    }
    
    @inline(__always)
    func link(at index: Text.Index) -> URL? {
        guard let item = self.links.item(at: index) else { return nil }
        return item.value
    }
    
}

fileprivate extension Array {
    
    @inline(__always)
    func _scan(
        _ index: inout Index,
        _ contains: (Element) -> Bool,
        _ update: (Element) -> Void,
        _ finish: () -> Void
    ) {
        if index != self.endIndex {
            let data = self[index]
            if contains(data) == false {
                index = self.index(after: index)
                if index != self.endIndex {
                    update(self[index])
                } else {
                    finish()
                }
            }
        }
    }
    
}
