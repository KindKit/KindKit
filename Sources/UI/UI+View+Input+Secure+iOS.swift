//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Input.Secure {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Input.Secure
        typealias Content = KKInputSecureView

        static var reuseIdentificator: String {
            return "InputSecureView"
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

final class KKInputSecureView : UITextField {
    
    unowned var kkDelegate: KKInputSecureViewDelegate?
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.kk_update(cornerRadius: view.cornerRadius)
                self.kk_updateShadowPath()
            }
        }
        get { return super.frame }
    }
    
    private unowned var _view: UI.View.Input.Secure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.isSecureTextEntry = true
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        guard let view = self._view else { return bounds }
        return Rect(bounds).inset(view.textInset).cgRect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard let view = self._view else { return bounds }
        return Rect(bounds).inset(view.textInset).cgRect
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard let view = self._view else { return bounds }
        let inset = view.placeholderInset ?? view.textInset
        return Rect(bounds).inset(inset).cgRect
    }
    
}

extension KKInputSecureView {
    
    func update(view: UI.View.Input.Secure) {
        self._view = view
        self.update(text: view.text)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(textInset: view.textInset)
        self.update(editingColor: view.editingColor)
        self.update(placeholder: view.placeholder)
        self.update(placeholderInset: view.placeholderInset)
        self.update(alignment: view.alignment)
        self.update(toolbar: view.toolbar)
        self.update(keyboard: view.keyboard)
        self.kk_update(color: view.color)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(alpha: view.alpha)
        self.kk_updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(text: Swift.String) {
        self.text = text
    }
    
    func update(textFont: UI.Font) {
        self.font = textFont.native
    }
    
    func update(textColor: UI.Color) {
        self.textColor = textColor.native
    }
    
    func update(textInset: InsetFloat) {
        self.setNeedsLayout()
    }
    
    func update(editingColor: UI.Color?) {
        self.tintColor = editingColor?.native
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
        self.setNeedsLayout()
    }
    
    func update(alignment: UI.Text.Alignment) {
        self.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: UI.View.Input.Toolbar?) {
        self.inputAccessoryView = toolbar?.native
    }
    
    func update(keyboard: UI.View.Input.Keyboard?) {
        self.keyboardType = keyboard?.type ?? .default
        self.keyboardAppearance = keyboard?.appearance ?? .default
        self.autocapitalizationType = keyboard?.autocapitalization ?? .sentences
        self.autocorrectionType = keyboard?.autocorrection ?? .default
        self.spellCheckingType = keyboard?.spellChecking ?? .default
        self.returnKeyType = keyboard?.returnKey ?? .default
        self.enablesReturnKeyAutomatically = keyboard?.enablesReturnKeyAutomatically ?? true
        self.textContentType = keyboard?.textContent
    }
    
    func cleanup() {
        self.kkDelegate = nil
        self._view = nil
    }
    
}

extension KKInputSecureView : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.kkDelegate?.beginEditing(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let sourceText = (textField.text ?? "") as NSString
        let newText = sourceText.replacingCharacters(in: range, with: string)
        self.kkDelegate?.editing(self, text: newText)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.kkDelegate?.endEditing(self)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.kkDelegate?.pressedReturn(self)
        return true
    }

}

#endif