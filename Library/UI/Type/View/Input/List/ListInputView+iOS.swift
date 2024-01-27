//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindGeometry

extension ListInputView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ListInputView
        typealias Content = KKListInputView

        static func name(owner: Owner) -> String {
            return "ListInputView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init()
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup()
        }
        
    }
    
}

final class KKListInputView : UITextField {
    
    weak var kkDelegate: KKListInputViewDelegate?
    let kkPickerView: UIPickerView
    
    override init(frame: CGRect) {
        self.kkPickerView = UIPickerView()

        super.init(frame: frame)
        
        self.kkPickerView.dataSource = self
        self.kkPickerView.delegate = self
        self.inputAssistantItem.leadingBarButtonGroups = []
        self.inputAssistantItem.trailingBarButtonGroups = []
        self.inputView = self.kkPickerView
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds
    }

}

extension KKListInputView {
    
    final func kk_update< Value : Equatable >(view: ListInputView< Value >) {
        self.kk_update(frame: view.frame)
        self.kk_update(text: view.attributedText.attributed)
        self.kk_update(placeholder: view.attributedPlaceholder.attributed)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.inputAccessoryView = view.accessory
        self.kkDelegate = view
        self.kk_reload()
        self.kk_update(selectedIndex: view.selectedIndex)
        self.kk_update(isEditing: view.isEditing)
    }
    
    final func kk_cleanup() {
        self.kkDelegate = nil
        self.inputAccessoryView = nil
        self.kkPickerView.reloadAllComponents()
    }
    
}

extension KKListInputView {
    
    final func kk_update(isEditing: Bool) {
        if isEditing == true {
            self.becomeFirstResponder()
        } else {
            self.endEditing(false)
        }
    }
    
    final func kk_update(selectedIndex: Int?) {
        guard let selectedIndex = selectedIndex else { return }
        self.kkPickerView.selectRow(selectedIndex, inComponent: 0, animated: self.isFirstResponder)
    }
    
    final func kk_update(text: NSAttributedString) {
        self.attributedText = text
    }
    
    final func kk_update(placeholder: NSAttributedString) {
        self.attributedPlaceholder = placeholder
    }
    
    final func kk_update(color: Color) {
        self.backgroundColor = color.native
    }
    
    final func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    final func kk_reload() {
        self.kkPickerView.reloadAllComponents()
    }
    
}

extension KKListInputView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let delegate = self.kkDelegate else { return }
        delegate.kk_beginEditing()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let delegate = self.kkDelegate else { return }
        delegate.kk_endEditing()
    }
    
}

extension KKListInputView : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let delegate = self.kkDelegate else { return 0 }
        return delegate.kk_count()
    }
    
}

extension KKListInputView : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let delegate = self.kkDelegate else { return nil }
        return delegate.kk_attributedString(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let delegate = self.kkDelegate else { return }
        delegate.kk_changed(selectedIndex: row)
    }
    
}

#endif
