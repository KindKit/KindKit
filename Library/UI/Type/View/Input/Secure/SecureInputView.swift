//
//  KindKit
//

import KindEvent
import KindGraphics
import KindLayout
import KindText
import KindMonadicMacro

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKSecureInputViewDelegate : AnyObject {
    
    func kk_beginEditing()
    func kk_endEditing()
    func kk_enter()
    func kk_changed(selectionRange: Range< Int >?)
    func kk_changed(string: String)

}

@Monadic
public final class SecureInputView : IView, IViewSupportStaticSize, IViewSupportEdit, IViewSupportEditSelection, IViewSupportEditPlaceholder, IViewSupportVirtualKeyboard, IViewSupportColor, IViewSupportAlpha, IViewContainToolbar {
    
    public var layout: some ILayoutItem {
        return self._layout
    }
    
    public var size: StaticSize = .init(width: .fill, height: .fixed(28)) {
        didSet {
            guard self.size != oldValue else { return }
            self.updateLayout(force: true)
        }
    }
    
    public var shouldEditing: Bool = true {
        didSet {
            guard self.shouldEditing != oldValue && self.shouldEditing == false else { return }
            self.isEditing = false
        }
    }
    
    public var isEditing: Bool {
        set {
            guard self._isEditing != newValue else { return }
            self._isEditing = newValue
            if self.isLoaded == true {
                self._layout.view.kk_update(isEditing: self._isEditing)
            }
        }
        get { self._isEditing }
    }
    
    public var selectionRange: Range< Int >? {
        set {
            guard self._selectionRange != newValue else { return }
            self._selectionRange = newValue
            if self.isLoaded == true {
                self._layout.view.kk_update(selectionRange: self._selectionRange)
            }
        }
        get { self._selectionRange }
    }
    
    public var selectionColor: Color = .systemFieldSelectionColor {
        didSet {
            guard self.selectionColor != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(selectionColor: self.selectionColor)
            }
        }
    }
    
    public var placeholderStyle: Style {
        set { self.attributedPlaceholder.style = newValue }
        get { self.attributedPlaceholder.style }
    }
    
    public var placeholderText: Text {
        set { self.attributedPlaceholder.text = newValue }
        get { self.attributedPlaceholder.text }
    }
    
#if os(iOS)
    
    public var virtualKeyboard: VirtualInput.Style? {
        didSet {
            guard self.virtualKeyboard != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(virtualKeyboard: self.virtualKeyboard)
            }
        }
    }
    
#endif
    
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
    
#if os(iOS)
    
    public var toolbar: ToolbarView? {
        set { self.accessory.toolbar = newValue }
        get { self.accessory.toolbar }
    }
    
#endif
    
    @MonadicField
    public var isDisplayValue: Bool = false {
        didSet {
            guard self.isDisplayValue != oldValue else { return }
            if self.isLoaded == true {
                self._layout.view.kk_update(isDisplayValue: self.isDisplayValue)
            }
        }
    }
    
    @MonadicField
    public var style: Style = .label {
        willSet {
            guard self.style != newValue else { return }
            self.style.onChanged(remove: self)
        }
        didSet {
            guard self.style != oldValue else { return }
            self.style.onChanged(self, { $0._onStyleChanged() })
            if self.isLoaded == true {
                self._layout.view.kk_update(style: self.style)
            }
        }
    }
    
    @MonadicField
    public var string: String {
        set {
            guard self._string != newValue else { return }
            self._string = newValue
            if self.isLoaded == true {
                self._layout.view.kk_update(string: self._string)
            }
        }
        get {
            return self._string
        }
    }
    
    public let onSelectionRange = Signal< Void, Void >()
    public let onBeginEditing = Signal< Void, Void >()
    public let onEditing = Signal< Void, Void >()
    public let onEndEditing = Signal< Void, Void >()
    public let onEnter = Signal< Void, Void >()
    
    internal var attributedPlaceholder = AttributedText(
        style: .placeholderLabel,
        text: .empty
    )
    
    internal var accessory = AccessoryView()
    
    private var _layout: ReuseLayoutItem< Reusable >!
    private var _isEditing: Bool = false
    private var _selectionRange: Range< Int >?
    private var _string: String = ""
    
    public init() {
        self._layout = .init(self)
        do {
            self.style.onChanged(self, { $0._onStyleChanged() })
            self.attributedPlaceholder.onChanged(self, { $0._onPlaceholderChanged() })
        }
    }
    
    deinit {
        self.style.onChanged(remove: self)
    }
    
}

extension SecureInputView : IViewSupportValue {
    
    @inlinable
    public var value: String {
        set { self.string = newValue }
        get { self.string }
    }
    
}

private extension SecureInputView {
    
    func _onStyleChanged() {
        if self.isLoaded == true {
            self._layout.view.kk_update(style: self.style)
        }
    }
    
    func _onPlaceholderChanged() {
        if self.isLoaded == true {
            self._layout.view.kk_update(placeholder: self.attributedPlaceholder.attributed)
        }
    }

}

extension SecureInputView : KKSecureInputViewDelegate {
    
    func kk_beginEditing() {
        guard self._isEditing == false else { return }
        self._isEditing = true
        self.onBeginEditing.emit()
    }
    
    func kk_endEditing() {
        guard self._isEditing == true else { return }
        self._isEditing = false
        self.onEndEditing.emit()
    }
    
    func kk_enter() {
        self.onEnter.emit()
    }
    
    func kk_changed(selectionRange: Range< Int >?) {
        guard self._selectionRange != selectionRange else { return }
        self._selectionRange = selectionRange
        self.onSelectionRange.emit()
    }
    
    func kk_changed(string: String) {
        if self._string != string {
            self._string = string
            self.onEditing.emit()
        }
    }
    
}

#endif
