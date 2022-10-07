//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Input.Text {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Input.Text
        typealias Content = KKInputTextView

        static var reuseIdentificator: String {
            return "InputTextView"
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

final class KKInputTextView : UIView {
    
    unowned var kkDelegate: KKInputTextViewDelegate?
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.kk_update(cornerRadius: view.cornerRadius)
                self.kk_updateShadowPath()
            }
        }
        get { super.frame }
    }
    
    private unowned var _view: UI.View.Input.Text?
    private var _placeholder: UILabel!
    private var _input: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self._placeholder = UILabel()
        self._placeholder.isHidden = true
        self.addSubview(self._placeholder)
        
        self._input = UITextView()
        self._input.backgroundColor = .clear
        self._input.textContainer.lineFragmentPadding = 0
        self._input.layoutManager.usesFontLeading = true
        self._input.delegate = self
        self.addSubview(self._input)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        if let view = self._view {
            let placeholderInset = view.placeholderInset ?? view.textInset
            let placeholderFrame = bounds.inset(by: placeholderInset.uiEdgeInsets)
            let placeholderSize = self._placeholder.sizeThatFits(placeholderFrame.size)
            self._placeholder.frame = CGRect(
                origin: placeholderFrame.origin,
                size: CGSize(width: placeholderFrame.width, height: placeholderSize.height)
            )
        } else {
            self._placeholder.frame = bounds
        }
        self._input.frame = bounds
    }
    
}

extension KKInputTextView {
    
    func update(view: UI.View.Input.Text) {
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
        self._input.text = text
    }
    
    func update(textFont: UI.Font) {
        self._input.font = textFont.native
    }
    
    func update(textColor: UI.Color) {
        self._input.textColor = textColor.native
    }
    
    func update(textInset: InsetFloat) {
        self._input.setNeedsLayout()
    }
    
    func update(editingColor: UI.Color?) {
        self._input.tintColor = editingColor?.native
    }
    
    func update(placeholder: UI.View.Input.Placeholder?) {
        if let placeholder = placeholder {
            self._placeholder.text = placeholder.text
            self._placeholder.font = placeholder.font.native
            self._placeholder.textColor = placeholder.color.native
        } else {
            self._placeholder.text = ""
        }
        self._placeholder.isHidden = self._input.text.isEmpty == false
    }
    
    func update(placeholderInset: InsetFloat?) {
        self.setNeedsLayout()
    }
    
    func update(alignment: UI.Text.Alignment) {
        self._input.textAlignment = alignment.nsTextAlignment
        self._placeholder.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: UI.View.Input.Toolbar?) {
        self._input.inputAccessoryView = toolbar?.native
    }
    
    func update(keyboard: UI.View.Input.Keyboard?) {
        self._input.keyboardType = keyboard?.type ?? .default
        self._input.keyboardAppearance = keyboard?.appearance ?? .default
        self._input.autocapitalizationType = keyboard?.autocapitalization ?? .sentences
        self._input.autocorrectionType = keyboard?.autocorrection ?? .default
        self._input.spellCheckingType = keyboard?.spellChecking ?? .default
        self._input.returnKeyType = keyboard?.returnKey ?? .default
        self._input.enablesReturnKeyAutomatically = keyboard?.enablesReturnKeyAutomatically ?? true
        self._input.textContentType = keyboard?.textContent
    }
    
    func cleanup() {
        self.kkDelegate = nil
        self._view = nil
    }
    
}

extension KKInputTextView : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.kkDelegate?.beginEditing(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let sourceText = (textView.text ?? "") as NSString
        let newText = sourceText.replacingCharacters(in: range, with: text)
        self.kkDelegate?.editing(self, text: newText)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self._placeholder.isHidden = textView.text.isEmpty == false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.kkDelegate?.endEditing(self)
    }

}

#endif
