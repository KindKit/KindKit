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
    
    override var canBecomeFirstResponder: Bool {
        return self._input.canBecomeFirstResponder
    }
    override var canResignFirstResponder: Bool {
        return self._input.canResignFirstResponder
    }
    override var frame: CGRect {
        didSet {
            guard super.frame != oldValue else { return }
            self._updateInputTextHeight()
        }
    }
    
    private weak var _delegate: KKInputTextViewDelegate?
    private var _placeholder: UILabel
    private var _placeholderInset: UIEdgeInsets? {
        didSet {
            guard self._placeholderInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    private var _input: UITextView
    private var _inputInset: UIEdgeInsets = .zero {
        didSet {
            guard self._inputInset != oldValue else { return }
            self._input.textContainerInset = self._inputInset
            self.setNeedsLayout()
        }
    }
    private var _inputTextHeight: CGFloat? {
        didSet {
            guard self._inputTextHeight != oldValue else { return }
            if let height = self._inputTextHeight {
                self._delegate?.change(self, textHeight: Double(height))
            }
        }
    }
    
    override init(frame: CGRect) {
        self._placeholder = UILabel()
        self._placeholder.isHidden = true

        self._input = UITextView()
        self._input.textContainerInset = .zero
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
    
    override func becomeFirstResponder() -> Bool {
        return self._input.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return self._input.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let placeholderInset = self._placeholderInset ?? self._inputInset
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
        self.update(frame: view.frame)
        self.update(transform: view.transform)
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
        self._updateInputTextHeight()
        self._delegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
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
    
    func update(textInset: Inset) {
        self._inputInset = textInset.uiEdgeInsets
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
    
    func update(placeholderInset: Inset?) {
        self._placeholderInset = placeholderInset?.uiEdgeInsets
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
        self._inputTextHeight = nil
        self._delegate = nil
    }
    
}

private extension KKInputTextView {
    
    func _updateInputTextHeight() {
        let containerInset = self._input.textContainerInset
        let usedRect = self._input.layoutManager.usedRect(for: self._input.textContainer)
        self._inputTextHeight = containerInset.top + usedRect.height + containerInset.bottom
    }
    
}

extension KKInputTextView : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self._delegate?.beginEditing(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let sourceText = (textView.text ?? "") as NSString
        let newText = sourceText.replacingCharacters(in: range, with: text)
        self._delegate?.editing(self, text: newText)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self._placeholder.isHidden = textView.text.isEmpty == false
        self._updateInputTextHeight()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self._delegate?.endEditing(self)
    }

}

#endif
