//
//  KindKit
//

#if os(iOS)

import UIKit
import KindEvent
import KindGraphics
import KindLayout
import KindMonadicMacro

@Monadic
public final class AccessoryView : UIView {
    
    public override var frame: CGRect {
        didSet {
            guard self.frame != oldValue else { return }
            self.manager.viewSize = .init(self.frame.size)
        }
    }
    
    @MonadicField
    public var toolbar: ToolbarView? {
        didSet {
            guard self.toolbar != oldValue else { return }
            if let toolbar = self.toolbar {
                self._toolbarLayout.content = .init(toolbar)
            } else {
                self._toolbarLayout.content = nil
            }
        }
    }
    
    @MonadicField
    public var suggesion: ToolbarView? {
        didSet {
            guard self.suggesion != oldValue else { return }
            if let suggesion = self.suggesion {
                self._suggesionLayout.content = .init(suggesion)
            } else {
                self._suggesionLayout.content = nil
            }
        }
    }
    
    internal let manager = KindLayout.Manager< VStackLayout >()
        .lockUpdate()
        .available(.init(width: .fill, height: .fit))
        .viewSize(.infinity)
    
    private let _layout = VStackLayout()
    private let _toolbarLayout = OptionalLayout< ViewLayout< ToolbarView > >()
    private let _suggesionLayout = OptionalLayout< ViewLayout< ToolbarView > >()
    
    public override init(frame: CGRect) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init(frame: .init(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: 0
        ))
        
        self._setup()
    }
    
    deinit {
        self.manager
            .lockUpdate()
            .content(nil)
            .holder(nil)
    }
    
}

private extension AccessoryView {
    
    final func _setup() {
        self.manager
            .holder(LayoutHolder(self))
            .content(self._layout)
            .onContentSize(self, { $0._onContentSize() })
            .unlockUpdate()
    }
    
    final func _onContentSize() {
        self.frame.size = self.manager.contentSize.cgSize
        
        if let firstResponder = UIApplication.shared.kk_firstResponder {
            firstResponder.reloadInputViews()
        }
    }
    
}

#endif
