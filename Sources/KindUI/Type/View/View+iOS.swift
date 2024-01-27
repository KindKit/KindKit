//
//  KindKit
//

#if os(iOS)

import UIKit
import KindLayout
import KindMonadicMacro

@KindMonadic
public final class View : UIView {
    
    public override var frame: CGRect {
        didSet {
            guard self.frame != oldValue else { return }
            self.manager.viewSize = .init(self.frame.size)
        }
    }
    
    @KindMonadicProperty
    public var content: any IView {
        set { self.layout.content = newValue }
        get { self.layout.content }
    }
    
    let manager = KindLayout.Manager< AnyViewLayout >()
        .lockUpdate()
        .viewSize(.infinity)
    
    let layout: AnyViewLayout
    
    public override init(frame: CGRect) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(view: any IView) {
        self.layout = .init(view)
        
        super.init(frame: .zero)
        
        self._setup()
    }
    
    deinit {
        self.manager
            .lockUpdate()
            .content(nil)
            .holder(nil)
    }
    
}

private extension View {
    
    func _setup() {
        self.manager
            .holder(LayoutHolder(self))
            .content(self.layout)
            .onContentSize(self, { $0._onContentSize() })
            .unlockUpdate()
    }
    
    func _onContentSize() {
        self.frame.size = self.manager.contentSize.cgSize
    }
    
}

public extension View {
    
    @inlinable
    func snapshot() -> Image? {
        guard let image = self.kk_snapshot() else { return nil }
        return .init(image)
    }
    
}

#endif
