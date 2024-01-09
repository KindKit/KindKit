//
//  KindKit
//

import Foundation

#if os(macOS)
#warning("Require support macOS")
#elseif os(iOS)

protocol KKInputMeasurementPlainViewDelegate : AnyObject {
    
    func beginEditing(_ view: KKInputMeasurementPlainView)
    func editing(_ view: KKInputMeasurementPlainView, value: NSMeasurement?)
    func endEditing(_ view: KKInputMeasurementPlainView)
    func pressedReturn(_ view: KKInputMeasurementPlainView)
    
}

public extension UI.View.Input.Measurement {
    
    final class Plain< UnitType : Dimension > {
        
        public private(set) weak var appearedLayout: IUILayout?
        public var frame: KindKit.Rect = .zero {
            didSet {
                guard self.frame != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(frame: self.frame)
                }
            }
        }
#if os(iOS)
        public var transform: UI.Transform = .init() {
            didSet {
                guard self.transform != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(transform: self.transform)
                }
            }
        }
#endif
        public var size: UI.Size.Static = .init(.fill, .fixed(28)) {
            didSet {
                guard self.size != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public let unit: UnitType
        public var unitFont: UI.Font? {
            didSet {
                guard self.unitFont != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(textFont: self.textFont, unitFont: self.unitFont)
                }
            }
        }
        public var unitColor: UI.Color? {
            didSet {
                guard self.unitColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(textColor: self.textColor, unitColor: self.unitColor)
                }
            }
        }
        public var unitInset: Inset = Inset(horizontal: 4, vertical: 0) {
            didSet {
                guard self.unitInset != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(unitInset: self.unitInset)
                }
            }
        }
        public var value: Foundation.Measurement< UnitType >? {
            set {
                guard self.value != newValue else { return }
                self._value = newValue
                if self.isLoaded == true {
                    self._view.update(value: self._value)
                }
            }
            get { self._value }
        }
        public var textFont: UI.Font = .init(weight: .regular) {
            didSet {
                guard self.textFont != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(textFont: self.textFont, unitFont: self.unitFont)
                }
            }
        }
        public var textColor: UI.Color = .black {
            didSet {
                guard self.textColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(textColor: self.textColor, unitColor: self.unitColor)
                }
            }
        }
        public var textInset: Inset = Inset(horizontal: 8, vertical: 4) {
            didSet {
                guard self.textInset != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(textInset: self.textInset)
                }
            }
        }
        public var editingColor: UI.Color? {
            didSet {
                guard self.editingColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(editingColor: self.editingColor)
                }
            }
        }
        public var placeholder: Swift.String? {
            didSet {
                guard self.placeholder != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(placeholder: self.placeholder)
                }
            }
        }
        public var placeholderFont: UI.Font? {
            didSet {
                guard self.placeholderFont != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(placeholderFont: self.placeholderFont)
                }
            }
        }
        public var placeholderColor: UI.Color? {
            didSet {
                guard self.placeholderColor != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(placeholderColor: self.placeholderColor)
                }
            }
        }
        public var placeholderInset: Inset? {
            didSet {
                guard self.placeholderInset != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(placeholderInset: self.placeholderInset)
                }
            }
        }
        public var alignment: UI.Text.Alignment = .left {
            didSet {
                guard self.alignment != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(alignment: self.alignment)
                }
            }
        }
#if os(iOS)
        public var toolbar: UI.View.Input.Toolbar? {
            didSet {
                guard self.toolbar !== oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(toolbar: self.toolbar)
                }
            }
        }
        public var keyboard: UI.View.Input.Keyboard? {
            didSet {
                guard self.keyboard != oldValue else { return }
                if self.isLoaded == true {
                    self._view.update(keyboard: self.keyboard)
                }
            }
        }
#endif
        public var isHidden: Bool = false {
            didSet {
                guard self.isHidden != oldValue else { return }
                self.setNeedLayout()
            }
        }
        public private(set) var isVisible: Bool = false
        public let onAppear = Signal.Empty< Void >()
        public let onDisappear = Signal.Empty< Void >()
        public let onVisible = Signal.Empty< Void >()
        public let onInvisible = Signal.Empty< Void >()
        public let onBeginEditing = Signal.Empty< Void >()
        public let onEditing = Signal.Empty< Void >()
        public let onEndEditing = Signal.Empty< Void >()
        public let onPressedReturn = Signal.Empty< Void >()
        
        private lazy var _reuse: UI.Reuse.Item< Reusable > = .init(owner: self)
        @inline(__always) private var _view: Reusable.Content { self._reuse.content }
        private var _value: Foundation.Measurement< UnitType >?
        
        public init(unit: UnitType) {
            self.unit = unit
        }
        
        deinit {
            self._reuse.destroy()
        }
        
    }
    
}

public extension UI.View.Input.Measurement.Plain {
    
    @inlinable
    @discardableResult
    func unitFont(_ value: UI.Font) -> Self {
        self.unitFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func unitFont(_ value: () -> UI.Font) -> Self {
        return self.unitFont(value())
    }

    @inlinable
    @discardableResult
    func unitFont(_ value: (Self) -> UI.Font) -> Self {
        return self.unitFont(value(self))
    }
    
    @inlinable
    @discardableResult
    func unitColor(_ value: UI.Color) -> Self {
        self.unitColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func unitColor(_ value: () -> UI.Color) -> Self {
        return self.unitColor(value())
    }

    @inlinable
    @discardableResult
    func unitColor(_ value: (Self) -> UI.Color) -> Self {
        return self.unitColor(value(self))
    }
    
    @discardableResult
    func unitInset(_ value: Inset) -> Self {
        self.unitInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func unitInset(_ value: () -> Inset) -> Self {
        return self.unitInset(value())
    }

    @inlinable
    @discardableResult
    func unitInset(_ value: (Self) -> Inset) -> Self {
        return self.unitInset(value(self))
    }
    
    @inlinable
    @discardableResult
    func value(_ value: Foundation.Measurement< UnitType >) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    func value(_ value: () -> Foundation.Measurement< UnitType >) -> Self {
        return self.value(value())
    }

    @inlinable
    @discardableResult
    func value(_ value: (Self) -> Foundation.Measurement< UnitType >) -> Self {
        return self.value(value(self))
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: UI.Font) -> Self {
        self.textFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textFont(_ value: () -> UI.Font) -> Self {
        return self.textFont(value())
    }

    @inlinable
    @discardableResult
    func textFont(_ value: (Self) -> UI.Font) -> Self {
        return self.textFont(value(self))
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: UI.Color) -> Self {
        self.textColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textColor(_ value: () -> UI.Color) -> Self {
        return self.textColor(value())
    }

    @inlinable
    @discardableResult
    func textColor(_ value: (Self) -> UI.Color) -> Self {
        return self.textColor(value(self))
    }
    
    @discardableResult
    func textInset(_ value: Inset) -> Self {
        self.textInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func textInset(_ value: () -> Inset) -> Self {
        return self.textInset(value())
    }

    @inlinable
    @discardableResult
    func textInset(_ value: (Self) -> Inset) -> Self {
        return self.textInset(value(self))
    }
    
    @inlinable
    @discardableResult
    func editingColor(_ value: UI.Color?) -> Self {
        self.editingColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func editingColor(_ value: () -> UI.Color?) -> Self {
        return self.editingColor(value())
    }

    @inlinable
    @discardableResult
    func editingColor(_ value: (Self) -> UI.Color?) -> Self {
        return self.editingColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholder(_ value: Swift.String?) -> Self {
        self.placeholder = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder(_ value: () -> Swift.String?) -> Self {
        return self.placeholder(value())
    }

    @inlinable
    @discardableResult
    func placeholder(_ value: (Self) -> Swift.String?) -> Self {
        return self.placeholder(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholder< Placeholder : IEnumLocalized >(_ value: Placeholder) -> Self {
        self.placeholder = value.localized
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholder< Placeholder : IEnumLocalized >(_ value: () -> Placeholder) -> Self {
        return self.placeholder(value())
    }

    @inlinable
    @discardableResult
    func placeholder< Placeholder : IEnumLocalized >(_ value: (Self) -> Placeholder) -> Self {
        return self.placeholder(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholderFont(_ value: UI.Font?) -> Self {
        self.placeholderFont = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderFont(_ value: () -> UI.Font?) -> Self {
        return self.placeholderFont(value())
    }

    @inlinable
    @discardableResult
    func placeholderFont(_ value: (Self) -> UI.Font?) -> Self {
        return self.placeholderFont(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholderColor(_ value: UI.Color?) -> Self {
        self.placeholderColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderColor(_ value: () -> UI.Color?) -> Self {
        return self.placeholderColor(value())
    }

    @inlinable
    @discardableResult
    func placeholderColor(_ value: (Self) -> UI.Color?) -> Self {
        return self.placeholderColor(value(self))
    }
    
    @inlinable
    @discardableResult
    func placeholderInset(_ value: Inset?) -> Self {
        self.placeholderInset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func placeholderInset(_ value: () -> Inset?) -> Self {
        return self.placeholderInset(value())
    }

    @inlinable
    @discardableResult
    func placeholderInset(_ value: (Self) -> Inset?) -> Self {
        return self.placeholderInset(value(self))
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: UI.Text.Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> UI.Text.Alignment) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> UI.Text.Alignment) -> Self {
        return self.alignment(value(self))
    }
    
#if os(iOS)
    
    @inlinable
    @discardableResult
    func toolbar(_ value: UI.View.Input.Toolbar?) -> Self {
        self.toolbar = value
        return self
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: () -> UI.View.Input.Toolbar?) -> Self {
        return self.toolbar(value())
    }

    @inlinable
    @discardableResult
    func toolbar(_ value: (Self) -> UI.View.Input.Toolbar?) -> Self {
        return self.toolbar(value(self))
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: [IUIViewInputToolbarItem]) -> Self {
        self.toolbar = .toolbar(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: () -> [IUIViewInputToolbarItem]) -> Self {
        self.toolbar = .toolbar(value())
        return self
    }
    
    @inlinable
    @discardableResult
    func toolbar(_ value: (Self) -> [IUIViewInputToolbarItem]) -> Self {
        self.toolbar = .toolbar(value(self))
        return self
    }
    
    @inlinable
    @discardableResult
    func keyboard(_ value: UI.View.Input.Keyboard?) -> Self {
        self.keyboard = value
        return self
    }
    
    @inlinable
    @discardableResult
    func keyboard(_ value: () -> UI.View.Input.Keyboard?) -> Self {
        return self.keyboard(value())
    }

    @inlinable
    @discardableResult
    func keyboard(_ value: (Self) -> UI.View.Input.Keyboard?) -> Self {
        return self.keyboard(value(self))
    }
    
#endif
    
}

public extension UI.View.Input.Measurement.Plain {
    
    @inlinable
    @discardableResult
    func onPressedReturn(_ closure: (() -> Void)?) -> Self {
        self.onPressedReturn.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressedReturn(_ closure: @escaping (Self) -> Void) -> Self {
        self.onPressedReturn.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressedReturn< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onPressedReturn.link(sender, closure)
        return self
    }
    
}

public extension UI.View.Input.Measurement.Plain {
    
    @inlinable
    @available(*, deprecated, renamed: "UI.View.Input.Measurement.Plain.value")
    var measurement: Foundation.Measurement< UnitType >? {
        set { self.value = newValue }
        get { self.value }
    }
    
    @inlinable
    @discardableResult
    @available(*, deprecated, renamed: "UI.View.Input.Measurement.Plain.value(_:)")
    func measurement(_ value: Foundation.Measurement< UnitType >) -> Self {
        self.value = value
        return self
    }
    
    @inlinable
    @discardableResult
    @available(*, deprecated, renamed: "UI.View.Input.Measurement.Plain.value(_:)")
    func measurement(_ value: () -> Foundation.Measurement< UnitType >) -> Self {
        return self.measurement(value())
    }

    @inlinable
    @discardableResult
    @available(*, deprecated, renamed: "UI.View.Input.Measurement.Plain.value(_:)")
    func measurement(_ value: (Self) -> Foundation.Measurement< UnitType >) -> Self {
        return self.measurement(value(self))
    }
    
}

extension UI.View.Input.Measurement.Plain : IUIView {
    
    public var native: NativeView {
        self._view
    }
    
    public var isLoaded: Bool {
        self._reuse.isLoaded
    }
    
    public var bounds: Rect {
        guard self.isLoaded == true else { return .zero }
        return .init(self._view.bounds)
    }
    
    public func loadIfNeeded() {
        self._reuse.loadIfNeeded()
    }
    
    public func size(available: Size) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.size.apply(available: available)
    }
    
    public func appear(to layout: IUILayout) {
        self.appearedLayout = layout
#if os(iOS)
        self.toolbar?.appear(to: self)
#endif
        self.onAppear.emit()
    }
    
    public func disappear() {
#if os(iOS)
        self.toolbar?.disappear()
#endif
        self._reuse.disappear()
        self.appearedLayout = nil
        self.onDisappear.emit()
    }
    
    public func visible() {
        self.isVisible = true
        self.onVisible.emit()
    }
    
    public func invisible() {
        self.isVisible = false
        self.onInvisible.emit()
    }
    
}

extension UI.View.Input.Measurement.Plain : IUIViewReusable {
    
    public var reuseUnloadBehaviour: UI.Reuse.UnloadBehaviour {
        set { self._reuse.unloadBehaviour = newValue }
        get { self._reuse.unloadBehaviour }
    }
    
    public var reuseCache: UI.Reuse.Cache? {
        set { self._reuse.cache = newValue }
        get { self._reuse.cache }
    }
    
    public var reuseName: Swift.String? {
        set { self._reuse.name = newValue }
        get { self._reuse.name }
    }
    
}

#if os(iOS)

extension UI.View.Input.Measurement.Plain : IUIViewTransformable {
}

#endif

extension UI.View.Input.Measurement.Plain : IUIViewStaticSizeable {
}

extension UI.View.Input.Measurement.Plain : IUIViewInputable {
    
    public var isEditing: Bool {
        guard self.isLoaded == true else { return false }
        return self._view.isFirstResponder
    }
    
    @discardableResult
    public func startEditing() -> Self {
        self._view.becomeFirstResponder()
        return self
    }
    
    @discardableResult
    public func endEditing() -> Self {
        self._view.endEditing(false)
        return self
    }
    
}

extension UI.View.Input.Measurement.Plain : KKInputMeasurementPlainViewDelegate {
    
    func beginEditing(_ view: KKInputMeasurementPlainView) {
        self.onBeginEditing.emit()
    }
    
    func editing(_ view: KKInputMeasurementPlainView, value: NSMeasurement?) {
        guard let value = value as? Measurement< UnitType > else {
            return
        }
        if self._value != value {
            self._value = value
            self.onEditing.emit()
        }
    }
    
    func endEditing(_ view: KKInputMeasurementPlainView) {
        self.onEndEditing.emit()
    }
    
    func pressedReturn(_ view: KKInputMeasurementPlainView) {
        self.onPressedReturn.emit()
    }
    
}

public extension IUIView {
    
    @inlinable
    static func input(acceleration: UnitAcceleration) -> Self where Self == UI.View.Input.Measurement.Plain< UnitAcceleration > {
        return .init(unit: acceleration)
    }
    
    @inlinable
    static func input(angle: UnitAngle) -> Self where Self == UI.View.Input.Measurement.Plain< UnitAngle > {
        return .init(unit: angle)
    }
    
    @inlinable
    static func input(area: UnitArea) -> Self where Self == UI.View.Input.Measurement.Plain< UnitArea > {
        return .init(unit: area)
    }
    
    @inlinable
    static func input(concentrationMass: UnitConcentrationMass) -> Self where Self == UI.View.Input.Measurement.Plain< UnitConcentrationMass > {
        return .init(unit: concentrationMass)
    }
    
    @inlinable
    static func input(dispersion: UnitDispersion) -> Self where Self == UI.View.Input.Measurement.Plain< UnitDispersion > {
        return .init(unit: dispersion)
    }
    
    @inlinable
    static func input(duration: UnitDuration) -> Self where Self == UI.View.Input.Measurement.Plain< UnitDuration > {
        return .init(unit: duration)
    }
    
    @inlinable
    static func input(electricCharge: UnitElectricCharge) -> Self where Self == UI.View.Input.Measurement.Plain< UnitElectricCharge > {
        return .init(unit: electricCharge)
    }
    
    @inlinable
    static func input(electricCurrent: UnitElectricCurrent) -> Self where Self == UI.View.Input.Measurement.Plain< UnitElectricCurrent > {
        return .init(unit: electricCurrent)
    }
    
    @inlinable
    static func input(electricPotentialDifference: UnitElectricPotentialDifference) -> Self where Self == UI.View.Input.Measurement.Plain< UnitElectricPotentialDifference > {
        return .init(unit: electricPotentialDifference)
    }
    
    @inlinable
    static func input(electricResistance: UnitElectricResistance) -> Self where Self == UI.View.Input.Measurement.Plain< UnitElectricResistance > {
        return .init(unit: electricResistance)
    }
    
    @inlinable
    static func input(energy: UnitEnergy) -> Self where Self == UI.View.Input.Measurement.Plain< UnitEnergy > {
        return .init(unit: energy)
    }
    
    @inlinable
    static func input(frequency: UnitFrequency) -> Self where Self == UI.View.Input.Measurement.Plain< UnitFrequency > {
        return .init(unit: frequency)
    }
    
    @inlinable
    static func input(fuelEfficiency: UnitFuelEfficiency) -> Self where Self == UI.View.Input.Measurement.Plain< UnitFuelEfficiency > {
        return .init(unit: fuelEfficiency)
    }
    
    @inlinable
    static func input(illuminance: UnitIlluminance) -> Self where Self == UI.View.Input.Measurement.Plain< UnitIlluminance > {
        return .init(unit: illuminance)
    }
    
    @inlinable
    @available(iOS 13.0, *)
    static func input(informationStorage: UnitInformationStorage) -> Self where Self == UI.View.Input.Measurement.Plain< UnitInformationStorage > {
        return .init(unit: informationStorage)
    }
    
    @inlinable
    static func input(length: UnitLength) -> Self where Self == UI.View.Input.Measurement.Plain< UnitLength > {
        return .init(unit: length)
    }
    
    @inlinable
    static func input(mass: UnitMass) -> Self where Self == UI.View.Input.Measurement.Plain< UnitMass > {
        return .init(unit: mass)
    }
    
    @inlinable
    static func input(pressure: UnitPressure) -> Self where Self == UI.View.Input.Measurement.Plain< UnitPressure > {
        return .init(unit: pressure)
    }
    
    @inlinable
    static func input(speed: UnitSpeed) -> Self where Self == UI.View.Input.Measurement.Plain< UnitSpeed > {
        return .init(unit: speed)
    }
    
    @inlinable
    static func input(temperature: UnitTemperature) -> Self where Self == UI.View.Input.Measurement.Plain< UnitTemperature > {
        return .init(unit: temperature)
    }
    
    @inlinable
    static func input(volume: UnitVolume) -> Self where Self == UI.View.Input.Measurement.Plain< UnitVolume > {
        return .init(unit: volume)
    }
    
}

#endif
