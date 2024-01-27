//
//  KindKit
//

import KindUI

extension View {
    
    final class Layout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
        var state: State = .loading {
            didSet {
                guard self.state != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var placeholder: IView? {
            didSet { self.setNeedUpdate(self.placeholder) }
        }
        var image: IView? {
            didSet { self.setNeedUpdate(self.image) }
        }
        var progress: IView? {
            didSet { self.setNeedUpdate(self.progress) }
        }
        var error: IView? {
            didSet { self.setNeedUpdate(self.error) }
        }

        init() {
        }
        
        func layout(bounds: Rect) -> Size {
            switch self.state {
            case .loading:
                let placeholderSize: Size
                if let placeholder = self.placeholder {
                    placeholderSize = placeholder.size(available: bounds.size)
                    placeholder.frame = Rect(center: bounds.center, size: placeholderSize)
                } else {
                    placeholderSize = .zero
                }
                if let progress = self.progress {
                    let progressSize = progress.size(available: bounds.size)
                    progress.frame = Rect(center: bounds.center, size: progressSize)
                    return Size(
                        width: max(progressSize.width, placeholderSize.height),
                        height: max(progressSize.height, placeholderSize.height)
                    )
                }
                return placeholderSize
            case .loaded:
                if let image = self.image {
                    let imageSize = image.size(available: bounds.size)
                    image.frame = Rect(center: bounds.center, size: imageSize)
                    return imageSize
                } else if let placeholder = self.placeholder {
                    let placeholderSize = placeholder.size(available: bounds.size)
                    placeholder.frame = Rect(center: bounds.center, size: placeholderSize)
                    return placeholderSize
                }
                return .zero
            case .error:
                if let error = self.error {
                    let errorSize = error.size(available: bounds.size)
                    error.frame = Rect(center: bounds.center, size: errorSize)
                    return errorSize
                } else if let placeholder = self.placeholder {
                    let placeholderSize = placeholder.size(available: bounds.size)
                    placeholder.frame = Rect(center: bounds.center, size: placeholderSize)
                    return placeholderSize
                }
                return .zero
            }
        }
        
        func size(available: Size) -> Size {
            switch self.state {
            case .loading:
                let placeholderSize: Size
                if let placeholder = self.placeholder {
                    placeholderSize = placeholder.size(available: available)
                } else {
                    placeholderSize = .zero
                }
                if let progress = self.progress {
                    let progressSize = progress.size(available: available)
                    return Size(
                        width: max(progressSize.width, placeholderSize.height),
                        height: max(progressSize.height, placeholderSize.height)
                    )
                }
                return placeholderSize
            case .loaded:
                if let image = self.image {
                    return image.size(available: available)
                } else if let placeholder = self.placeholder {
                    return placeholder.size(available: available)
                }
                return .zero
            case .error:
                if let error = self.error {
                    return error.size(available: available)
                } else if let placeholder = self.placeholder {
                    return placeholder.size(available: available)
                }
                return .zero
            }
        }
        
        func views(bounds: Rect) -> [IView] {
            switch self.state {
            case .loading:
                if let placeholder = self.placeholder {
                    if let progress = self.progress {
                        return [ placeholder, progress ]
                    }
                } else if let progress = self.progress {
                    return [ progress ]
                }

            case .loaded:
                if let image = self.image {
                    return [ image ]
                }
                if let placeholder = self.placeholder {
                    return [ placeholder ]
                }
            case .error:
                if let error = self.error {
                    return [ error ]
                }
            }
            if let placeholder = self.placeholder {
                return [ placeholder ]
            }
            return []
        }
        
    }
    
}
