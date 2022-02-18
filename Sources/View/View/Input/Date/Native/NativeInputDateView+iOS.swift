//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension InputDateView {
    
    struct Reusable : IReusable {
        
        typealias Owner = InputDateView
        typealias Content = NativeInputDateView

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

extension InputDateViewMode {
    
    var datePickerMode: UIDatePicker.Mode {
        switch self {
        case .time: return .time
        case .date: return .date
        case .dateTime: return .dateAndTime
        }
    }
    
}

final class NativeInputDateView : UITextField {
    
    typealias View = IInputDateView
    
    unowned var customDelegate: InputDateViewDelegate?
    override var frame: CGRect {
        set(value) {
            if super.frame != value {
                super.frame = value
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
            }
        }
        get { return super.frame }
    }
    
    private unowned var _view: View?
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
        return RectFloat(bounds).inset(view.textInset).cgRect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard let view = self._view else { return bounds }
        return RectFloat(bounds).inset(view.textInset).cgRect
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard let view = self._view else { return bounds }
        let inset = view.placeholderInset ?? view.textInset
        return RectFloat(bounds).inset(inset).cgRect
    }
    
}

extension NativeInputDateView {
    
    func update(view: InputDateView) {
        self._view = view
        self.update(mode: view.mode)
        self.update(minimumDate: view.minimumDate)
        self.update(maximumDate: view.maximumDate)
        self.update(selectedDate: view.selectedDate)
        self.update(formatter: view.formatter)
        self.update(locale: view.locale)
        self.update(timeZone: view.timeZone)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(textInset: view.textInset)
        self.update(placeholder: view.placeholder)
        self.update(placeholderInset: view.placeholderInset)
        self.update(alignment: view.alignment)
        self.update(toolbar: view.toolbar)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.customDelegate = view
    }
    
    func update(mode: InputDateViewMode) {
        self._picker.datePickerMode = mode.datePickerMode
    }
    
    func update(minimumDate: Date?) {
        self._picker.minimumDate = minimumDate
    }
    
    func update(maximumDate: Date?) {
        self._picker.maximumDate = maximumDate
    }
    
    func update(selectedDate: Date?) {
        if let selectedDate = selectedDate {
            self._picker.date = selectedDate
        }
        self._applyText()
    }
    
    func update(formatter: DateFormatter) {
        self._applyText()
    }
    
    func update(locale: Locale) {
        self._picker.locale = locale
    }
    
    func update(calendar: Calendar) {
        self._picker.calendar = calendar
    }
    
    func update(timeZone: TimeZone?) {
        self._picker.timeZone = timeZone
    }
    
    func update(textFont: Font) {
        self.font = textFont.native
    }
    
    func update(textColor: Color) {
        self.textColor = textColor.native
    }
    
    func update(textInset: InsetFloat) {
        self.setNeedsLayout()
    }
    
    func update(placeholder: InputPlaceholder) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder.text, attributes: [
            .font: placeholder.font.native,
            .foregroundColor: placeholder.color.native
        ])
    }
    
    func update(placeholderInset: InsetFloat?) {
        self.setNeedsLayout()
    }
    
    func update(alignment: TextAlignment) {
        self.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: IInputToolbarView?) {
        self.inputAccessoryView = toolbar?.native
    }
    
    func cleanup() {
        self.customDelegate = nil
        self._view = nil
    }
    
}

private extension NativeInputDateView {
    
    func _applyText() {
        if let view = self._view, let selectedDate = view.selectedDate {
            self.text = view.formatter.string(from: selectedDate)
        } else {
            self.text = nil
        }
    }
    
    @objc
    func _changed(_ sender: UIDatePicker) {
        self.customDelegate?.select(date: sender.date)
    }
    
}

extension NativeInputDateView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.customDelegate?.beginEditing()
        if self._view?.selectedDate == nil {
            self.customDelegate?.select(date: self._picker.date)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.customDelegate?.endEditing()
    }
    
}

#endif
