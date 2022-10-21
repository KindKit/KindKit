//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Input.List {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Input.List
        typealias Content = KKInputListView

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

final class KKInputListView : UITextField {
    
    unowned var kkDelegate: KKInputListViewDelegate?
    var kkItems: [IInputListItem] = [] {
        didSet {
            self._picker.reloadAllComponents()
            self._applyText()
        }
    }
    var kkSelected: IInputListItem? {
        didSet {
            guard self.kkSelected !== oldValue else { return }
            let animated = self.isFirstResponder
            if let selected = self.kkSelected {
                if let index = self.kkItems.firstIndex(where: { $0 === selected }) {
                    self._picker.selectRow(index, inComponent: 0, animated: animated)
                } else {
                    self._picker.selectRow(0, inComponent: 0, animated: animated)
                }
            } else {
                self._picker.selectRow(0, inComponent: 0, animated: animated)
            }
            self._applyText()
        }
    }
    var kkTextInset: UIEdgeInsets = .zero {
        didSet {
            guard self.kkTextInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkPlaceholderInset: UIEdgeInsets? {
        didSet {
            guard self.kkPlaceholderInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }

    private var _picker: UIPickerView
    
    override init(frame: CGRect) {
        self._picker = UIPickerView()

        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.delegate = self
        
        self._picker.dataSource = self
        self._picker.delegate = self
        self.inputView = self._picker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.kkTextInset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.kkTextInset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let inset = self.kkPlaceholderInset ?? self.kkTextInset
        return bounds.inset(by: inset)
    }

}

extension KKInputListView {
    
    func update(view: UI.View.Input.List) {
        self.update(items: view.items)
        self.update(selected: view.selected, userInteraction: false)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(textInset: view.textInset)
        self.update(placeholder: view.placeholder)
        self.update(placeholderInset: view.placeholderInset)
        self.update(alignment: view.alignment)
        self.update(toolbar: view.toolbar)
        self.kkDelegate = view
    }
    
    func update(items: [IInputListItem]) {
        self.kkItems = items
    }
    
    func update(selected: IInputListItem?, userInteraction: Bool) {
        self.kkSelected = selected
    }
    
    func update(textFont: UI.Font) {
        self.font = textFont.native
    }
    
    func update(textColor: UI.Color) {
        self.textColor = textColor.native
    }
    
    func update(textInset: InsetFloat) {
        self.kkTextInset = textInset.uiEdgeInsets
    }
    
    func update(placeholder: UI.View.Input.Placeholder?) {
        if let placeholder = placeholder {
            self.attributedPlaceholder = NSAttributedString(string: placeholder.text, attributes: [
                .font: placeholder.font.native,
                .foregroundColor: placeholder.color.native
            ])
        } else {
            self.attributedPlaceholder = nil
        }
    }
    
    func update(placeholderInset: InsetFloat?) {
        self.kkPlaceholderInset = placeholderInset?.uiEdgeInsets
    }
    
    func update(alignment: UI.Text.Alignment) {
        self.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: UI.View.Input.Toolbar?) {
        self.inputAccessoryView = toolbar?.native
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKInputListView {
    
    func _applyText() {
        if let selected = self.kkSelected {
            self.text = selected.title
        } else {
            self.text = nil
        }
    }
    
}

extension KKInputListView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.kkDelegate?.beginEditing(self)
        if self.kkSelected == nil, let firstItem = self.kkItems.first {
            self.kkDelegate?.select(self, item: firstItem)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.kkDelegate?.endEditing(self)
    }
    
}

extension KKInputListView : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.kkItems.count
    }
    
}

extension KKInputListView : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.kkItems[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = self.kkItems[row]
        if self.kkSelected !== selected {
            self.kkDelegate?.select(self, item: selected)
        }
    }
    
}

#endif
