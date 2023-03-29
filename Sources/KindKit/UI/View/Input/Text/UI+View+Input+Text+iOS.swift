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
            return "UI.View.Input.Text"
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
    var kkPlaceholder: UILabel
    var kkPlaceholderInset: UIEdgeInsets? {
        didSet {
            guard self.kkPlaceholderInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkInput: KKInputView
    var kkInputInset: UIEdgeInsets = .zero {
        didSet {
            guard self.kkInputInset != oldValue else { return }
            self.kkInput.textContainerInset = self.kkInputInset
            self.setNeedsLayout()
        }
    }
    var kkInputTextHeight: CGFloat? {
        didSet {
            guard self.kkInputTextHeight != oldValue else { return }
            if let height = self.kkInputTextHeight {
                self.kkDelegate?.change(self, textHeight: Double(height))
            }
        }
    }
    override var canBecomeFirstResponder: Bool {
        return self.kkInput.canBecomeFirstResponder
    }
    override var canResignFirstResponder: Bool {
        return self.kkInput.canResignFirstResponder
    }
    override var frame: CGRect {
        didSet {
            guard super.frame != oldValue else { return }
            self._updateInputTextHeight()
        }
    }
    
    override init(frame: CGRect) {
        self.kkPlaceholder = UILabel()
        self.kkPlaceholder.isHidden = true

        self.kkInput = KKInputView()

        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        
        self.addSubview(self.kkPlaceholder)
        
        self.kkInput.delegate = self
        self.addSubview(self.kkInput)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.kkInput.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return self.kkInput.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let placeholderInset = self.kkPlaceholderInset ?? self.kkInputInset
        let placeholderFrame = bounds.inset(by: placeholderInset)
        let placeholderSize = self.kkPlaceholder.sizeThatFits(placeholderFrame.size)
        self.kkPlaceholder.frame = CGRect(
            origin: placeholderFrame.origin,
            size: CGSize(width: placeholderFrame.width, height: placeholderSize.height)
        )
        self.kkInput.frame = bounds
    }
    
}

extension KKInputTextView {
    
    final class KKInputView : UITextView {
        
        let kkAccessoryView: KKAccessoryView
        
        override init(frame: CGRect, textContainer: NSTextContainer?) {
            self.kkAccessoryView = .init(
                frame: .init(
                    x: 0,
                    y: 0,
                    width: UIScreen.main.bounds.width,
                    height: 0
                )
            )

            super.init(
                frame: frame,
                textContainer: textContainer
            )
            
            self.translatesAutoresizingMaskIntoConstraints = false
            self.textContainerInset = .zero
            self.backgroundColor = .clear
            self.textContainer.lineFragmentPadding = 0
            self.layoutManager.usesFontLeading = true
            self.kkAccessoryView.kkInput = self
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @discardableResult
        override func becomeFirstResponder() -> Bool {
            guard self.canBecomeFirstResponder == true else {
                return false
            }
            self.inputAccessoryView = self.kkAccessoryView
            return super.becomeFirstResponder()
        }
        
        @discardableResult
        override func resignFirstResponder() -> Bool {
            guard self.canResignFirstResponder == true else {
                return false
            }
            guard super.resignFirstResponder() == true else {
                return false
            }
            self.inputAccessoryView = nil
            return true
        }
        
    }
    
}

extension KKInputTextView {
    
    final class KKAccessoryView : UIInputView {
        
        weak var kkInput: KKInputTextView.KKInputView?
        var kkToolbarView: UIView? {
            willSet {
                guard self.kkToolbarView !== newValue else { return }
                self.kkToolbarView?.removeFromSuperview()
            }
            didSet {
                guard self.kkToolbarView !== oldValue else { return }
                if let view = self.kkToolbarView {
                    self.addSubview(view)
                }
                self.kkInput?.kkResizeAccessoryViews()
            }
        }
        var kkContentViews: [UIView] {
            var views: [UIView] = []
            if let view = self.kkToolbarView {
                views.append(view)
            }
            return views
        }
        var kkHeight: CGFloat {
            var result: CGFloat = 0
            for subview in self.kkContentViews {
                result += subview.frame.height
            }
            return result
        }
        
        init(frame: CGRect) {
            super.init(frame: frame, inputViewStyle: .keyboard)
            
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let bounds = self.bounds
            var offset: CGFloat = 0
            for subview in self.kkContentViews {
                let height = subview.frame.height
                subview.frame = CGRect(
                    x: bounds.origin.x,
                    y: offset,
                    width: bounds.size.width,
                    height: height
                )
                offset += height
            }
        }
        
    }
    
}

extension KKInputTextView.KKInputView {
    
    func kkResizeAccessoryViews() {
        let width = UIScreen.main.bounds.width
        let height = self.kkAccessoryView.kkHeight
        let oldFrame = self.kkAccessoryView.frame
        let newFrame = CGRect(x: 0, y: 0, width: width, height: height)
        if oldFrame != newFrame {
            self.kkAccessoryView.frame = newFrame
            if self.inputAccessoryView != nil {
                self.reloadInputViews()
            }
        }
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
        self.update(placeholderFont: view.placeholderFont)
        self.update(placeholderColor: view.placeholderColor)
        self.update(placeholderInset: view.placeholderInset)
        self.update(alignment: view.alignment)
        self.update(toolbar: view.toolbar)
        self.update(keyboard: view.keyboard)
        self._updateInputTextHeight()
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(text: Swift.String) {
        self.kkInput.text = text
        self.kkPlaceholder.isHidden = self.kkInput.text.isEmpty == false
    }
    
    func update(textFont: UI.Font) {
        self.kkInput.font = textFont.native
    }
    
    func update(textColor: UI.Color) {
        self.kkInput.textColor = textColor.native
    }
    
    func update(textInset: Inset) {
        self.kkInputInset = textInset.uiEdgeInsets
    }
    
    func update(editingColor: UI.Color?) {
        self.kkInput.tintColor = editingColor?.native
    }
    
    func update(placeholder: String?) {
        self.kkPlaceholder.text = placeholder ?? ""
        self.kkPlaceholder.isHidden = self.kkInput.text.isEmpty == false
    }
    
    func update(placeholderFont: UI.Font?) {
        self.kkPlaceholder.font = placeholderFont?.native ?? self.kkInput.font
    }
    
    func update(placeholderColor: UI.Color?) {
        self.kkPlaceholder.textColor = placeholderColor?.native ?? self.kkInput.textColor
    }
    
    func update(placeholderInset: Inset?) {
        self.kkPlaceholderInset = placeholderInset?.uiEdgeInsets
    }
    
    func update(alignment: UI.Text.Alignment) {
        self.kkInput.textAlignment = alignment.nsTextAlignment
        self.kkPlaceholder.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: UI.View.Input.Toolbar?) {
        self.kkInput.kkAccessoryView.kkToolbarView = toolbar?.native
    }
    
    func update(keyboard: UI.View.Input.Keyboard?) {
        self.kkInput.keyboardType = keyboard?.type ?? .default
        self.kkInput.keyboardAppearance = keyboard?.appearance ?? .default
        self.kkInput.autocapitalizationType = keyboard?.autocapitalization ?? .sentences
        self.kkInput.autocorrectionType = keyboard?.autocorrection ?? .default
        self.kkInput.spellCheckingType = keyboard?.spellChecking ?? .default
        self.kkInput.returnKeyType = keyboard?.returnKey ?? .default
        self.kkInput.enablesReturnKeyAutomatically = keyboard?.enablesReturnKeyAutomatically ?? true
        self.kkInput.textContentType = keyboard?.textContent
    }
    
    func cleanup() {
        self.kkInputTextHeight = nil
        self.kkDelegate = nil
    }
    
}

private extension KKInputTextView {
    
    func _updateInputTextHeight() {
        let containerInset = self.kkInput.textContainerInset
        let usedRect = self.kkInput.layoutManager.usedRect(for: self.kkInput.textContainer)
        self.kkInputTextHeight = containerInset.top + usedRect.height + containerInset.bottom
    }
    
}

extension KKInputTextView : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.kkDelegate?.beginEditing(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText replacement: String) -> Bool {
        guard let delegate = self.kkDelegate else {
            return false
        }
        let source = textView.text ?? ""
        guard let range = Range< String.Index >(range, in: source) else {
            return false
        }
        let info = UI.View.Input.Text.ShouldReplace(
            text: source,
            range: range,
            replacement: replacement
        )
        guard delegate.shouldReplace(self, info: info) == true else {
            return false
        }
        let text = info.text.kk_replacing(range, with: replacement)
        self.kkDelegate?.editing(self, text: text)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.kkPlaceholder.isHidden = textView.text.isEmpty == false
        self._updateInputTextHeight()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.kkDelegate?.endEditing(self)
    }

}

#endif
