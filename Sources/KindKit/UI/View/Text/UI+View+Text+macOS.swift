//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.Text {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Text
        typealias Content = KKTextView

        static var reuseIdentificator: String {
            return "UI.View.Text"
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

final class KKTextView : NSTextView {
    
    weak var kkDelegate: KKControlViewDelegate?
    let kkTextStorage: NSTextStorage
    let kkTextContainer: NSTextContainer
    let kkLayoutManager: NSLayoutManager
    
    override var isFlipped: Bool {
        return true
    }
    override var alignmentRectInsets: NSEdgeInsets {
        return .init()
    }
    override var textContainerOrigin: NSPoint {
        let bounds = self.bounds
        let textSize = self.kkLayoutManager.usedRect(for: self.kkTextContainer)
        return .init(
            x: 0,
            y: (bounds.height / 2) - (textSize.height / 2)
        )
    }
    
    override init(frame: CGRect) {
        self.kkTextStorage = NSTextStorage()
        self.kkTextContainer = NSTextContainer(containerSize: frame.size)
        self.kkTextContainer.lineFragmentPadding = 0
        
        self.kkLayoutManager = NSLayoutManager()
        self.kkLayoutManager.addTextContainer(self.kkTextContainer)
        self.kkTextStorage.addLayoutManager(self.kkLayoutManager)
        
        super.init(frame: frame, textContainer: self.kkTextContainer)
        
        self.textContainerInset = .zero
        self.drawsBackground = true
        self.isEditable = false
        self.isSelectable = false
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        self.kkTextContainer.containerSize = newSize
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
}

extension KKTextView {
    
    func update(view: UI.View.Text) {
        self.update(frame: view.frame)
        self.update(text: view.text)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(alignment: view.alignment)
        self.update(lineBreak: view.lineBreak)
        self.update(numberOfLines: view.numberOfLines)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.integral.cgRect
    }
    
    func update(text: String) {
        self.string = text
    }
    
    func update(textFont: UI.Font) {
        self.font = textFont.native
    }
    
    func update(textColor: UI.Color) {
        self.textColor = textColor.native
    }
    
    func update(alignment: UI.Text.Alignment) {
        self.alignment = alignment.nsTextAlignment
    }
    
    func update(lineBreak: UI.Text.LineBreak) {
        self.kkTextContainer.lineBreakMode = lineBreak.nsLineBreakMode
    }
    
    func update(numberOfLines: UInt) {
        self.kkTextContainer.maximumNumberOfLines = Int(numberOfLines)
    }
    
    func update(color: UI.Color?) {
        if let color = color {
            self.backgroundColor = color.native
        } else {
            self.backgroundColor = .clear
        }
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
