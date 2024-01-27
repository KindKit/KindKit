//
//  KindKit
//

import KindTime
import KindUI
import KindMonadicMacro

@KindMonadic
public final class ButtonView< BackgroundType : IView, ContentType : IView > : IComposite, IView {
    
    public let body = PressView< AnyLayout >()

    @KindMonadicProperty
    public var background: BackgroundType? {
        set { self._layout.background = newValue }
        get { self._layout.background }
    }
    
    @KindMonadicProperty
    public var contentInset: Inset {
        set { self._layout.contentInset = newValue }
        get { self._layout.contentInset }
    }
    
    @KindMonadicProperty
    public var content: ContentType? {
        set { self._layout.content = newValue }
        get { self._layout.content }
    }
    
    private let _layout = Layout()
    
    public init() {
        self.body
            .content(.init(self._layout))
            .onChange(self, { $0._onChange() })
    }
    
}

extension ButtonView : IViewDynamicSizeable {
}

extension ButtonView : IViewChangeable {
}

extension ButtonView : IViewHighlightable {
}

extension ButtonView : IViewSelectable {
}

extension ButtonView : IViewEnableable {
}

extension ButtonView : IViewAlphable {
}

#if os(macOS)

extension ButtonView : IViewClickable {
}

#elseif os(iOS)

extension ButtonView : IViewPressable {
}

#endif

private extension ButtonView {

    func _onChange() {
        if let child = self.background {
            if let child = child as? IViewHighlightable {
                child.isHighlighted = self.isHighlighted
            }
            if let child = child as? IViewSelectable {
                child.isSelected = self.isSelected
            }
        }
        if let child = self.content {
            if let child = child as? IViewHighlightable {
                child.isHighlighted = self.isHighlighted
            }
            if let child = child as? IViewSelectable {
                child.isSelected = self.isSelected
            }
        }
    }
    
}
