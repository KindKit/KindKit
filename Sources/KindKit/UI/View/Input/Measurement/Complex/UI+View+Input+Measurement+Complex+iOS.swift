//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Input.Measurement.Complex {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Input.Measurement.Complex< UnitType >
        typealias Content = KKInputMeasurementComplexView

        static var reuseIdentificator: String {
            return "UI.View.Input.Measurement.Complex"
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

final class KKInputMeasurementComplexView : UITextField {
    
    weak var kkDelegate: KKInputMeasurementComplexViewDelegate?
    let kkAccessoryView: KKAccessoryView
    var kkUnit: Unit?
    var kkParts: [KKPart] = [] {
        didSet {
            guard self.kkParts != oldValue else { return }
            self.kkPicker.reloadAllComponents()
        }
    }
    var kkDefault: [KKItem]? {
        didSet {
            guard self.kkDefault != oldValue else { return }
            self._refreshPicker(animated: self.isFirstResponder)
        }
    }
    var kkSelected: [KKItem]? {
        didSet {
            guard self.kkSelected != oldValue else { return }
            self._refreshPicker(animated: self.isFirstResponder)
            self._refreshText()
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
    let kkPicker: UIPickerView
    
    override init(frame: CGRect) {
        self.kkAccessoryView = .init(
            frame: .init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 0
            )
        )
        self.kkPicker = UIPickerView()

        super.init(frame: frame)
        
        self.kkAccessoryView.kkInputView = self
        
        self.kkPicker.dataSource = self
        self.kkPicker.delegate = self
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

extension KKInputMeasurementComplexView {
    
    struct KKPart : Equatable {
        
        let unit: Unit
        let items: [KKInputMeasurementComplexView.KKItem]
        
        init(
            unit: Unit,
            items: [KKInputMeasurementComplexView.KKItem]
        ) {
            self.unit = unit
            self.items = items
        }
        
    }
    
    struct KKItem : Equatable {
        
        let title: String
        let value: NSMeasurement
        
        init(
            title: String,
            value: NSMeasurement
        ) {
            self.title = title
            self.value = value
        }
        
    }
    
}

extension KKInputMeasurementComplexView {
    
    final class KKAccessoryView : UIInputView {
        
        weak var kkInputView: KKInputMeasurementComplexView?
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

extension KKInputMeasurementComplexView {
    
    func update< UnitType : Dimension >(view: UI.View.Input.Measurement.Complex< UnitType >) {
        self.kkUnit = view.unit
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(parts: view.parts)
        self.update(default: view.default, value: view.value)
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
    
    func update< UnitType : Dimension >(parts: [UI.View.Input.Measurement.Complex< UnitType >.Part]) {
        self.kkParts = parts.map({ part in
            .init(
                unit: part.unit,
                items: part.items.map({ item in
                    .init(
                        title: item.title,
                        value: NSMeasurement(doubleValue: item.value, unit: part.unit)
                    )
                })
            )
        })
    }
    
    func update< UnitType : Dimension >(`default`: Measurement< UnitType >?, value: Measurement< UnitType >?) {
        if let value = `default` {
            self.kkDefault = self._items(from: value as NSMeasurement)
        } else {
            self.kkDefault = self._items(from: nil)
        }
        if let value = value {
            self.kkSelected = self._items(from: value as NSMeasurement)
        } else {
            self.kkSelected = nil
        }
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
        self.kkSelected = nil
        self.kkDefault = nil
        self.kkParts = []
        self.kkAccessoryView.kkToolbarView = nil
        self.kkDelegate = nil
    }
    
}

private extension KKInputMeasurementComplexView {
    
    func _refreshPicker(animated: Bool) {
        if let selected = self.kkSelected {
            for partIndex in self.kkParts.startIndex..<self.kkParts.endIndex {
                let part = self.kkParts[partIndex]
                let selected = selected[partIndex]
                if let itemIndex = part.items.firstIndex(where: { $0 == selected }) {
                    self.kkPicker.selectRow(itemIndex, inComponent: partIndex, animated: animated)
                } else {
                    self.kkPicker.selectRow(0, inComponent: partIndex, animated: animated)
                }
            }
        } else {
            for partIndex in self.kkParts.startIndex..<self.kkParts.endIndex {
                self.kkPicker.selectRow(0, inComponent: partIndex, animated: animated)
            }
        }
    }
    
    func _refreshText() {
        if let selected = self.kkSelected {
            self.text = selected.compactMap({ $0.title }).joined(separator: " ")
        } else {
            self.text = ""
        }
    }
    
    func _items(from measurement: NSMeasurement?) -> [KKItem] {
        var result: [KKItem] = []
        if let measurement = measurement {
            var accumulator: NSMeasurement?
            for partIndex in self.kkParts.startIndex..<self.kkParts.endIndex {
                let part = self.kkParts[partIndex]
                let converted: NSMeasurement
                if let accumulator = accumulator {
                    let lhs = measurement.converting(to: part.unit)
                    let rhs = accumulator.converting(to: part.unit)
                    converted = (lhs - rhs) as NSMeasurement
                } else {
                    converted = NSMeasurement(
                        doubleValue: floor(measurement.converting(to: part.unit).value),
                        unit: part.unit
                    )
                }
                let convertedValue = converted.doubleValue
                var nearest: KKItem? = nil
                if partIndex < self.kkParts.endIndex {
                    for item in part.items {
                        let itemValue = item.value.converting(to: part.unit).value
                        if convertedValue >= itemValue {
                            nearest = item
                        } else if itemValue >= convertedValue {
                            break
                        }
                    }
                } else {
                    var lower: KKItem? = nil
                    var upper: KKItem? = nil
                    for item in part.items {
                        let itemValue = item.value.converting(to: part.unit).value
                        if convertedValue >= itemValue {
                            lower = item
                        } else if itemValue >= convertedValue {
                            if lower == nil {
                                lower = item
                            } else {
                                upper = item
                            }
                            break
                        }
                    }
                    if let lower = lower, let upper = upper {
                        let lowerValue = lower.value.converting(to: part.unit).value
                        let upperValue = upper.value.converting(to: part.unit).value
                        let lowerDelta = abs(lowerValue - convertedValue)
                        let upperDelta = abs(upperValue - convertedValue)
                        if lowerDelta < upperDelta {
                            nearest = lower
                        } else {
                            nearest = upper
                        }
                    } else {
                        nearest = lower
                    }
                }
                if let nearest = nearest {
                    let offset = nearest.value.converting(to: part.unit)
                    if let t = accumulator {
                        accumulator = t.adding(offset) as NSMeasurement
                    } else {
                        accumulator = offset as NSMeasurement
                    }
                    result.append(nearest)
                } else {
                    result.append(part.items.first!)
                }
            }
        } else {
            for part in self.kkParts {
                result.append(part.items.first!)
            }
        }
        return result
    }
    
    func _value() -> NSMeasurement? {
        guard let unit = self.kkUnit else {
            return nil
        }
        guard let selected = self.kkSelected else {
            return nil
        }
        let values: [Double] = selected.compactMap({
            guard $0.value.canBeConverted(to: unit) == true else {
                return nil
            }
            return $0.value.converting(to: unit).value
        })
        guard values.isEmpty == false else {
            return nil
        }
        return NSMeasurement(
            doubleValue: values.reduce(0, { $0 + $1 }),
            unit: unit
        )
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
    
}

extension KKInputMeasurementComplexView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let delegate = self.kkDelegate else {
            return
        }
        delegate.beginEditing(self)
        if self.kkSelected == nil {
            self.kkSelected = self.kkDefault
            if self.kkSelected != nil {
                delegate.editing(self, value: self._value())
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let delegate = self.kkDelegate else {
            return
        }
        delegate.endEditing(self)
    }
    
}

extension KKInputMeasurementComplexView : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.kkParts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let part = self.kkParts[component]
        return part.items.count
    }
    
}

extension KKInputMeasurementComplexView : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let part = self.kkParts[component]
        return part.items[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let delegate = self.kkDelegate else {
            return
        }
        guard let selected = self.kkSelected else {
            return
        }
        let oldSelected = selected[component]
        let newSelected = self.kkParts[component].items[row]
        if oldSelected != newSelected {
            self.kkSelected = selected.kk_replacing(at: component, to: newSelected)
            delegate.editing(self, value: self._value())
        }
    }
    
}

#endif
