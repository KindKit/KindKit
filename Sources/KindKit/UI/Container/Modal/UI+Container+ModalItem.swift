//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class ModalItem {
        
        let container: IUIModalContentContainer
        let owner: AnyObject?
        let view: UI.View.Mask
        var currentDetent: UI.Size.Dynamic.Dimension
        let sheet: UI.Modal.Presentation.Sheet!
        
        private var _cacheAvailable: Size?
        private var _cacheSheetDetents: [UI.Size.Dynamic.Dimension] = []
        private var _cacheSheetSizes: [Size] = []
        
        init(
            _ container: IUIModalContentContainer,
            _ owner: AnyObject? = nil
        ) {
            self.container = container
            self.owner = owner
            self.view = UI.View.Mask()
                .content(container.view)
                .color(container.modalColor)
            if let modalSheet = container.modalSheet {
                self.view.cornerRadius = modalSheet.cornerRadius
                self.currentDetent = modalSheet.preferredDetent
                self.sheet = modalSheet
            } else {
                self.currentDetent = .fill
                self.sheet = nil
            }
        }

    }
    
}

private extension UI.Container.ModalItem {
    
    @inline(__always)
    func _updateCacheIfNeeded(available: Size) {
        guard self._cacheAvailable != available else {
            return
        }
        self._cacheAvailable = available
        if let sheet = self.sheet {
            let originSizes = sheet.detents.map({
                switch $0 {
                case .parent(let restriction):
                    return Size(
                        width: available.width,
                        height: available.height * restriction.value
                    )
                case .ratio(let restriction):
                    return Size(
                        width: available.width,
                        height: available.width * restriction.value
                    )
                case .fixed(let restriction):
                    return Size(
                        width: available.width,
                        height: restriction
                    )
                case .content(let restriction):
                    let viewSize = self.view.size(available: available)
                    return Size(
                        width: available.width,
                        height: viewSize.height * restriction.value
                    )
                }
            })
            let sortedSizes = originSizes.sorted()
            self._cacheSheetSizes = sortedSizes
            self._cacheSheetDetents = sortedSizes.map({
                guard let index = originSizes.firstIndex(of: $0) else {
                    fatalError()
                }
                return sheet.detents[index]
            })
        }
    }
    
}

extension UI.Container.ModalItem {
    
    var isSheet: Bool {
        return self.sheet != nil
    }
    
    var sheetMinSize: Size? {
        return self._cacheSheetSizes.min()
    }
    
    var sheetMaxSize: Size? {
        return self._cacheSheetSizes.max()
    }
    
    func sheetDetentIndex(of detent: UI.Size.Dynamic.Dimension) -> Int? {
        return self._cacheSheetDetents.firstIndex(of: detent)
    }
    
    func sheetLowerDetentIndex(of detent: Int) -> Int? {
        var lower: Int? = nil
        let targetSize = self._cacheSheetSizes[detent]
        var targetIndex = detent
        while targetIndex > self._cacheSheetDetents.startIndex {
            let lowerSize = self._cacheSheetSizes[targetIndex - 1]
            if targetSize != lowerSize {
                lower = targetIndex - 1
                break
            }
            targetIndex -= 1
        }
        return lower
    }
    
    func sheetUpperDetentIndex(of detent: Int) -> Int? {
        var upper: Int? = nil
        let targetSize = self._cacheSheetSizes[detent]
        var targetIndex = detent
        while targetIndex < self._cacheSheetDetents.endIndex - 1 {
            let lowerSize = self._cacheSheetSizes[targetIndex + 1]
            if targetSize != lowerSize {
                upper = targetIndex + 1
                break
            }
            targetIndex += 1
        }
        return upper
    }
    
    func sheetSize(of detent: UI.Size.Dynamic.Dimension) -> Size? {
        guard let index = self._cacheSheetDetents.firstIndex(of: detent) else { return nil }
        return self.sheetSize(of: index)
    }
    
    func sheetSize(of detent: Int) -> Size {
        return self._cacheSheetSizes[detent]
    }
    
    func sheetTransition(
        delta: Double
    ) -> (
        from: UI.Size.Dynamic.Dimension?,
        to: UI.Size.Dynamic.Dimension?,
        size: Double,
        progress: Percent
    )? {
        guard let baseIndex = self.sheetDetentIndex(of: self.currentDetent) else {
            return nil
        }
        if delta > 0 {
            var origin = delta
            var currentIndex = baseIndex
            var lowerIndex = baseIndex
            var currentSize = self.sheetSize(of: currentIndex)
            var lowerSize = currentSize
            var size: Double = 0
            while true {
                if let potentialIndex = self.sheetLowerDetentIndex(of: currentIndex) {
                    let potentialSize = self.sheetSize(of: potentialIndex)
                    let deltaHeight = currentSize.height - potentialSize.height
                    let progress = Percent(origin, from: deltaHeight)
                    size += deltaHeight
                    if progress > .one {
                        currentIndex = potentialIndex
                        currentSize = potentialSize
                        origin -= deltaHeight
                    } else {
                        lowerIndex = potentialIndex
                        lowerSize = potentialSize
                        break
                    }
                } else if baseIndex != currentIndex {
                    lowerIndex = currentIndex
                    lowerSize = currentSize
                    size += size - currentSize.height
                    break
                } else {
                    size += currentSize.height
                    break
                }
            }
            if currentIndex != lowerIndex {
                let deltaHeight = currentSize.height - lowerSize.height
                let progress = Percent(origin, from: deltaHeight)
                return (
                    from: self.sheet.detents[currentIndex],
                    to: self.sheet.detents[lowerIndex],
                    size: size,
                    progress: progress
                )
            } else {
                let progress = Percent(origin, from: size)
                return (
                    from: self.sheet.detents[currentIndex],
                    to: nil,
                    size: size,
                    progress: progress
                )
            }
        } else if delta < 0 {
            var origin = -delta
            var currentIndex = baseIndex
            var upperIndex = baseIndex
            var currentSize = self.sheetSize(of: currentIndex)
            var upperSize = currentSize
            var size: Double = 0
            while true {
                if let potentialIndex = self.sheetUpperDetentIndex(of: currentIndex) {
                    let potentialSize = self.sheetSize(of: potentialIndex)
                    let deltaHeight = potentialSize.height - currentSize.height
                    let progress = Percent(origin, from: deltaHeight)
                    size += deltaHeight
                    if progress > .one {
                        currentIndex = potentialIndex
                        currentSize = potentialSize
                        origin -= deltaHeight
                    } else {
                        upperIndex = potentialIndex
                        upperSize = potentialSize
                        break
                    }
                } else if baseIndex != currentIndex {
                    upperIndex = currentIndex
                    upperSize = currentSize
                    size += currentSize.height - size
                    break
                } else {
                    size += currentSize.height
                    break
                }
            }
            if currentIndex != upperIndex {
                let deltaHeight = upperSize.height - currentSize.height
                let progress = Percent(origin, from: deltaHeight)
                return (
                    from: self.sheet.detents[currentIndex],
                    to: self.sheet.detents[upperIndex],
                    size: size,
                    progress: progress
                )
            } else {
                let progress = Percent(origin, from: size.pow(1.5)).invert
                return (
                    from: nil,
                    to: self.sheet.detents[currentIndex],
                    size: size,
                    progress: progress
                )
            }
        }
        return nil
    }
    
}

extension UI.Container.ModalItem {
    
    func minSize(available: Size) -> Size {
        self._updateCacheIfNeeded(available: available)
        if self.isSheet == true {
            return self.sheetMinSize ?? available
        }
        return available
    }
    
    func maxSize(available: Size) -> Size {
        self._updateCacheIfNeeded(available: available)
        if self.isSheet == true {
            return self.sheetMaxSize ?? available
        }
        return available
    }
    
    func size(of detent: UI.Size.Dynamic.Dimension, available: Size) -> Size {
        self._updateCacheIfNeeded(available: available)
        if self.isSheet == true {
            return self.sheetSize(of: detent) ?? available
        }
        return available
    }
    
    func reset() {
        self._cacheAvailable = nil
        self._cacheSheetDetents = []
        self._cacheSheetSizes = []
    }
    
}

extension UI.Container.ModalItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension UI.Container.ModalItem : Equatable {
    
    static func == (lhs: UI.Container.ModalItem, rhs: UI.Container.ModalItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
