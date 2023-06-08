//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Input.Measurement.Plain {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Input.Measurement.Plain< UnitType >
        typealias Content = KKInputMeasurementPlainView

        static var reuseIdentificator: String {
            return "UI.View.Input.Measurement"
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

final class KKInputMeasurementPlainView : UIView {
    
    weak var kkDelegate: KKInputMeasurementPlainViewDelegate?
    var kkUnit: Unit? {
        didSet {
            guard self.kkUnit != oldValue else { return }
            self.kkUnitText = self.kkUnit?.symbol
        }
    }
    var kkUnitText: String? {
        didSet {
            guard self.kkUnitText != oldValue else { return }
            self.kkUnitView.text = self.kkUnitText
            self._kkUnitSizeThatFit = true
            self.setNeedsLayout()
        }
    }
    var kkUnitFont: UIFont? {
        didSet {
            guard self.kkUnitFont != oldValue else { return }
            self.kkUnitView.font = self.kkUnitFont
            self._kkUnitSizeThatFit = true
            self.setNeedsLayout()
        }
    }
    var kkUnitColor: UIColor? {
        didSet {
            guard self.kkUnitColor != oldValue else { return }
            self.kkUnitView.textColor = self.kkUnitColor
        }
    }
    var kkUnitInset: UIEdgeInsets = .zero {
        didSet {
            guard self.kkUnitInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkUnitView: UILabel
    var kkValue: NSMeasurement?
    var kkInputView: KKInputView
    override var canBecomeFirstResponder: Bool {
        return self.kkInputView.canBecomeFirstResponder
    }
    override var canResignFirstResponder: Bool {
        return self.kkInputView.canResignFirstResponder
    }
    
    private var _kkUnitSizeThatFit: Bool = true
    
    override init(frame: CGRect) {
        self.kkInputView = KKInputView(
            frame: .init(origin: .zero, size: frame.size)
        )
        
        self.kkUnitView = UILabel(
            frame: .init(origin: .zero, size: frame.size)
        )

        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self.kkInputView.delegate = self
        self.addSubview(self.kkInputView)
        
        self.addSubview(self.kkUnitView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return self.kkInputView.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return self.kkInputView.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        if self._kkUnitSizeThatFit == true {
            self._kkUnitSizeThatFit = true
            self.kkUnitView.sizeToFit()
        }
        let unitSize = self.kkUnitView.bounds.size
        self.kkInputView.frame = .init(
            x: bounds.minX,
            y: bounds.minY,
            width: bounds.width - (unitSize.width + self.kkUnitInset.left + self.kkUnitInset.right),
            height: bounds.height
        )
        self.kkUnitView.frame = .init(
            x: bounds.maxX - (unitSize.width + self.kkUnitInset.right),
            y: bounds.minY - self.kkUnitInset.top,
            width: unitSize.width,
            height: bounds.height - (self.kkUnitInset.top + self.kkUnitInset.bottom)
        )
    }
    
}

extension KKInputMeasurementPlainView {
    
    final class KKInputView : UITextField {
        
        let kkAccessoryView: KKAccessoryView
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
        
        override init(frame: CGRect) {
            self.kkAccessoryView = .init(
                frame: .init(
                    x: 0,
                    y: 0,
                    width: UIScreen.main.bounds.width,
                    height: 0
                )
            )

            super.init(frame: frame)
            
            self.kkAccessoryView.kkInputView = self
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
    
}

extension KKInputMeasurementPlainView {
    
    final class KKAccessoryView : UIInputView {
        
        weak var kkInputView: KKInputMeasurementPlainView.KKInputView?
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
            let oldFrame = self.frame
            let newFrame = CGRect(x: 0, y: 0, width: oldFrame.width, height: height)
            if oldFrame != newFrame {
                self.frame = newFrame
                self.kkInputView?.reloadInputViews()
            }
        }
        
    }
    
}

extension KKInputMeasurementPlainView {
    
    func update< UnitType : Dimension >(view: UI.View.Input.Measurement.Plain< UnitType >) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(unit: view.unit)
        self.update(unitInset: view.unitInset)
        self.update(value: view.value)
        self.update(textInset: view.textInset)
        self.update(textFont: view.textFont, unitFont: view.unitFont)
        self.update(textColor: view.textColor, unitColor: view.unitColor)
        self.update(editingColor: view.editingColor)
        self.update(placeholder: view.placeholder)
        self.update(placeholderFont: view.placeholderFont)
        self.update(placeholderColor: view.placeholderColor)
        self.update(placeholderInset: view.placeholderInset)
        self.update(alignment: view.alignment)
        self.update(toolbar: view.toolbar)
        self.update(keyboard: view.keyboard)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update< UnitType : Dimension >(unit: UnitType) {
        self.kkUnit = unit
    }
    
    func update(unitInset: Inset) {
        self.kkUnitInset = unitInset.uiEdgeInsets
    }
    
    func update< UnitType : Dimension >(value: Measurement< UnitType >?) {
        if let value = value as? NSMeasurement {
            self.kkValue = value
            self.kkInputView.text = NumberFormatter().string(from: NSNumber(value: value.doubleValue))
        } else {
            self.kkValue = nil
            self.kkInputView.text = ""
        }
    }
    
    func update(textFont: UI.Font, unitFont: UI.Font?) {
        self.kkUnitFont = (unitFont ?? textFont).native
        self.kkInputView.font = textFont.native
    }
    
    func update(textColor: UI.Color, unitColor: UI.Color?) {
        self.kkUnitColor = (unitColor ?? textColor).native
        self.kkInputView.textColor = textColor.native
    }
    
    func update(textInset: Inset) {
        self.kkInputView.kkTextInset = textInset.uiEdgeInsets
    }
    
    func update(editingColor: UI.Color?) {
        self.kkInputView.tintColor = editingColor?.native
    }
    
    func update(placeholder: String?) {
        self.kkInputView.kkPlaceholder = placeholder
    }
    
    func update(placeholderFont: UI.Font?) {
        self.kkInputView.kkPlaceholderFont = placeholderFont?.native
    }
    
    func update(placeholderColor: UI.Color?) {
        self.kkInputView.kkPlaceholderColor = placeholderColor?.native
    }
    
    func update(placeholderInset: Inset?) {
        self.kkInputView.kkPlaceholderInset = placeholderInset?.uiEdgeInsets
    }
    
    func update(alignment: UI.Text.Alignment) {
        self.kkInputView.textAlignment = alignment.nsTextAlignment
    }
    
    func update(toolbar: UI.View.Input.Toolbar?) {
        self.kkInputView.kkAccessoryView.kkToolbarView = toolbar?.native
    }
    
    func update(keyboard: UI.View.Input.Keyboard?) {
        self.kkInputView.keyboardType = keyboard?.type ?? .decimalPad
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
        self.kkDelegate = nil
    }
    
}

private extension KKInputMeasurementPlainView.KKInputView {
    
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
    
}

extension KKInputMeasurementPlainView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.kkDelegate?.beginEditing(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString replacement: String) -> Bool {
        guard let delegate = self.kkDelegate, let unit = self.kkUnit else {
            return false
        }
        let oldText = textField.text ?? ""
        guard let range = Range< String.Index >(range, in: oldText) else {
            return false
        }
        let newText = oldText.kk_replacing(range, with: replacement)
        guard let newNumber = NSNumber.kk_number(from: newText) else {
            return false
        }
        let newValue = NSMeasurement(doubleValue: newNumber.doubleValue, unit: unit)
        if self.kkValue != newValue {
            self.kkValue = newValue
            delegate.editing(self, value: newValue)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.kkDelegate?.endEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.kkDelegate?.pressedReturn(self)
        return true
    }
    
}

#endif
