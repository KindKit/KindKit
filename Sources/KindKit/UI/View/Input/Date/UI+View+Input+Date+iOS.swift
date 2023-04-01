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
                self.kkPicker.calendar = formatter.calendar
                self.kkPicker.locale = formatter.locale
                self.kkPicker.timeZone = formatter.timeZone
            }
            self._applyText()
        }
    }
    var kkSelected: Foundation.Date? {
        didSet {
            guard self.kkSelected != oldValue else { return }
            if let selected = self.kkSelected {
                self.kkPicker.date = selected
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
    let kkPicker: UIDatePicker
    
    override init(frame: CGRect) {
        self.kkAccessoryView = .init(
            frame: .init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 0
            )
        )
        self.kkPicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            self.kkPicker.preferredDatePickerStyle = .wheels
        }

        super.init(frame: frame)
        
        self.kkAccessoryView.kkInput = self
        
        self.kkPicker.addTarget(self, action: #selector(self._changed(_:)), for: .valueChanged)
        
        self.inputView = self.kkPicker
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

extension KKInputDateView {
    
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

extension KKInputDateView {
    
    func update(view: UI.View.Input.Date) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(mode: view.mode)
        self.update(formatter: view.formatter)
        self.update(minimum: view.minimum)
        self.update(maximum: view.maximum)
        self.update(selected: view.selected)
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
        self.kkPicker.datePickerMode = mode.datePickerMode
    }
    
    func update(formatter: StringFormatter.Date) {
        self.kkFormatter = formatter
    }
    
    func update(minimum: Foundation.Date?) {
        self.kkPicker.minimumDate = minimum
    }
    
    func update(maximum: Foundation.Date?) {
        self.kkPicker.maximumDate = maximum
    }
    
    func update(selected: Foundation.Date?) {
        self.kkSelected = selected
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
        self.kkDelegate = nil
    }
    
}

private extension KKInputDateView {
    
    func _applyText() {
        if let selected = self.kkSelected {
            let formatter = self.kkFormatter ?? StringFormatter.Date()
            self.text = formatter.format(selected)
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
        self.kkSelected = sender.date
        self.kkDelegate?.select(self, date: sender.date)
    }
    
}

extension KKInputDateView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.kkDelegate?.beginEditing(self)
        if self.kkSelected == nil {
            self.kkSelected = self.kkPicker.date
            self.kkDelegate?.select(self, date: self.kkPicker.date)
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
