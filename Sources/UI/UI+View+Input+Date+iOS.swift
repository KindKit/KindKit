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
    
    unowned var kkDelegate: KKInputDateViewDelegate?
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
    
    private unowned var _view: UI.View.Input.Date?
    private var _picker: UIDatePicker!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
        self.delegate = self
        
        self._picker = UIDatePicker()
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

extension KKInputDateView {
    
    func update(view: UI.View.Input.Date) {
        self._view = view
        self.update(mode: view.mode)
        self.update(minimumDate: view.minimumDate)
        self.update(maximumDate: view.maximumDate)
        self.update(selectedDate: view.selectedDate)
        self.update(formatter: view.formatter)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(textInset: view.textInset)
        self.update(placeholder: view.placeholder)
        self.update(placeholderInset: view.placeholderInset)
        self.update(alignment: view.alignment)
        self.update(toolbar: view.toolbar)
        self.kk_update(color: view.color)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(alpha: view.alpha)
        self.kk_updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(mode: UI.View.Input.Date.Mode) {
        self._picker.datePickerMode = mode.datePickerMode
    }
    
    func update(minimumDate: Foundation.Date?) {
        self._picker.minimumDate = minimumDate
    }
    
    func update(maximumDate: Foundation.Date?) {
        self._picker.maximumDate = maximumDate
    }
    
    func update(selectedDate: Foundation.Date?) {
        if let selectedDate = selectedDate {
            self._picker.date = selectedDate
        }
        self._applyText()
    }
    
    func update(formatter: DateFormatter) {
        self._picker.calendar = formatter.calendar
        self._picker.locale = formatter.locale
        self._picker.timeZone = formatter.timeZone
        self._applyText()
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
    
    func cleanup() {
        self.kkDelegate = nil
        self._view = nil
    }
    
}

private extension KKInputDateView {
    
    func _applyText() {
        if let view = self._view, let selectedDate = view.selectedDate {
            self.text = view.formatter.string(from: selectedDate)
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
        if self._view?.selectedDate == nil {
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
