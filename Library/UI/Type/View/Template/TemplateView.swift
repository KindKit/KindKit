//
//  KindKit
//

import KindEvent
import KindLayout
import KindStyleSheet
import KindMonadicMacro

@Monadic
public final class TemplateView< Template : ITemplate > : CompositorTrait, IView, IViewSupportContent, IViewContainTemplate {
    
    public let body: LayoutView< Template.Layout >
    
    @MonadicField
    public var styleSheet: Template.StyleSheet {
        didSet {
            guard self.styleSheet != oldValue else { return }
            self.activeStyleSheet = self.styleSheet.resolve(self._styleState)
        }
    }
    
    public private(set) var activeStyleSheet: Template.StyleSheet.Resolve {
        didSet {
            guard self.activeStyleSheet != oldValue else { return }
            self.content.apply(self.activeStyleSheet)
        }
    }
    
    public var content: Template {
        didSet {
            guard self.content != oldValue else { return }
            self.body.content = self.content
        }
    }
    
    private var _styleState: KindStyleSheet.States = [] {
        didSet {
            self.activeStyleSheet = self.styleSheet.resolve(self._styleState)
        }
    }
    
    private var _isHighlighted: Bool = false {
        didSet {
            guard self._isHighlighted != oldValue else { return }
            if self._isHighlighted == true {
                self._styleState.insert(.hightlighted)
            } else {
                self._styleState.remove(.hightlighted)
            }
            self._onHighlighted.emit()
        }
    }
    
    private var _isSelected: Bool = false {
        didSet {
            guard self._isSelected != oldValue else { return }
            if self._isSelected == true {
                self._styleState.insert(.selected)
            } else {
                self._styleState.remove(.selected)
            }
            self._onSelected.emit()
        }
    }
    
    private var _isEnabled: Bool = true {
        didSet {
            guard self._isEnabled != oldValue else { return }
            if self._isEnabled == false {
                self._styleState.insert(.disabled)
            } else {
                self._styleState.remove(.disabled)
            }
            self._onEnabled.emit()
        }
    }
    
    private let _onHighlighted = Signal< Void, Void >()
    
    private let _onSelected = Signal< Void, Void >()
    
    private let _onEnabled = Signal< Void, Void >()
    
    public init(
        content: Template,
        styleSheet: Template.StyleSheet
    ) {
        self.styleSheet = styleSheet
        self.activeStyleSheet = styleSheet.resolve([])
        self.content = content

        self.body = .init(content.layout)
        
        self.content.apply(self.activeStyleSheet)
    }
    
}

extension TemplateView : IViewSupportHighlighted where Content.StyleSheet : HighlightedStyleSheetTrait {
    
    public var isHighlighted: Bool {
        set { self._isHighlighted = newValue }
        get { self._isHighlighted }
    }
    
    public var onHighlighted: Signal< Void, Void > {
        self._onHighlighted
    }

}

extension TemplateView : IViewSupportSelected where Content.StyleSheet : SelectedStyleSheetTrait {
    
    public var isSelected: Bool {
        set { self._isSelected = newValue }
        get { self._isSelected }
    }
    
    public var onSelected: Signal< Void, Void > {
        self._onSelected
    }
    
}

extension TemplateView : IViewSupportEnable where Content.StyleSheet : DisabledStyleSheetTrait {
    
    public var isEnabled: Bool {
        set { self._isEnabled = newValue }
        get { self._isEnabled }
    }
    
    public var onEnabled: Signal< Void, Void > {
        self._onEnabled
    }
    
}
