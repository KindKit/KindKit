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
    
    weak var kkDelegate: KKInputTextViewDelegate?
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

    private var _placeholder: UILabel
    private var _input: UITextView
    
    override init(frame: CGRect) {
        self._placeholder = UILabel()
        self._placeholder.isHidden = true

        self._input = UITextView()
        self._input.backgroundColor = .clear
        self._input.textContainer.lineFragmentPadding = 0
        self._input.layoutManager.usesFontLeading = true

        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self.addSubview(self._placeholder)
        
        self._input.delegate = self
        self.addSubview(self._input)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let placeholderInset = self.kkPlaceholderInset ?? self.kkTextInset
        let placeholderFrame = bounds.inset(by: placeholderInset)
        let placeholderSize = self._placeholder.sizeThatFits(placeholderFrame.size)
        self._placeholder.frame = CGRect(
            origin: placeholderFrame.origin,
            size: CGSize(width: placeholderFrame.width, height: placeholderSize.height)
        )
        self._input.frame = bounds
    }
    
}

extension KKInputTextView {
    
    func update(view: UI.View.Input.Text) {
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
        self._input.text = text
    }
    
    func update(textFont: UI.Font) {
        self._input.font = textFont.native
    }
    
    func update(textColor: UI.Color) {
        self._input.textColor = textColor.native
    }
    
    func update(textInset: InsetFloat) {
        self.kkTextInset = textInset.uiEdgeInsets
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
        self.kkPlaceholderInset = placeholderInset?.uiEdgeInsets
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
