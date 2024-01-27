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
        set { self.attributedText.style = newValue }
        get { self.attributedText.style }
    }
    
    public var text: Text {
        set { self.attributedText.text = newValue }
        get { self.attributedText.text }
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
    
    internal let attributedText: AttributedText
    
    private var _layout: ReuseLayoutItem< Reusable >!
    
    public init(
        style: Style = .label,
        text: Text
    ) {
        self.attributedText = .init(
            style: style,
            text: text
        )
        self._layout = .init(self)
        
        do {
            self.attributedText.onChanged(self, { $0._onChanged() })
        }
    }
    
    deinit {
        self.attributedText.onChanged(remove: self)
    }
    
    public convenience init(
        style: Style = .label,
        string: String = "",
        options: Text.Options? = nil
    ) {
        self.init(
            style: style,
            text: .init(string, options: options)
        )
    }
    
    public convenience init(
        style: Style = .label,
        @KindText.ComponentsBuilder _ builder: () -> [IComponent]
    ) {
        self.init(
            style: style,
            text: .init(builder)
        )
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return self.size.resolve(
            by: request,
            calculate: {
                return self.attributedText.attributed.kk_size(
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
    
    func _onChanged() {
        if self.isLoaded == true {
            self._layout.view.kk_update(attributed: self.attributedText.attributed)
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
