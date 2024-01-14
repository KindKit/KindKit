//
//  KindKit
//

import KindEvent
import KindGraphics
import KindMarkdown

public extension Style.Text {
    
    final class Specific {
        
        public var inherit: Style.Text.Specific? {
            set {
                guard self._inherit !== newValue else { return }
                self._inherit = newValue
                self._subscribe(to: newValue)
                self._change()
            }
            get {
                return self._inherit
            }
        }
        public var fontFamily: Style.Text.FontFamily? {
            set {
                guard self._fontFamily != newValue else { return }
                self._fontFamily = newValue
                self._change()
            }
            get {
                return self._fontFamily ?? self.inherit?.fontFamily
            }
        }
        public var fontWeight: Style.Text.FontWeight? {
            set {
                guard self._fontWeight != newValue else { return }
                self._fontWeight = newValue
                self._change()
            }
            get {
                return self._fontWeight ?? self.inherit?.fontWeight
            }
        }
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
        public var underlineStyle: KindGraphics.Text.Underline? {
            set {
                guard self._underlineStyle != newValue else { return }
                self._underlineStyle = newValue
                self._change()
            }
            get {
                return self._underlineStyle ?? self.inherit?.underlineStyle
            }
        }
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
        public var strikethroughStyle: KindGraphics.Text.Strikethrough? {
            set {
                guard self._strikethroughStyle != newValue else { return }
                self._strikethroughStyle = newValue
                self._change()
            }
            get {
                return self._strikethroughStyle ?? self.inherit?.strikethroughStyle
            }
        }
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
        public var alignment: KindGraphics.Text.Alignment? {
            set {
                guard self._alignment != newValue else { return }
                self._alignment = newValue
                self._change()
            }
            get {
                return self._alignment ?? self.inherit?.alignment
            }
        }
        public var lineBreak: KindGraphics.Text.LineBreak? {
            set {
                guard self._lineBreak != newValue else { return }
                self._lineBreak = newValue
                self._change()
            }
            get {
                return self._lineBreak ?? self.inherit?.lineBreak
            }
        }
        public var baseWritingDirection: KindGraphics.Text.WritingDirection? {
            set {
                guard self._baseWritingDirection != newValue else { return }
                self._baseWritingDirection = newValue
                self._change()
            }
            get {
                return self._baseWritingDirection ?? self.inherit?.baseWritingDirection
            }
        }
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
        public let onChanged = Signal< Void, Void >()
        
        private weak var _inherit: Style.Text.Specific?
        private var _inheritChangeListner: ICancellable?
        private var _fontFamily: Style.Text.FontFamily? = nil
        private var _fontWeight: Style.Text.FontWeight? = nil
        private var _fontSize: Double? = nil
        private var _fontSizeMultiple: Double? = nil
        private var _fontColor: Color? = nil
        private var _strokeWidth: Double? = nil
        private var _strokeColor: Color? = nil
        private var _underlineStyle: KindGraphics.Text.Underline? = nil
        private var _underlineColor: Color? = nil
        private var _strikethroughStyle: KindGraphics.Text.Strikethrough? = nil
        private var _strikethroughColor: Color? = nil
        private var _ligatures: Bool? = nil
        private var _kerning: Double? = nil
        private var _firstLineIndent: Double? = nil
        private var _lineSpacing: Double? = nil
        private var _minimumLineHeight: Double? = nil
        private var _maximumLineHeight: Double? = nil
        private var _lineHeightMultiple: Double? = nil
        private var _alignment: KindGraphics.Text.Alignment? = nil
        private var _lineBreak: KindGraphics.Text.LineBreak? = nil
        private var _baseWritingDirection: KindGraphics.Text.WritingDirection? = nil
        private var _hyphenationFactor: Float? = nil
        private var _attributes: [KindMarkdown.Text.Options : [NSAttributedString.Key : Any]] = [:]
        
        public init() {
        }
        
        public init(
            inherit: Specific
        ) {
            self._inherit = inherit
            self._subscribe(to: inherit)
        }
        
    }
    
}

private extension Style.Text.Specific {
    
    func _subscribe(to inherit: Style.Text.Specific?) {
        if let inherit = inherit {
            self._inheritChangeListner = inherit.onChanged.add(self, { $0._onChange() }).autoCancel()
        } else {
            self._inheritChangeListner = nil
        }
    }
    
    @inline(__always)
    func _change() {
        self._attributes.removeAll(keepingCapacity: true)
        self.onChanged.emit()
    }
    
    func _onChange() {
        self._change()
    }
    
}

public extension Style.Text.Specific {
    
    @inlinable
    func fontFamily(_ value: Style.Text.FontFamily?) -> Self {
        self.fontFamily = value
        return self
    }
    
    @inlinable
    func fontWeight(_ value: Style.Text.FontWeight?) -> Self {
        self.fontWeight = value
        return self
    }
              
    @inlinable
    func fontSize(_ value: Double?) -> Self {
        self.fontSize = value
        return self
    }
    
    @inlinable
    func fontSizeMultiple(_ value: Double?) -> Self {
        self.fontSizeMultiple = value
        return self
    }
                  
    @inlinable
    func fontColor(_ value: Color?) -> Self {
        self.fontColor = value
        return self
    }
    
    @inlinable
    func strokeWidth(_ value: Double?) -> Self {
        self.strokeWidth = value
        return self
    }
                 
    @inlinable
    func strokeColor(_ value: Color?) -> Self {
        self.strokeColor = value
        return self
    }
    
    @inlinable
    func underlineStyle(_ value: KindGraphics.Text.Underline?) -> Self {
        self.underlineStyle = value
        return self
    }
             
    @inlinable
    func underlineColor(_ value: Color?) -> Self {
        self.underlineColor = value
        return self
    }
    
    @inlinable
    func strikethroughStyle(_ value: KindGraphics.Text.Strikethrough?) -> Self {
        self.strikethroughStyle = value
        return self
    }
              
    @inlinable
    func strikethroughColor(_ value: Color?) -> Self {
        self.strikethroughColor = value
        return self
    }
    
    @inlinable
    func ligatures(_ value: Bool?) -> Self {
        self.ligatures = value
        return self
    }
             
    @inlinable
    func kerning(_ value: Double?) -> Self {
        self.kerning = value
        return self
    }
    
    @inlinable
    func firstLineIndent(_ value: Double?) -> Self {
        self.firstLineIndent = value
        return self
    }
                
    @inlinable
    func lineSpacing(_ value: Double?) -> Self {
        self.lineSpacing = value
        return self
    }
                
    @inlinable
    func minimumLineHeight(_ value: Double?) -> Self {
        self.minimumLineHeight = value
        return self
    }
              
    @inlinable
    func maximumLineHeight(_ value: Double?) -> Self {
        self.maximumLineHeight = value
        return self
    }
              
    @inlinable
    func lineHeightMultiple(_ value: Double?) -> Self {
        self.lineHeightMultiple = value
        return self
    }
           
    @inlinable
    func alignment(_ value: KindGraphics.Text.Alignment?) -> Self {
        self.alignment = value
        return self
    }
             
    @inlinable
    func lineBreak(_ value: KindGraphics.Text.LineBreak?) -> Self {
        self.lineBreak = value
        return self
    }
                 
    @inlinable
    func baseWritingDirection(_ value: KindGraphics.Text.WritingDirection?) -> Self {
        self.baseWritingDirection = value
        return self
    }

    @inlinable
    func hyphenationFactor(_ value: Float?) -> Self {
        self.hyphenationFactor = value
        return self
    }
    
}

public extension Style.Text.Specific {
    
    func attribures(options: KindMarkdown.Text.Options) -> [NSAttributedString.Key : Any] {
        if let attributes = self._attributes[options] {
            return attributes
        }
        var attributes: [NSAttributedString.Key : Any] = [:]
        if let fontSize = self.fontSize {
#if os(macOS)
            typealias Font = NSFont
            typealias FontDescriptor = NSFontDescriptor
#elseif os(iOS)
            typealias Font = UIFont
            typealias FontDescriptor = UIFontDescriptor
#endif
            let fontSizeMultiple = self.fontSizeMultiple ?? 1.0
            var fontAttributes: [FontDescriptor.AttributeName : Any] = [
                .size : fontSize * fontSizeMultiple
            ]
            if let fontFamily = self.fontFamily {
                switch fontFamily {
                case .system:
                    let systemFont = Font.systemFont(ofSize: fontSize)
                    fontAttributes[.family] = systemFont.familyName
                case .custom(let family):
                    fontAttributes[.family] = family
                }
            }
            var traits: [FontDescriptor.TraitKey : Any] = [:]
#if os(macOS)
            var symbolic = NSFontDescriptor.SymbolicTraits()
            if options.contains(.italic) {
                symbolic = symbolic.union(.italic)
            }
            if options.contains(.bold) {
                symbolic = symbolic.union(.bold)
            }
#elseif os(iOS)
            var symbolic = UIFontDescriptor.SymbolicTraits()
            if options.contains(.italic) {
                symbolic = symbolic.union(.traitItalic)
            }
            if options.contains(.bold) {
                symbolic = symbolic.union(.traitBold)
            }
#endif
            if symbolic.isEmpty == false {
                traits[.symbolic] = symbolic.rawValue
            }
            if let fontWeight = self.fontWeight {
                traits[.weight] = CGFloat(fontWeight.value)
            }
            if traits.isEmpty == false {
                fontAttributes[.traits] = traits
            }
            attributes[.font] = Font(
                descriptor: FontDescriptor(
                    fontAttributes: fontAttributes
                ),
                size: fontSize * fontSizeMultiple
            )
        }
        let fontColor = self.fontColor
        if let fontColor = fontColor {
            attributes[.foregroundColor] = fontColor.native
        }
        if let strokeColor = self.strokeColor {
            attributes[.strokeWidth] = self.strokeWidth ?? 1
            attributes[.strokeColor] = strokeColor.native
        }
        if options.contains(.underline) == true {
            let underlineStyle = self.underlineStyle ?? .single
            let underlineColor = self.underlineColor ?? fontColor
            if let underlineColor = underlineColor {
                attributes[.underlineStyle] = underlineStyle.nsUnderlineStyle.rawValue
                attributes[.underlineColor] = underlineColor.native
            }
        }
        if options.contains(.strikethrough) == true {
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
        self._attributes[options] = attributes
        return attributes
    }
    
}
