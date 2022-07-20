//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public final class PincodeLayout<
    TitleView : IView,
    PincodeView : IView,
    ErrorView : IView,
    ButtonView : IView,
    AccessoryView : IView
> : ILayout {
    
    public unowned var delegate: ILayoutDelegate?
    public unowned var view: IView?
    public var titleInset: InsetFloat {
        didSet { self.setNeedForceUpdate() }
    }
    public var titleView: TitleView {
        didSet { self.titleItem = LayoutItem(view: self.titleView) }
    }
    public private(set) var titleItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var pincodeInset: InsetFloat {
        didSet { self.setNeedForceUpdate() }
    }
    public var pincodeView: PincodeView {
        didSet { self.pincodeItem = LayoutItem(view: self.pincodeView) }
    }
    public private(set) var pincodeItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var errorInset: InsetFloat {
        didSet { self.setNeedForceUpdate() }
    }
    public var errorView: ErrorView? {
        didSet {
            if let view = self.errorView {
                self.errorItem = LayoutItem(view: view)
            } else {
                self.errorItem = nil
            }
        }
    }
    public private(set) var errorItem: LayoutItem? {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonsInset: InsetFloat {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonsSpacing: PointFloat {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonsAspectRatio: Float {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonOneView: ButtonView {
        didSet { self.buttonOneItem = LayoutItem(view: self.buttonOneView) }
    }
    public private(set) var buttonOneItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonTwoView: ButtonView {
        didSet { self.buttonTwoItem = LayoutItem(view: self.buttonTwoView) }
    }
    public private(set) var buttonTwoItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonThreeView: ButtonView {
        didSet { self.buttonThreeItem = LayoutItem(view: self.buttonThreeView) }
    }
    public private(set) var buttonThreeItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonFourView: ButtonView {
        didSet { self.buttonFourItem = LayoutItem(view: self.buttonFourView) }
    }
    public private(set) var buttonFourItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonFiveView: ButtonView {
        didSet { self.buttonFiveItem = LayoutItem(view: self.buttonFiveView) }
    }
    public private(set) var buttonFiveItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonSixView: ButtonView {
        didSet { self.buttonSixItem = LayoutItem(view: self.buttonSixView) }
    }
    public private(set) var buttonSixItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonEightView: ButtonView {
        didSet { self.buttonEightItem = LayoutItem(view: self.buttonEightView) }
    }
    public private(set) var buttonEightItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonNineView: ButtonView {
        didSet { self.buttonNineItem = LayoutItem(view: self.buttonNineView) }
    }
    public private(set) var buttonNineItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var buttonZeroView: ButtonView {
        didSet { self.buttonZeroItem = LayoutItem(view: self.buttonZeroView) }
    }
    public private(set) var buttonZeroItem: LayoutItem {
        didSet { self.setNeedForceUpdate() }
    }
    public var accessoryLeftView: AccessoryView? {
        didSet {
            if let view = self.accessoryLeftView {
                self.accessoryLeftItem = LayoutItem(view: view)
            } else {
                self.accessoryLeftItem = nil
            }
        }
    }
    public private(set) var accessoryLeftItem: LayoutItem? {
        didSet { self.setNeedForceUpdate() }
    }
    public var accessoryRightView: AccessoryView? {
        didSet {
            if let view = self.accessoryRightView {
                self.accessoryRightItem = LayoutItem(view: view)
            } else {
                self.accessoryRightItem = nil
            }
        }
    }
    public private(set) var accessoryRightItem: LayoutItem? {
        didSet { self.setNeedForceUpdate() }
    }
    
    public init(
        titleInset: InsetFloat,
        titleView: TitleView,
        pincodeInset: InsetFloat,
        pincodeView: PincodeView,
        errorInset: InsetFloat,
        errorView: ErrorView? = nil,
        buttonsInset: InsetFloat,
        buttonsSpacing: PointFloat,
        buttonsAspectRatio: Float,
        buttonOneView: ButtonView,
        buttonTwoView: ButtonView,
        buttonThreeView: ButtonView,
        buttonFourView: ButtonView,
        buttonFiveView: ButtonView,
        buttonSixView: ButtonView,
        buttonEightView: ButtonView,
        buttonNineView: ButtonView,
        buttonZeroView: ButtonView,
        accessoryLeftView: AccessoryView? = nil,
        accessoryRightView: AccessoryView? = nil
    ) {
        self.titleInset = titleInset
        self.titleView = titleView
        self.titleItem = LayoutItem(view: titleView)
        self.pincodeInset = pincodeInset
        self.pincodeView = pincodeView
        self.pincodeItem = LayoutItem(view: pincodeView)
        self.errorInset = errorInset
        self.errorView = errorView
        if let view = errorView {
            self.errorItem = LayoutItem(view: view)
        }
        self.buttonsInset = buttonsInset
        self.buttonsSpacing = buttonsSpacing
        self.buttonsAspectRatio = buttonsAspectRatio
        self.buttonOneView = buttonOneView
        self.buttonOneItem = LayoutItem(view: buttonOneView)
        self.buttonTwoView = buttonTwoView
        self.buttonTwoItem = LayoutItem(view: buttonTwoView)
        self.buttonThreeView = buttonThreeView
        self.buttonThreeItem = LayoutItem(view: buttonThreeView)
        self.buttonFourView = buttonFourView
        self.buttonFourItem = LayoutItem(view: buttonFourView)
        self.buttonFiveView = buttonFiveView
        self.buttonFiveItem = LayoutItem(view: buttonFiveView)
        self.buttonSixView = buttonSixView
        self.buttonSixItem = LayoutItem(view: buttonSixView)
        self.buttonEightView = buttonEightView
        self.buttonEightItem = LayoutItem(view: buttonEightView)
        self.buttonNineView = buttonNineView
        self.buttonNineItem = LayoutItem(view: buttonNineView)
        self.buttonZeroView = buttonZeroView
        self.buttonZeroItem = LayoutItem(view: buttonZeroView)
        self.accessoryLeftView = accessoryLeftView
        if let view = accessoryLeftView {
            self.accessoryLeftItem = LayoutItem(view: view)
        }
        self.accessoryRightView = accessoryRightView
        if let view = accessoryRightView {
            self.accessoryRightItem = LayoutItem(view: view)
        }
    }
    
    public func layout(bounds: RectFloat) -> SizeFloat {
        var origin = bounds.origin.y
        do {
            let item = self.titleItem
            let inset = self.titleInset
            let size = item.size(available: bounds.size.inset(inset))
            item.frame = RectFloat(
                x: bounds.origin.x + inset.left,
                y: origin + inset.top,
                width: bounds.size.width - (inset.left + inset.right),
                height: size.height
            )
            origin += inset.top + size.height + inset.bottom
        }
        do {
            let item = self.pincodeItem
            let inset = self.pincodeInset
            let size = item.size(available: bounds.size.inset(inset))
            item.frame = RectFloat(
                x: bounds.origin.x + inset.left,
                y: origin + inset.top,
                width: bounds.size.width - (inset.left + inset.right),
                height: size.height
            )
            origin += inset.top + size.height + inset.bottom
        }
        if let item = self.errorItem {
            let inset = self.errorInset
            let size = item.size(available: bounds.size.inset(inset))
            item.frame = RectFloat(
                x: bounds.origin.x + inset.left,
                y: origin + inset.top,
                width: bounds.size.width - (inset.left + inset.right),
                height: size.height
            )
            origin += inset.top + size.height + inset.bottom
        }
        do {
            let inset = self.buttonsInset
            let rect = RectFloat(
                x: bounds.origin.x + inset.left,
                y: origin + inset.top,
                width: bounds.size.width - (inset.left + inset.right),
                height: bounds.size.height - origin - (inset.left + inset.right)
            )
            let grid = rect.grid(rows: 4, columns: 3, spacing: self.buttonsSpacing)
            self.buttonOneItem.frame = grid[0]
            self.buttonTwoItem.frame = grid[1]
            self.buttonThreeItem.frame = grid[3]
            self.buttonFourItem.frame = grid[4]
            self.buttonFiveItem.frame = grid[5]
            self.buttonSixItem.frame = grid[6]
            self.buttonEightItem.frame = grid[7]
            self.buttonNineItem.frame = grid[8]
            self.buttonZeroItem.frame = grid[10]
            if let item = self.accessoryLeftItem {
                item.frame = grid[9]
            }
            if let item = self.accessoryRightItem {
                item.frame = grid[11]
            }
        }
        return bounds.size
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        guard available.width > 0 else {
            return .zero
        }
        var result = SizeFloat(
            width: available.width,
            height: 0
        )
        let titleSize = self.titleItem.size(available: available.inset(self.titleInset))
        result.height += self.titleInset.top + titleSize.height + self.titleInset.bottom
        let pincodeSize = self.pincodeItem.size(available: available.inset(self.pincodeInset))
        result.height += self.pincodeInset.top + pincodeSize.height + self.pincodeInset.bottom
        if let errorItem = self.errorItem {
            let errorSize = errorItem.size(available: available.inset(self.errorInset))
            result.height += self.errorInset.top + errorSize.height + self.errorInset.bottom
        }
        let availableButtonsWidth = available.width - (self.buttonsInset.left + self.buttonsInset.right)
        let buttonsWidth = (availableButtonsWidth / 3) - (self.buttonsSpacing.x * 2)
        let buttonsHeight = buttonsWidth * self.buttonsAspectRatio
        result.height += self.buttonsInset.top + (buttonsHeight * 3) + (self.buttonsSpacing.y * 3) + self.buttonsInset.bottom
        return result
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        var items: [LayoutItem] = [
            self.titleItem,
            self.pincodeItem,
        ]
        if let item = self.errorItem {
            items.append(item)
        }
        items.append(contentsOf: [
            self.buttonOneItem,
            self.buttonTwoItem,
            self.buttonThreeItem,
            self.buttonFourItem,
            self.buttonFiveItem,
            self.buttonSixItem,
            self.buttonEightItem,
            self.buttonNineItem,
            self.buttonZeroItem
        ])
        if let item = self.accessoryLeftItem {
            items.append(item)
        }
        if let item = self.accessoryRightItem {
            items.append(item)
        }
        return items
    }
    
}
