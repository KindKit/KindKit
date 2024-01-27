//
//  KindKit
//

import Foundation
import KindEvent
import KindLayout
import KindText

protocol KKTextViewDelegate : AnyObject {
    
    func kk_shouldTap() -> Bool
    
    func kk_tap(at index: Text.Index)
    
}

public final class TextView : IView, IViewSupportDynamicSize, IViewSupportText, IViewSupportColor, IViewSupportAlpha {
    
    public var layout: some ILayoutItem {
        return self._layout
    }

    public var size: DynamicSize = .fit {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    public var style: Style {
        set {
            guard self._baseStyle != newValue else { return }
            self._attributed = nil
            self._baseStyle.onChanged(remove: self)
            self._baseStyle = newValue
            self._baseStyle.onChanged(self, { $0._onChangeStyle() })
            if self.isLoaded == true {
                self._layout.view.kk_update(attributed: self.attributed)
            }
            self.updateLayout(force: true)
        }
        get {
            return self._baseStyle
        }
    }
    
    public var text: Text {
        didSet {
            guard self.text != oldValue else { return }
            self._attributed = nil
            self._textStyles = self.text.styles
            if self.isLoaded == true {
                self._layout.view.kk_update(attributed: self.attributed)
            }
            self.updateLayout(force: true)
        }
    }
    
    public var numberOfLines: UInt = 0 {
        didSet {
            guard self.numberOfLines != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(numberOfLines: self.numberOfLines)
            }
            self.updateLayout(force: true)
        }
    }
    
    public var color: Color = .clear {
        didSet {
            guard self.color != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(color: self.color)
            }
        }
    }
    
    public var alpha: Double = 1 {
        didSet {
            guard self.alpha != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(alpha: self.alpha)
            }
        }
    }
    
    public let onTap = Signal< Void, URL >()
    
    var attributed: NSAttributedString {
        if self._attributed == nil {
            self._attributed = .kk_make(self.text, base: self.style)
        }
        return self._attributed!
    }
    
    private var _layout: ReuseLayoutItem< Reusable >!
    private var _baseStyle: Style = .default
    private var _textStyles: [Style] = [] {
        willSet {
            guard self._textStyles != newValue else { return }
            for textStyle in self._textStyles {
                textStyle.onChanged(remove: self)
            }
        }
        didSet {
            guard self._textStyles != oldValue else { return }
            for textStyle in self._textStyles {
                textStyle.onChanged(self, { $0._onChangeStyle() })
            }
        }
    }
    private var _attributed: NSAttributedString?
    
    public init(_ text: Text) {
        self.text = text
        self._layout = .init(self)
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.size.resolve(
            by: request,
            calculate: {
                return self.attributed.kk_size(
                    numberOfLines: self.numberOfLines,
                    available: $0
                )
            }
        )
    }
    
}

extension TextView : IViewSupportStyleSheet {
    
    public func apply(_ styleSheet: TextStyleSheet) -> Self {
        if let style = styleSheet.style {
            self.style = style
        }
        if let text = styleSheet.text {
            self.text = text
        }
        if let numberOfLines = styleSheet.numberOfLines {
            self.numberOfLines = numberOfLines
        }
        if let color = styleSheet.color {
            self.color = color
        }
        if let alpha = styleSheet.alpha {
            self.alpha = alpha
        }
        return self
    }
    
}

private extension TextView {
    
    func _onChangeStyle() {
        self._attributed = nil
        if self.isLoaded == true {
            self._layout.view.kk_update(attributed: self.attributed)
        }
        self.updateLayout(force: true)
    }

}

extension TextView : KKTextViewDelegate {
    
    func kk_shouldTap() -> Bool {
        return self.text.shouldLink
    }
    
    func kk_tap(at index: Text.Index) {
        guard let url = self.text.link(at: index) else { return }
        self.onTap.emit(url)
    }
    
}
