//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Input.String {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Input.String
        typealias Content = KKInputStringView

        static var reuseIdentificator: String {
            return "InputStringView"
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

final class KKInputStringView : UITextField {
    
    unowned var kkDelegate: KKInputStringViewDelegate?
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.delegate = self
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

extension KKInputStringView {
    
    func update(view: UI.View.Input.String) {
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
        self.kkTextInset = textInset.uiEdgeInsets
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
        self.kkPlaceholderInset = placeholderInset?.uiEdgeInsets
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
    }
    
}

extension KKInputStringView : UITextFieldDelegate {

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
