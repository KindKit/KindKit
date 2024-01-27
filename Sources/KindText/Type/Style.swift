//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindEvent
import KindGraphics
import KindMonadicMacro

@KindMonadic
public final class Style {
    
    @KindMonadicProperty
    public var inherit: Style? {
        willSet {
            guard self.inherit !== newValue else { return }
            self.inherit?.onChanged(remove: self)
        }
        didSet {
            guard self.inherit !== oldValue else { return }
            self.inherit?.onChanged(self, { $0._change() })
            self._change()
        }
    }
    
    @KindMonadicProperty
    public var fontFamily: FontFamily? {
        set {
            guard self._fontFamily != newValue else { return }
            self._fontFamily = newValue
            self._change()
        }
        get {
            return self._fontFamily ?? self.inherit?.fontFamily
        }
    }
    
    @KindMonadicProperty
    public var fontWeight: FontWeight? {
        set {
            guard self._fontWeight != newValue else { return }
            self._fontWeight = newValue
            self._change()
        }
        get {
            return self._fontWeight ?? self.inherit?.fontWeight
        }
    }
    
    @KindMonadicProperty
    public var fontSize: Double? {
        set {
            guard self._fontSize != newValue else { return }
            self._fontSize = newValue
            self._change()
        }
        get {
            return self._fontSize ?? self.inherit?.fontSize
        }
    }
    
    @KindMonadicProperty
    public var fontSizeMultiple: Double? {
        set {
            guard self._fontSizeMultiple != newValue else { return }
            self._fontSizeMultiple = newValue
            self._change()
        }
        get {
            return self._fontSizeMultiple ?? self.inherit?.fontSizeMultiple
        }
    }
    
    @KindMonadicProperty
    public var fontColor: Color? {
        set {
            guard self._fontColor != newValue else { return }
            self._fontColor = newValue
            self._change()
        }
        get {
            return self._fontColor ?? self.inherit?.fontColor
        }
    }
    
    @KindMonadicProperty
    public var strokeWidth: Double? {
        set {
            guard self._strokeWidth != newValue else { return }
            self._strokeWidth = newValue
            self._change()
        }
        get {
            return self._strokeWidth ?? self.inherit?.strokeWidth
        }
    }
    
    @KindMonadicProperty
    public var strokeColor: Color? {
        set {
            guard self._strokeColor != newValue else { return }
            self._strokeColor = newValue
            self._change()
        }
        get {
            return self._strokeColor ?? self.inherit?.strokeColor
        }
    }
    
    @KindMonadicProperty
    public var underlineStyle: TextUnderline? {
        set {
            guard self._underlineStyle != newValue else { return }
            self._underlineStyle = newValue
            self._change()
        }
        get {
            return self._underlineStyle ?? self.inherit?.underlineStyle
        }
    }
    
    @KindMonadicProperty
    public var underlineColor: Color? {
        set {
            guard self._underlineColor != newValue else { return }
            self._underlineColor = newValue
            self._change()
        }
        get {
            return self._underlineColor ?? self.inherit?.underlineColor
        }
    }
    
    @KindMonadicProperty
    public var strikethroughStyle: TextStrikethrough? {
        set {
            guard self._strikethroughStyle != newValue else { return }
            self._strikethroughStyle = newValue
            self._change()
        }
        get {
            return self._strikethroughStyle ?? self.inherit?.strikethroughStyle
        }
    }
    
    @KindMonadicProperty
    public var strikethroughColor: Color? {
        set {
            guard self._strikethroughColor != newValue else { return }
            self._strikethroughColor = newValue
            self._change()
        }
        get {
            return self._strikethroughColor ?? self.inherit?.strikethroughColor
        }
    }
    
    @KindMonadicProperty
    public var ligatures: Bool? {
        set {
            guard self._ligatures != newValue else { return }
            self._ligatures = newValue
            self._change()
        }
        get {
            return self._ligatures ?? self.inherit?.ligatures
        }
    }
    
    @KindMonadicProperty
    public var kerning: Double? {
        set {
            guard self._kerning != newValue else { return }
            self._kerning = newValue
            self._change()
        }
        get {
            return self._kerning ?? self.inherit?.kerning
        }
    }
    
    @KindMonadicProperty
    public var firstLineIndent: Double? {
        set {
            guard self._firstLineIndent != newValue else { return }
            self._firstLineIndent = newValue
            self._change()
        }
        get {
            return self._firstLineIndent ?? self.inherit?.firstLineIndent
        }
    }
    
    @KindMonadicProperty
    public var lineSpacing: Double? {
        set {
            guard self._lineSpacing != newValue else { return }
            self._lineSpacing = newValue
            self._change()
        }
        get {
            return self._lineSpacing ?? self.inherit?.lineSpacing
        }
    }
    
    @KindMonadicProperty
    public var minimumLineHeight: Double? {
        set {
            guard self._minimumLineHeight != newValue else { return }
            self._minimumLineHeight = newValue
            self._change()
        }
        get {
            return self._minimumLineHeight ?? self.inherit?.minimumLineHeight
        }
    }
    
    @KindMonadicProperty
    public var maximumLineHeight: Double? {
        set {
            guard self._maximumLineHeight != newValue else { return }
            self._maximumLineHeight = newValue
            self._change()
        }
        get {
            return self._maximumLineHeight ?? self.inherit?.maximumLineHeight
        }
    }
    
    @KindMonadicProperty
    public var lineHeightMultiple: Double? {
        set {
            guard self._lineHeightMultiple != newValue else { return }
            self._lineHeightMultiple = newValue
            self._change()
        }
        get {
            return self._lineHeightMultiple ?? self.inherit?.lineHeightMultiple
        }
    }
    
    @KindMonadicProperty
    public var alignment: TextAlignment? {
        set {
            guard self._alignment != newValue else { return }
            self._alignment = newValue
            self._change()
        }
        get {
            return self._alignment ?? self.inherit?.alignment
        }
    }
    
    @KindMonadicProperty
    public var lineBreak: TextLineBreak? {
        set {
            guard self._lineBreak != newValue else { return }
            self._lineBreak = newValue
            self._change()
        }
        get {
            return self._lineBreak ?? self.inherit?.lineBreak
        }
    }
    
    @KindMonadicProperty
    public var baseWritingDirection: TextWritingDirection? {
        set {
            guard self._baseWritingDirection != newValue else { return }
            self._baseWritingDirection = newValue
            self._change()
        }
        get {
            return self._baseWritingDirection ?? self.inherit?.baseWritingDirection
        }
    }
    
    @KindMonadicProperty
    public var hyphenationFactor: Float? {
        set {
            guard self._hyphenationFactor != newValue else { return }
            self._hyphenationFactor = newValue
            self._change()
        }
        get {
            return self._hyphenationFactor ?? self.inherit?.hyphenationFactor
        }
    }
    
    @KindMonadicSignal
    public let onChanged = Signal< Void, Void >()
    
    private var _fontFamily: FontFamily? = nil
    private var _fontWeight: FontWeight? = nil
    private var _fontSize: Double? = nil
    private var _fontSizeMultiple: Double? = nil
    private var _fontColor: Color? = nil
    private var _strokeWidth: Double? = nil
    private var _strokeColor: Color? = nil
    private var _underlineStyle: TextUnderline? = nil
    private var _underlineColor: Color? = nil
    private var _strikethroughStyle: TextStrikethrough? = nil
    private var _strikethroughColor: Color? = nil
    private var _ligatures: Bool? = nil
    private var _kerning: Double? = nil
    private var _firstLineIndent: Double? = nil
    private var _lineSpacing: Double? = nil
    private var _minimumLineHeight: Double? = nil
    private var _maximumLineHeight: Double? = nil
    private var _lineHeightMultiple: Double? = nil
    private var _alignment: TextAlignment? = nil
    private var _lineBreak: TextLineBreak? = nil
    private var _baseWritingDirection: TextWritingDirection? = nil
    private var _hyphenationFactor: Float? = nil
    private var _attributes: [TextFlags : [NSAttributedString.Key : Any]] = [:]
    
    public init() {
    }
    
    public convenience init(
        inherit: Style
    ) {
        self.init()
        self.inherit(inherit)
    }
    
}

private extension Style {
    
    func _change() {
        self._attributes.removeAll(keepingCapacity: true)
        self.onChanged.emit()
    }
    
}

public extension Style {
    
    static let `default` = Style()
    
}

extension Style : Equatable {
    
    public static func == (lhs: Style, rhs: Style) -> Bool {
        return lhs === rhs
    }
    
}

extension Style : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.inherit)
        hasher.combine(self._fontFamily)
        hasher.combine(self._fontWeight)
        hasher.combine(self._fontSize)
        hasher.combine(self._fontSizeMultiple)
        hasher.combine(self._fontColor)
        hasher.combine(self._strokeWidth)
        hasher.combine(self._strokeColor)
        hasher.combine(self._underlineStyle)
        hasher.combine(self._underlineColor)
        hasher.combine(self._strikethroughStyle)
        hasher.combine(self._strikethroughColor)
        hasher.combine(self._ligatures)
        hasher.combine(self._kerning)
        hasher.combine(self._firstLineIndent)
        hasher.combine(self._lineSpacing)
        hasher.combine(self._minimumLineHeight)
        hasher.combine(self._maximumLineHeight)
        hasher.combine(self._lineHeightMultiple)
        hasher.combine(self._alignment)
        hasher.combine(self._lineBreak)
        hasher.combine(self._baseWritingDirection)
        hasher.combine(self._hyphenationFactor)
    }
    
}

public extension Style {
    
    func attribures(flags: TextFlags) -> [NSAttributedString.Key : Any] {
        if let attributes = self._attributes[flags] {
            return attributes
        }
        var attributes: [NSAttributedString.Key : Any] = [:]
        if let fontSize = self.fontSize {
            let fontSizeMultiple = self.fontSizeMultiple ?? 1.0
            let font = Font(
                flags: flags,
                family: self.fontFamily,
                weight: self.fontWeight,
                size: fontSize * fontSizeMultiple
            )
            attributes[.font] = font.native
        }
        let fontColor = self.fontColor
        if let fontColor = fontColor {
            attributes[.foregroundColor] = fontColor.native
        }
        if let strokeColor = self.strokeColor {
            attributes[.strokeWidth] = self.strokeWidth ?? 1
            attributes[.strokeColor] = strokeColor.native
        }
        if flags.contains(.underline) == true {
            let underlineStyle = self.underlineStyle ?? .single
            let underlineColor = self.underlineColor ?? fontColor
            if let underlineColor = underlineColor {
                attributes[.underlineStyle] = underlineStyle.nsUnderlineStyle.rawValue
                attributes[.underlineColor] = underlineColor.native
            }
        }
        if flags.contains(.strikethrough) == true {
            let strikethroughStyle = self.strikethroughStyle ?? .single
            let strikethroughColor = self.strikethroughColor ?? fontColor
            if let strikethroughColor = strikethroughColor {
                attributes[.strikethroughStyle] = strikethroughStyle.nsUnderlineStyle.rawValue
                attributes[.strikethroughColor] = strikethroughColor.native
            }
        }
        let firstLineIndent = self.firstLineIndent
        let lineSpacing = self.lineSpacing
        let minimumLineHeight = self.minimumLineHeight
        let maximumLineHeight = self.maximumLineHeight
        let lineHeightMultiple = self.lineHeightMultiple
        let alignment = self.alignment
        let lineBreak = self.lineBreak
        let baseWritingDirection = self.baseWritingDirection
        let hyphenationFactor = self.hyphenationFactor
        if firstLineIndent != nil || lineSpacing != nil || minimumLineHeight != nil || maximumLineHeight != nil || lineHeightMultiple != nil || alignment != nil || lineBreak != nil || baseWritingDirection != nil || hyphenationFactor != nil {
            let paragraph = NSMutableParagraphStyle()
            if let firstLineIndent = firstLineIndent {
                paragraph.firstLineHeadIndent = firstLineIndent
            }
            if let lineSpacing = lineSpacing {
                paragraph.lineSpacing = lineSpacing
            }
            if let minimumLineHeight = minimumLineHeight {
                paragraph.minimumLineHeight = minimumLineHeight
            }
            if let maximumLineHeight = maximumLineHeight {
                paragraph.maximumLineHeight = maximumLineHeight
            }
            if let lineHeightMultiple = lineHeightMultiple {
                paragraph.lineHeightMultiple = lineHeightMultiple
            }
            if let alignment = alignment {
                paragraph.alignment = alignment.nsTextAlignment
            }
            if let lineBreak = lineBreak {
                paragraph.lineBreakMode = lineBreak.nsLineBreakMode
            }
            if let baseWritingDirection = baseWritingDirection {
                paragraph.baseWritingDirection = baseWritingDirection.nsWritingDirection
            }
            if let hyphenationFactor = hyphenationFactor {
                paragraph.hyphenationFactor = hyphenationFactor
            }
            attributes[.paragraphStyle] = paragraph
        }
        if let ligatures = self.ligatures {
            attributes[.ligature] = ligatures
        }
        if let kerning = self.kerning {
            attributes[.kern] = kerning
        }
        self._attributes[flags] = attributes
        return attributes
    }
    
}
