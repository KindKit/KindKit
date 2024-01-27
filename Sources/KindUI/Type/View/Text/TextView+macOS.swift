//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindMath

extension TextView {
    
    struct Reusable : IReusable {
        
        typealias Owner = TextView
        typealias Content = KKTextView
        
        static func name(owner: Owner) -> String {
            return "TextView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
        }
        
    }
    
}

final class KKTextView : NSTextView {
    
    weak var kkDelegate: KKTextViewDelegate?
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
    
    func kk_update(view: TextView) {
        self.kk_update(frame: view.frame)
        self.kk_update(attributed: view.attributed)
        self.kk_update(numberOfLines: view.numberOfLines)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func kk_cleanup(view: TextView) {
        self.kkDelegate = nil
    }
    
}

extension KKTextView {
    
    func kk_update(attributed: NSAttributedString) {
        self.kkTextStorage.setAttributedString(attributed)
    }
    
    func kk_update(numberOfLines: UInt) {
        self.kkTextContainer.maximumNumberOfLines = Int(numberOfLines)
    }
    
    func kk_update(color: Color) {
        self.backgroundColor = color.native
    }
    
    func kk_update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
}

#endif
