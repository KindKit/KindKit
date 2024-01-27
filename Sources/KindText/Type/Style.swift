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
        set {
            guard self._inherit !== newValue else { return }
            if let inherit = self._inherit {
                inherit._remove(descendant: self)
            }
            self._inherit = newValue
            if let inherit = self._inherit {
                inherit._append(descendant: self)
            }
            self._reset(
                attributes: true,
                fonts: true,
                descendants: false
            )
            self.update()
        }
        get {
            return self._inherit
        }
    }
    
    @KindMonadicProperty
    public var fontFamily: FontFamily? {
        set {
            guard self._fontFamily != newValue else { return }
            self._fontFamily = newValue
            self._reset(attributes: true, fonts: true)
            self.update()
        }
        get {
            return self._fontFamily ?? self._inherit?.fontFamily
        }
    }
    
    @KindMonadicProperty
    public var fontWeight: FontWeight? {
        set {
            guard self._fontWeight != newValue else { return }
            self._fontWeight = newValue
            self._reset(attributes: true, fonts: true)
            self.update()
        }
        get {
            return self._fontWeight ?? self._inherit?.fontWeight
        }
    }
    
    @KindMonadicProperty
    public var fontSize: Double? {
        set {
            guard self._fontSize != newValue else { return }
            self._fontSize = newValue
            self._reset(attributes: true, fonts: true)
            self.update()
        }
        get {
            return self._fontSize ?? self._inherit?.fontSize
        }
    }
    
    @KindMonadicProperty
    public var fontSizeMultiple: Double? {
        set {
            guard self._fontSizeMultiple != newValue else { return }
            self._fontSizeMultiple = newValue
            self._reset(attributes: true, fonts: true)
            self.update()
        }
        get {
            return self._fontSizeMultiple ?? self._inherit?.fontSizeMultiple
        }
    }
    
    @KindMonadicProperty
    public var fontColor: Color? {
        set {
            guard self._fontColor != newValue else { return }
            self._fontColor = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._fontColor ?? self._inherit?.fontColor
        }
    }
    
    @KindMonadicProperty
    public var strokeWidth: Double? {
        set {
            guard self._strokeWidth != newValue else { return }
            self._strokeWidth = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._strokeWidth ?? self._inherit?.strokeWidth
        }
    }
    
    @KindMonadicProperty
    public var strokeColor: Color? {
        set {
            guard self._strokeColor != newValue else { return }
            self._strokeColor = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._strokeColor ?? self._inherit?.strokeColor
        }
    }
    
    @KindMonadicProperty
    public var underlineStyle: TextUnderline? {
        set {
            guard self._underlineStyle != newValue else { return }
            self._underlineStyle = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._underlineStyle ?? self._inherit?.underlineStyle
        }
    }
    
    @KindMonadicProperty
    public var underlineColor: Color? {
        set {
            guard self._underlineColor != newValue else { return }
            self._underlineColor = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._underlineColor ?? self._inherit?.underlineColor
        }
    }
    
    @KindMonadicProperty
    public var strikethroughStyle: TextStrikethrough? {
        set {
            guard self._strikethroughStyle != newValue else { return }
            self._strikethroughStyle = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._strikethroughStyle ?? self._inherit?.strikethroughStyle
        }
    }
    
    @KindMonadicProperty
    public var strikethroughColor: Color? {
        set {
            guard self._strikethroughColor != newValue else { return }
            self._strikethroughColor = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._strikethroughColor ?? self._inherit?.strikethroughColor
        }
    }
    
    @KindMonadicProperty
    public var ligatures: Bool? {
        set {
            guard self._ligatures != newValue else { return }
            self._ligatures = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._ligatures ?? self._inherit?.ligatures
        }
    }
    
    @KindMonadicProperty
    public var kerning: Double? {
        set {
            guard self._kerning != newValue else { return }
            self._kerning = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._kerning ?? self._inherit?.kerning
        }
    }
    
    @KindMonadicProperty
    public var firstLineIndent: Double? {
        set {
            guard self._firstLineIndent != newValue else { return }
            self._firstLineIndent = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._firstLineIndent ?? self._inherit?.firstLineIndent
        }
    }
    
    @KindMonadicProperty
    public var lineSpacing: Double? {
        set {
            guard self._lineSpacing != newValue else { return }
            self._lineSpacing = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._lineSpacing ?? self._inherit?.lineSpacing
        }
    }
    
    @KindMonadicProperty
    public var minimumLineHeight: Double? {
        set {
            guard self._minimumLineHeight != newValue else { return }
            self._minimumLineHeight = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._minimumLineHeight ?? self._inherit?.minimumLineHeight
        }
    }
    
    @KindMonadicProperty
    public var maximumLineHeight: Double? {
        set {
            guard self._maximumLineHeight != newValue else { return }
            self._maximumLineHeight = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._maximumLineHeight ?? self._inherit?.maximumLineHeight
        }
    }
    
    @KindMonadicProperty
    public var lineHeightMultiple: Double? {
        set {
            guard self._lineHeightMultiple != newValue else { return }
            self._lineHeightMultiple = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._lineHeightMultiple ?? self._inherit?.lineHeightMultiple
        }
    }
    
    @KindMonadicProperty
    public var alignment: TextAlignment? {
        set {
            guard self._alignment != newValue else { return }
            self._alignment = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._alignment ?? self._inherit?.alignment
        }
    }
    
    @KindMonadicProperty
    public var lineBreak: TextLineBreak? {
        set {
            guard self._lineBreak != newValue else { return }
            self._lineBreak = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._lineBreak ?? self._inherit?.lineBreak
        }
    }
    
    @KindMonadicProperty
    public var baseWritingDirection: TextWritingDirection? {
        set {
            guard self._baseWritingDirection != newValue else { return }
            self._baseWritingDirection = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._baseWritingDirection ?? self._inherit?.baseWritingDirection
        }
    }
    
    @KindMonadicProperty
    public var hyphenationFactor: Float? {
        set {
            guard self._hyphenationFactor != newValue else { return }
            self._hyphenationFactor = newValue
            self._reset(attributes: true)
            self.update()
        }
        get {
            return self._hyphenationFactor ?? self._inherit?.hyphenationFactor
        }
    }
    
    @KindMonadicSignal
    public let onChanged = Signal< Void, Void >()
    
    private weak var _inherit: Style?
    private var _descendants: [Style] = []
    private var _fontFamily: FontFamily?
    private var _fontWeight: FontWeight?
    private var _fontSize: Double?
    private var _fontSizeMultiple: Double?
    private var _fontColor: Color?
    private var _strokeWidth: Double?
    private var _strokeColor: Color?
    private var _underlineStyle: TextUnderline?
    private var _underlineColor: Color?
    private var _strikethroughStyle: TextStrikethrough?
    private var _strikethroughColor: Color?
    private var _ligatures: Bool?
    private var _kerning: Double?
    private var _firstLineIndent: Double?
    private var _lineSpacing: Double?
    private var _minimumLineHeight: Double?
    private var _maximumLineHeight: Double?
    private var _lineHeightMultiple: Double?
    private var _alignment: TextAlignment?
    private var _lineBreak: TextLineBreak?
    private var _baseWritingDirection: TextWritingDirection?
    private var _hyphenationFactor: Float?
    private var _updateCounter = UInt.zero
    private var _cacheFonts: [TextFlags : Font] = [:]
    private var _cacheAttributes: [TextFlags : [NSAttributedString.Key : Any]] = [:]
    
    public init() {
    }
    
}

public extension Style {
    
    static let `default` = Style()
    
}

extension Style : IBatchUpdate {
    
    @discardableResult
    public func lockUpdate() -> Self {
        self._updateCounter += 1
        for descendant in self._descendants {
            descendant.update()
        }
        return self
    }
    
    @discardableResult
    public func unlockUpdate() -> Self {
        if self._updateCounter > 0 {
            self._updateCounter -= 1
        }
        for descendant in self._descendants {
            descendant.unlockUpdate()
        }
        return self.update()
    }
    
    @discardableResult
    public func update() -> Self {
        if self._updateCounter == 0 {
            self.onChanged.emit()
            for descendant in self._descendants {
                descendant.update()
            }
        }
        return self
    }
    
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
    
    func font(flags: TextFlags) -> Font? {
        if let font = self._cacheFonts[flags] {
            return font
        }
        guard let fontSize = self.fontSize else {
            return nil
        }
        let fontSizeMultiple = self.fontSizeMultiple ?? 1.0
        let font = Font(
            flags: flags,
            family: self.fontFamily,
            weight: self.fontWeight,
            size: fontSize * fontSizeMultiple
        )
        self._cacheFonts[flags] = font
        return font
    }
    
    func attribures(flags: TextFlags) -> [NSAttributedString.Key : Any] {
        if let attributes = self._cacheAttributes[flags] {
            return attributes
        }
        var attributes: [NSAttributedString.Key : Any] = [:]
        if let font = self.font(flags: flags) {
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
        self._cacheAttributes[flags] = attributes
        return attributes
    }
    
}

private extension Style {
    
    func _append(descendant: Style) {
        guard self._descendants.contains(descendant) == false else { return }
        self._descendants.append(descendant)
        descendant.inherit = self
        descendant._reset(attributes: true, fonts: true)
    }

    func _remove(descendant: Style) {
        guard let index = self._descendants.firstIndex(of: descendant) else { return }
        self._descendants.remove(at: index)
        descendant.inherit = nil
        descendant._reset(attributes: true, fonts: true)
    }
    
    func _reset(
        attributes: Bool = false,
        fonts: Bool = false,
        descendants: Bool = true
    ) {
        do {
            if attributes == true {
                self._cacheAttributes.removeAll(keepingCapacity: true)
            }
            if fonts == true {
                self._cacheFonts.removeAll(keepingCapacity: true)
            }
        }
        for descendant in self._descendants {
            descendant._reset(attributes: attributes, fonts: fonts)
        }
    }
    
}
