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
            return "InputDateView"
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
    var kkFormatter: DateFormatter? {
        didSet {
            guard self.kkFormatter != oldValue else { return }
            if let formatter = self.kkFormatter {
                self._picker.calendar = formatter.calendar
                self._picker.locale = formatter.locale
                self._picker.timeZone = formatter.timeZone
            }
            self._applyText()
        }
    }
    var kkSelected: Foundation.Date? {
        didSet {
            guard self.kkSelected != oldValue else { return }
            if let selected = self.kkSelected {
                self._picker.date = selected
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
    var kkPlaceholderInset: UIEdgeInsets? {
        didSet {
            guard self.kkPlaceholderInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }

    private var _picker: UIDatePicker
    
    override init(frame: CGRect) {
        self._picker = UIDatePicker()

        super.init(frame: frame)

        self.clipsToBounds = true
        self.delegate = self
        
        if #available(iOS 13.4, *) {
            self._picker.preferredDatePickerStyle = .wheels
        }
        self._picker.addTarget(self, action: #selector(self._changed(_:)), for: .valueChanged)
        self.inputView = self._picker
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
        self._picker.datePickerMode = mode.datePickerMode
    }
    
    func update(formatter: DateFormatter) {
        self.kkFormatter = formatter
    }
    
    func update(minimum: Foundation.Date?) {
        self._picker.minimumDate = minimum
    }
    
    func update(maximum: Foundation.Date?) {
        self._picker.maximumDate = maximum
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
    
    func update(placeholderInset: Inset?) {
        self.kkPlaceholderInset = placeholderInset?.uiEdgeInsets
    }
    
    func update(alignment: UI.Text.Alignment) {
        self.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: UI.View.Input.Toolbar?) {
        self.inputAccessoryView = toolbar?.native
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKInputDateView {
    
    func _applyText() {
        if let formatter = self.kkFormatter, let selected = self.kkSelected {
            self.text = formatter.string(from: selected)
        } else {
            self.text = nil
        }
    }
        
    @objc
    func _changed(_ sender: UIDatePicker) {
        self.kkDelegate?.select(self, date: sender.date)
    }
    
}

extension KKInputDateView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.kkDelegate?.beginEditing(self)
        if self.kkSelected == nil {
            self.kkDelegate?.select(self, date: self._picker.date)
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
