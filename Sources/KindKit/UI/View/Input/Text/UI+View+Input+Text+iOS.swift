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
    var kkPlaceholderView: UILabel
    var kkPlaceholderInset: UIEdgeInsets? {
        didSet {
            guard self.kkPlaceholderInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkInputView: KKInputView
    var kkInputInset: UIEdgeInsets = .zero {
        didSet {
            guard self.kkInputInset != oldValue else { return }
            self.kkInputView.textContainerInset = self.kkInputInset
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
        return self.kkInputView.canBecomeFirstResponder
    }
    override var canResignFirstResponder: Bool {
        return self.kkInputView.canResignFirstResponder
    }
    override var frame: CGRect {
        didSet {
            guard super.frame != oldValue else { return }
            self._updateInputTextHeight()
        }
    }
    
    override init(frame: CGRect) {
        self.kkPlaceholderView = UILabel()
        self.kkPlaceholderView.isHidden = true

        self.kkInputView = KKInputView()

        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self.addSubview(self.kkPlaceholderView)
        
        self.kkInputView.delegate = self
        self.addSubview(self.kkInputView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.kkInputView.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return self.kkInputView.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let placeholderInset = self.kkPlaceholderInset ?? self.kkInputInset
        let placeholderFrame = bounds.inset(by: placeholderInset)
        let placeholderSize = self.kkPlaceholderView.sizeThatFits(placeholderFrame.size)
        self.kkPlaceholderView.frame = CGRect(
            origin: placeholderFrame.origin,
            size: CGSize(width: placeholderFrame.width, height: placeholderSize.height)
        )
        self.kkInputView.frame = bounds
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
            
            self.textContainerInset = .zero
            self.backgroundColor = .clear
            self.textContainer.lineFragmentPadding = 0
            self.layoutManager.usesFontLeading = true
            self.kkAccessoryView.kkInputView = self
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
        
        weak var kkInputView: KKInputTextView.KKInputView?
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
            }
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
            
            var height = CGFloat.zero
            do {
                let insets = self.safeAreaInsets
                let baseBounds = self.bounds
                let safeBounds = baseBounds.inset(by: insets)
                if let view = self.kkToolbarView {
                    let viewHeight = view.frame.height
                    view.frame = CGRect(
                        x: safeBounds.origin.x,
                        y: safeBounds.origin.y + height,
                        width: safeBounds.size.width,
                        height: viewHeight
                    )
                    height += viewHeight
                }
                if height > .leastNormalMagnitude {
                    height += insets.top + insets.bottom
                }
            }
            if height > .leastNormalMagnitude {
                let oldFrame = self.frame
                let newFrame = CGRect(x: 0, y: 0, width: oldFrame.width, height: height)
                if oldFrame != newFrame {
                    self.frame = newFrame
                    self.kkInputView?.reloadInputViews()
                }
            }
        }
        
    }
    
}

extension KKInputTextView {
    
    func update(view: UI.View.Input.Text) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(value: view.value)
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
    
    func update(value: Swift.String) {
        self.kkInputView.text = value
        self.kkPlaceholderView.isHidden = value.isEmpty == false
    }
    
    func update(textFont: UI.Font) {
        self.kkInputView.font = textFont.native
    }
    
    func update(textColor: UI.Color) {
        self.kkInputView.textColor = textColor.native
    }
    
    func update(textInset: Inset) {
        self.kkInputInset = textInset.uiEdgeInsets
    }
    
    func update(editingColor: UI.Color?) {
        self.kkInputView.tintColor = editingColor?.native
    }
    
    func update(placeholder: String?) {
        self.kkPlaceholderView.text = placeholder ?? ""
        self.kkPlaceholderView.isHidden = self.kkInputView.text.isEmpty == false
    }
    
    func update(placeholderFont: UI.Font?) {
        self.kkPlaceholderView.font = placeholderFont?.native ?? self.kkInputView.font
    }
    
    func update(placeholderColor: UI.Color?) {
        self.kkPlaceholderView.textColor = placeholderColor?.native ?? self.kkInputView.textColor
    }
    
    func update(placeholderInset: Inset?) {
        self.kkPlaceholderInset = placeholderInset?.uiEdgeInsets
    }
    
    func update(alignment: UI.Text.Alignment) {
        self.kkInputView.textAlignment = alignment.nsTextAlignment
        self.kkPlaceholderView.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: UI.View.Input.Toolbar?) {
        self.kkInputView.kkAccessoryView.kkToolbarView = toolbar?.native
    }
    
    func update(keyboard: UI.View.Input.Keyboard?) {
        self.kkInputView.keyboardType = keyboard?.type ?? .default
        self.kkInputView.keyboardAppearance = keyboard?.appearance ?? .default
        self.kkInputView.autocapitalizationType = keyboard?.autocapitalization ?? .sentences
        self.kkInputView.autocorrectionType = keyboard?.autocorrection ?? .default
        self.kkInputView.spellCheckingType = keyboard?.spellChecking ?? .default
        self.kkInputView.returnKeyType = keyboard?.returnKey ?? .default
        self.kkInputView.enablesReturnKeyAutomatically = keyboard?.enablesReturnKeyAutomatically ?? true
        self.kkInputView.textContentType = keyboard?.textContent
    }
    
    func cleanup() {
        self.kkInputView.kkAccessoryView.kkToolbarView = nil
        self.kkInputTextHeight = nil
        self.kkDelegate = nil
    }
    
}

private extension KKInputTextView {
    
    func _updateInputTextHeight() {
        let containerInset = self.kkInputView.textContainerInset
        let usedRect = self.kkInputView.layoutManager.usedRect(for: self.kkInputView.textContainer)
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
        self.kkDelegate?.editing(self, value: text)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.kkPlaceholderView.isHidden = textView.text.isEmpty == false
        self._updateInputTextHeight()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.kkDelegate?.endEditing(self)
    }

}

#endif
