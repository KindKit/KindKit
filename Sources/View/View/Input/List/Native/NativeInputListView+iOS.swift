//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension InputListView {
    
    struct Reusable : IReusable {
        
        typealias Owner = InputListView
        typealias Content = NativeInputListView

        static var reuseIdentificator: String {
            return "InputListView"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class NativeInputListView : UITextField {
    
    typealias View = IInputListView
    
    unowned var customDelegate: InputListViewDelegate?
    override var frame: CGRect {
        set(value) {
            if super.frame != value {
                super.frame = value
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
            }
        }
        get { return super.frame }
    }
    
    private unowned var _view: View?
    private var _picker: UIPickerView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.delegate = self
        
        self._picker = UIPickerView()
        self._picker.dataSource = self
        self._picker.delegate = self
        self.inputView = self._picker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        guard let view = self._view else { return bounds }
        return RectFloat(bounds).inset(view.textInset).cgRect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard let view = self._view else { return bounds }
        return RectFloat(bounds).inset(view.textInset).cgRect
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard let view = self._view else { return bounds }
        let inset = view.placeholderInset ?? view.textInset
        return RectFloat(bounds).inset(inset).cgRect
    }
    
}

extension NativeInputListView {
    
    func update(view: InputListView) {
        self._view = view
        self.update(items: view.items)
        self.update(selectedItem: view.selectedItem, userInteraction: false)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(textInset: view.textInset)
        self.update(placeholder: view.placeholder)
        self.update(placeholderInset: view.placeholderInset)
        self.update(alignment: view.alignment)
        self.update(toolbar: view.toolbar)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.customDelegate = view
    }
    
    func update(items: [IInputListViewItem]) {
        self._picker.reloadAllComponents()
        self._applyText()
    }
    
    func update(selectedItem: IInputListViewItem?, userInteraction: Bool) {
        if userInteraction == false {
            let animated = self.isFirstResponder
            if let view = self._view, let selectedItem = selectedItem {
                if let index = view.items.firstIndex(where: { $0 === selectedItem }) {
                    self._picker.selectRow(index, inComponent: 0, animated: animated)
                } else {
                    self._picker.selectRow(0, inComponent: 0, animated: animated)
                }
            } else {
                self._picker.selectRow(0, inComponent: 0, animated: animated)
            }
        }
        self._applyText()
    }
    
    func update(textFont: Font) {
        self.font = textFont.native
    }
    
    func update(textColor: Color) {
        self.textColor = textColor.native
    }
    
    func update(textInset: InsetFloat) {
        self.setNeedsLayout()
    }
    
    func update(placeholder: InputPlaceholder) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder.text, attributes: [
            .font: placeholder.font.native,
            .foregroundColor: placeholder.color.native
        ])
    }
    
    func update(placeholderInset: InsetFloat?) {
        self.setNeedsLayout()
    }
    
    func update(alignment: TextAlignment) {
        self.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: IInputToolbarView?) {
        self.inputAccessoryView = toolbar?.native
    }
    
    func cleanup() {
        self.customDelegate = nil
        self._view = nil
    }
    
}

private extension NativeInputListView {
    
    func _applyText() {
        if let view = self._view, let selectedItem = view.selectedItem {
            self.text = selectedItem.title
        } else {
            self.text = nil
        }
    }
    
}

extension NativeInputListView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.customDelegate?.beginEditing()
        if self._view?.selectedItem == nil, let firstItem = self._view?.items.first {
            self.customDelegate?.select(item: firstItem)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.customDelegate?.endEditing()
    }
    
}

extension NativeInputListView : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let view = self._view else { return 0 }
        return view.items.count
    }
    
}

extension NativeInputListView : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let view = self._view else { return nil }
        return view.items[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let view = self._view else { return }
        let selectedItem = view.items[row]
        if view.selectedItem !== selectedItem {
            self.customDelegate?.select(item: selectedItem)
        }
    }
    
}

#endif
