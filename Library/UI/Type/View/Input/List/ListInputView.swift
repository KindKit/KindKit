//
//  KindKit
//

import Foundation
import KindEvent
import KindGraphics
import KindLayout
import KindText
import KindMonadicMacro

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKListInputViewDelegate : AnyObject {
    
    func kk_beginEditing()
    func kk_endEditing()
    func kk_count() -> Int
    func kk_attributedString(at index: Int) -> NSAttributedString
    func kk_changed(selectedIndex: Int)
    
}

public final class ListInputView< Value : Equatable > : IView, IViewSupportStaticSize, IViewSupportEdit, IViewSupportEditPlaceholder, IViewSupportColor, IViewSupportAlpha, IViewContainToolbar {
    
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
    
    public var placeholderStyle: Style {
        set { self.attributedPlaceholder.style = newValue }
        get { self.attributedPlaceholder.style }
    }
    
    public var placeholderText: Text {
        set { self.attributedPlaceholder.text = newValue }
        get { self.attributedPlaceholder.text }
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
    
#if os(iOS)
    
    public var toolbar: ToolbarView? {
        set { self.accessory.toolbar = newValue }
        get { self.accessory.toolbar }
    }
    
#endif
    
    @MonadicField
    public var style: Style {
        set { self.attributedText.style = newValue }
        get { self.attributedText.style }
    }
    
    @MonadicField
    public var items: [Item] = [] {
        didSet {
            guard self.items != oldValue else { return }
            for item in oldValue {
                item.attributed.onChanged.remove(self)
            }
            for item in self.items {
                item.attributed.onChanged(self, { $0._onItemChanged() })
            }
            if self.isLoaded == true {
                self._layout.view.kk_reload()
            }
            if let defaultItem = self.defaultItem {
                self.defaultIndex = self.items.firstIndex(of: defaultItem)
            }
            if let selectedItem = self.selectedItem {
                self.selectedIndex = self.items.firstIndex(of: selectedItem)
            }
        }
    }
    
    @MonadicField
    public var defaultItem: Item? {
        set {
            if let defaultItem = newValue {
                if let defaultIndex = self.items.firstIndex(of: defaultItem) {
                    self.defaultIndex = defaultIndex
                } else {
                    self.defaultIndex = nil
                }
            } else {
                self.defaultIndex = nil
            }
        }
        get {
            guard let defaultIndex = self.defaultIndex else { return nil }
            return self.items[defaultIndex]
        }
    }
    
    @MonadicField
    public var defaultIndex: Int? {
        set {
            guard self._defaultIndex != newValue else { return }
            if let newValue = newValue {
                if newValue >= self.items.startIndex && newValue < self.items.endIndex {
                    self._defaultIndex = newValue
                } else {
                    self._defaultIndex = nil
                }
            } else {
                self._defaultIndex = nil
            }
        }
        get {
            if let index = self._defaultIndex {
                return index
            }
            if self.items.isEmpty == false {
                return self.items.startIndex
            }
            return nil
        }
    }
    
    @MonadicField
    public var selectedItem: Item? {
        set {
            if let selectedItem = newValue {
                if let selectedIndex = self.items.firstIndex(of: selectedItem) {
                    self.selectedIndex = selectedIndex
                } else {
                    self.selectedIndex = nil
                }
            } else {
                self.selectedIndex = nil
            }
        }
        get {
            guard let selectedIndex = self.selectedIndex else { return nil }
            return self.items[selectedIndex]
        }
    }
    
    @MonadicField
    public var selectedIndex: Int? {
        set {
            guard self._selectedIndex != newValue else { return }
            let item: Item?
            if let newValue = newValue {
                if newValue >= self.items.startIndex && newValue < self.items.endIndex {
                    item = self.items[newValue]
                    self._selectedIndex = newValue
                } else {
                    item = nil
                    self._selectedIndex = nil
                }
            } else {
                item = nil
                self._selectedIndex = nil
            }
            self.attributedText.text = item?.text ?? .empty
            if self.isLoaded == true {
                self._layout.view.kk_update(selectedIndex: self.selectedIndex)
            }
        }
        get {
            if let index = self._selectedIndex {
                return index
            }
            if self.items.isEmpty == false {
                return self.items.startIndex
            }
            return nil
        }
    }
    
    public let onBeginEditing = Signal< Void, Void >()
    public let onEndEditing = Signal< Void, Void >()
    public let onSelect = Signal< Void, Void >()

    internal var attributedText = AttributedText(
        style: .label,
        text: .empty
    )
    
    internal var attributedPlaceholder = AttributedText(
        style: .placeholderLabel,
        text: .empty
    )
    
    internal var accessory = AccessoryView()
    
    private var _layout: ReuseLayoutItem< Reusable >!
    private var _isEditing: Bool = false
    private var _defaultIndex: Int?
    private var _selectedIndex: Int?
    
    public init() {
        self._layout = .init(self)
        do {
            self.attributedText.onChanged(self, { $0._onTextChanged() })
            self.attributedPlaceholder.onChanged(self, { $0._onPlaceholderChanged() })
        }
    }
    
}

extension ListInputView : IViewSupportValue {
    
    @inlinable
    public var value: Item? {
        set { self.selectedItem = newValue }
        get { self.selectedItem }
    }
    
}

private extension ListInputView {
    
    func _onTextChanged() {
        if self.isLoaded == true {
            self._layout.view.kk_update(text: self.attributedText.attributed)
        }
    }
    
    func _onPlaceholderChanged() {
        if self.isLoaded == true {
            self._layout.view.kk_update(placeholder: self.attributedPlaceholder.attributed)
        }
    }
    
    func _onItemChanged() {
        if self.isLoaded == true {
            self._layout.view.kk_reload()
        }
    }

}

extension ListInputView : KKListInputViewDelegate {
    
    func kk_beginEditing() {
        guard self._isEditing == false else { return }
        self._isEditing = true
        self.onBeginEditing.emit()
        if self.selectedIndex == nil {
            if let defaultIndex = self.defaultIndex {
                self.selectedIndex = defaultIndex
                self.onSelect.emit()
            }
        }
    }
    
    func kk_endEditing() {
        guard self._isEditing == true else { return }
        self._isEditing = false
        self.onEndEditing.emit()
    }
    
    func kk_count() -> Int {
        return self.items.count
    }
    
    func kk_attributedString(at index: Int) -> NSAttributedString {
        return self.items[index].attributed.attributed
    }
    
    func kk_changed(selectedIndex: Int) {
        if self.selectedIndex != selectedIndex {
            self.selectedIndex = selectedIndex
            self.onSelect.emit()
        }
    }
    
}

#endif
