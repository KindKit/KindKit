//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindGeometry
import KindText

extension SecureInputView {
    
    struct Reusable : IReusable {
        
        typealias Owner = SecureInputView
        typealias Content = KKSecureInputView

        static func name(owner: Owner) -> String {
            return "SecureInputView"
        }
        
        static func create(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup()
        }
        
    }
    
}

final class KKSecureInputView : UITextField {
    
    weak var kkDelegate: KKSecureInputViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isSecureTextEntry = true
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension KKSecureInputView {
    
    final func kk_update(view: SecureInputView) {
        self.kk_update(isDisplayValue: view.isDisplayValue)
        self.kk_update(virtualKeyboard: view.virtualKeyboard)
        self.kk_update(frame: view.frame)
        self.kk_update(style: view.style)
        self.kk_update(placeholder: view.attributedPlaceholder.attributed)
        self.kk_update(string: view.string)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.inputAccessoryView = view.accessory
        self.kkDelegate = view
        self.kk_update(isEditing: view.isEditing)
    }
    
    final func kk_cleanup() {
        self.kkDelegate = nil
        self.inputAccessoryView = nil
    }
    
}

extension KKSecureInputView {
    
    final func kk_update(isDisplayValue: Bool) {
        self.isSecureTextEntry = !isDisplayValue
    }
    
    final func kk_update(style: Style) {
        self.defaultTextAttributes = style.attribures(flags: [])
    }
    
    final func kk_update(isEditing: Bool) {
        if isEditing == true {
            self.becomeFirstResponder()
        } else {
            self.endEditing(false)
        }
    }
    
    final func kk_update(selectionRange: Range< Int >?) {
        if let selectionRange = selectionRange {
            self.kk_update(selectionRange: selectionRange)
        } else {
            self.selectedTextRange = nil
        }
    }
    
    final func kk_update(selectionRange: Range< Int >) {
        guard let from = self.position(from: self.beginningOfDocument, offset: selectionRange.lowerBound) else {
            self.selectedTextRange = nil
            return
        }
        guard let to = self.position(from: self.beginningOfDocument, offset: selectionRange.upperBound) else {
            self.selectedTextRange = nil
            return
        }
        self.selectedTextRange = self.textRange(from: from, to: to)
    }
    
    final func kk_update(selectionColor: Color) {
        self.tintColor = selectionColor.native
    }
    
    final func kk_update(string: String) {
        self.text = string
    }
    
    final func kk_update(placeholder: NSAttributedString) {
        self.attributedPlaceholder = placeholder
    }
    
    final func kk_update(virtualKeyboard: VirtualInput.Style?) {
        self.keyboardType = virtualKeyboard?.type ?? .default
        self.keyboardAppearance = virtualKeyboard?.appearance ?? .default
        self.autocapitalizationType = virtualKeyboard?.autocapitalization ?? .sentences
        self.autocorrectionType = virtualKeyboard?.autocorrection ?? .default
        self.spellCheckingType = virtualKeyboard?.spellChecking ?? .default
        self.returnKeyType = virtualKeyboard?.returnKey ?? .default
        self.enablesReturnKeyAutomatically = virtualKeyboard?.enablesReturnKeyAutomatically ?? true
        self.textContentType = virtualKeyboard?.textContent
    }
    
    final func kk_update(color: Color) {
        self.backgroundColor = color.native
    }
    
    final func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
}

extension KKSecureInputView : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let delegate = self.kkDelegate else { return }
        delegate.kk_beginEditing()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let delegate = self.kkDelegate else { return false }
        let old = (textField.text ?? "") as NSString
        let new = old.replacingCharacters(in: range, with: string)
        delegate.kk_changed(string: new)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let delegate = self.kkDelegate else { return }
        delegate.kk_endEditing()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let delegate = self.kkDelegate else { return }
        if let range = textField.selectedTextRange {
            let start = self.offset(from: textField.beginningOfDocument, to: range.start)
            let delta = self.offset(from: range.start, to: range.end)
            delegate.kk_changed(selectionRange: start ..< (start + delta))
        } else {
            delegate.kk_changed(selectionRange: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let delegate = self.kkDelegate else { return false }
        delegate.kk_enter()
        return true
    }

}

#endif
