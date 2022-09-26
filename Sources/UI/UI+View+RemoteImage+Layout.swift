//
//  KindKit
//

import Foundation

extension UI.View.RemoteImage {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var state: State = .loading {
            didSet(oldValue) {
                guard self.state != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        var placeholder: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.placeholder) }
        }
        var image: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.image) }
        }
        var progress: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.progress) }
        }
        var error: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.error) }
        }

        init() {
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            switch self.state {
            case .loading:
                let placeholderSize: SizeFloat
                if let placeholder = self.placeholder {
                    placeholderSize = placeholder.size(available: bounds.size)
                    placeholder.frame = RectFloat(center: bounds.center, size: placeholderSize)
                } else {
                    placeholderSize = .zero
                }
                if let progress = self.progress {
                    let progressSize = progress.size(available: bounds.size)
                    progress.frame = RectFloat(center: bounds.center, size: progressSize)
                    return Size(
                        width: max(progressSize.width, placeholderSize.height),
                        height: max(progressSize.height, placeholderSize.height)
                    )
                }
                return placeholderSize
            case .loaded:
                if let image = self.image {
                    let imageSize = image.size(available: bounds.size)
                    image.frame = RectFloat(center: bounds.center, size: imageSize)
                    return imageSize
                } else if let placeholder = self.placeholder {
                    let placeholderSize = placeholder.size(available: bounds.size)
                    placeholder.frame = RectFloat(center: bounds.center, size: placeholderSize)
                    return placeholderSize
                }
                return .zero
            case .error:
                if let error = self.error {
                    let errorSize = error.size(available: bounds.size)
                    error.frame = RectFloat(center: bounds.center, size: errorSize)
                    return errorSize
                } else if let placeholder = self.placeholder {
                    let placeholderSize = placeholder.size(available: bounds.size)
                    placeholder.frame = RectFloat(center: bounds.center, size: placeholderSize)
                    return placeholderSize
                }
                return .zero
            }
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            switch self.state {
            case .loading:
                let placeholderSize: SizeFloat
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
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
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
