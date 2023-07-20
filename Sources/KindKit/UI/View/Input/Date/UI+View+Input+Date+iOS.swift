//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Input.Date {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Input.Date
        typealias Content = KKInputDateView

        static var reuseIdentificator: String {
            return "UI.View.Input.Date"
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

final class KKInputDateView : UITextField {
    
    weak var kkDelegate: KKInputDateViewDelegate?
    let kkAccessoryView: KKAccessoryView
    var kkFormatter: StringFormatter.Date? {
        didSet {
            guard self.kkFormatter != oldValue else { return }
            if let formatter = self.kkFormatter {
                self.kkPickerView.calendar = formatter.calendar
                self.kkPickerView.locale = formatter.locale
                self.kkPickerView.timeZone = formatter.timeZone
            }
            self._applyText()
        }
    }
    var kkDefault: Foundation.Date?
    var kkValue: Foundation.Date? {
        didSet {
            guard self.kkValue != oldValue else { return }
            if let value = self.kkValue {
                self.kkPickerView.date = value
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
    var kkPlaceholder: String? {
        didSet {
            guard self.kkPlaceholder != oldValue else { return }
            self.attributedPlaceholder = self._placeholder()
        }
    }
    var kkPlaceholderFont: UIFont? {
        didSet {
            guard self.kkPlaceholderFont != oldValue else { return }
            self.attributedPlaceholder = self._placeholder()
        }
    }
    var kkPlaceholderColor: UIColor? {
        didSet {
            guard self.kkPlaceholderColor != oldValue else { return }
            self.attributedPlaceholder = self._placeholder()
        }
    }
    var kkPlaceholderInset: UIEdgeInsets? {
        didSet {
            guard self.kkPlaceholderInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    let kkPickerView: UIDatePicker
    
    override init(frame: CGRect) {
        self.kkAccessoryView = .init(
            frame: .init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 0
            )
        )
        self.kkPickerView = UIDatePicker()
        if #available(iOS 13.4, *) {
            self.kkPickerView.preferredDatePickerStyle = .wheels
        }

        super.init(frame: frame)
        
        self.kkAccessoryView.kkInput = self
        
        self.kkPickerView.addTarget(self, action: #selector(self._changed(_:)), for: .valueChanged)
        
        self.inputAssistantItem.leadingBarButtonGroups = []
        self.inputAssistantItem.trailingBarButtonGroups = []
        self.inputView = self.kkPickerView
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

extension KKInputDateView {
    
    final class KKAccessoryView : UIInputView {
        
        weak var kkInput: KKInputDateView?
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
                    self.kkInput?.reloadInputViews()
                }
            }
        }
        
    }
    
}

extension KKInputDateView {
    
    func update(view: UI.View.Input.Date) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(mode: view.mode)
        self.update(formatter: view.formatter)
        self.update(minimum: view.minimum)
        self.update(maximum: view.maximum)
        self.update(default: view.default)
        self.update(value: view.value)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(textInset: view.textInset)
        self.update(placeholder: view.placeholder)
        self.update(placeholderFont: view.placeholderFont)
        self.update(placeholderColor: view.placeholderColor)
        self.update(placeholderInset: view.placeholderInset)
        self.update(alignment: view.alignment)
        self.update(toolbar: view.toolbar)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(mode: UI.View.Input.Date.Mode) {
        self.kkPickerView.datePickerMode = mode.datePickerMode
    }
    
    func update(formatter: StringFormatter.Date) {
        self.kkFormatter = formatter
    }
    
    func update(minimum: Foundation.Date?) {
        self.kkPickerView.minimumDate = minimum
    }
    
    func update(maximum: Foundation.Date?) {
        self.kkPickerView.maximumDate = maximum
    }
    
    func update(default: Foundation.Date?) {
        self.kkDefault = `default`
    }
    
    func update(value: Foundation.Date?) {
        self.kkValue = value
    }
    
    func update(textFont: UI.Font) {
        self.font = textFont.native
    }
    
    func update(textColor: UI.Color) {
        self.textColor = textColor.native
    }
    
    func update(textInset: Inset) {
        self.kkTextInset = textInset.uiEdgeInsets
    }
    
    func update(placeholder: String?) {
        self.kkPlaceholder = placeholder
    }
    
    func update(placeholderFont: UI.Font?) {
        self.kkPlaceholderFont = placeholderFont?.native
    }
    
    func update(placeholderColor: UI.Color?) {
        self.kkPlaceholderColor = placeholderColor?.native
    }
    
    func update(placeholderInset: Inset?) {
        self.kkPlaceholderInset = placeholderInset?.uiEdgeInsets
    }
    
    func update(alignment: UI.Text.Alignment) {
        self.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: UI.View.Input.Toolbar?) {
        self.kkAccessoryView.kkToolbarView = toolbar?.native
    }
    
    func cleanup() {
        self.kkAccessoryView.kkToolbarView = nil
        self.kkDelegate = nil
    }
    
}

private extension KKInputDateView {
    
    func _applyText() {
        if let value = self.kkValue {
            let formatter = self.kkFormatter ?? StringFormatter.Date()
            self.text = formatter.format(value)
        } else {
            self.text = nil
        }
    }
    
    func _placeholder() -> NSAttributedString? {
        guard let string = self.kkPlaceholder else {
            return nil
        }
        guard let font = self.kkPlaceholderFont ?? self.font else {
            return nil
        }
        guard let color = self.kkPlaceholderColor ?? self.textColor else {
            return nil
        }
        return NSAttributedString(string: string, attributes: [
            .font: font,
            .foregroundColor: color
        ])
    }
        
    @objc
    func _changed(_ sender: UIDatePicker) {
        self.kkValue = sender.date
        self.kkDelegate?.editing(self, value: sender.date)
    }
    
}

extension KKInputDateView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.kkDelegate?.beginEditing(self)
        if self.kkValue == nil {
            if let value = self.kkDefault {
                self.kkValue = value
                self.kkDelegate?.editing(self, value: value)
            } else {
                let value = self.kkPickerView.date
                self.kkValue = value
                self.kkDelegate?.editing(self, value: value)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.kkDelegate?.endEditing(self)
    }
    
}

#endif
