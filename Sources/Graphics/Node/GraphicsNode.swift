//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath

public final class GraphicsNode {
    
    public unowned var owner: IGraphicsNodeOwner? {
        didSet(oldValue) {
            guard self.owner !== oldValue else { return }
            self._didUpdate(owner: self.owner)
        }
    }
    public var parent: GraphicsNode? {
        didSet(oldValue) {
            guard self.parent !== oldValue else { return }
            self.needUpdateAbsoluteMatrix()
        }
    }
    public private(set) var childs: [GraphicsNode]
    public unowned var content: IGraphicsNodeContent? {
        didSet(oldValue) {
            guard self.content !== oldValue else { return }
            self.owner?.setNeedRedraw()
        }
    }
    public var transform: GraphicsTransform {
        didSet(oldValue) {
            guard self.transform != oldValue else { return }
            self._relativeMatrix = nil
            self._relativeInverseMatrix = nil
            self.needUpdateAbsoluteMatrix()
            self.owner?.setNeedRedraw()
        }
    }
    public var alpha: Float {
        didSet(oldValue) {
            guard self.alpha != oldValue else { return }
            self.needUpdateAbsoluteAlpha()
            self.owner?.setNeedRedraw()
        }
    }
    public var hidden: Bool {
        didSet(oldValue) {
            guard self.hidden != oldValue else { return }
            self.owner?.setNeedRedraw()
        }
    }
    
    private var _absoluteMatrix: Matrix3Float?
    private var _absoluteInverseMatrix: Matrix3Float?
    private var _relativeMatrix: Matrix3Float?
    private var _relativeInverseMatrix: Matrix3Float?
    private var _absoluteAlpha: Float?
    
    public init(
        owner: IGraphicsNodeOwner? = nil,
        content: IGraphicsNodeContent? = nil,
        transform: GraphicsTransform = GraphicsTransform(),
        alpha: Float = 1,
        hidden: Bool = false
    ) {
        self.owner = owner
        self.childs = []
        self.content = content
        self.transform = transform
        self.alpha = alpha
        self.hidden = hidden
    }
    
    deinit {
        self._didUpdate(owner: nil)
    }
    
}

public extension GraphicsNode {
    
    enum Move {
        case front
        case back
        case before(_ node: GraphicsNode)
        case after(_ node: GraphicsNode)
    }
    
}

public extension GraphicsNode {
    
    var absoluteMatrix: Matrix3Float {
        guard let parent = self.parent else {
            return self.relativeMatrix
        }
        if self._absoluteMatrix == nil {
            self._absoluteMatrix = parent.absoluteMatrix
        }
        return self._absoluteMatrix! * self.relativeMatrix
    }
    
    var absoluteInverseMatrix: Matrix3Float {
        if self._absoluteInverseMatrix == nil {
            self._absoluteInverseMatrix = self.absoluteMatrix.inverse
        }
        return self._absoluteInverseMatrix!
    }
    
    var relativeMatrix: Matrix3Float {
        if self._relativeMatrix == nil {
            self._relativeMatrix = self.transform.matrix
        }
        return self._relativeMatrix!
    }
    
    var relativeInverseMatrix: Matrix3Float {
        if self._relativeInverseMatrix == nil {
            self._relativeInverseMatrix = self.relativeMatrix.inverse
        }
        return self._relativeInverseMatrix!
    }
    
    var absoluteAlpha: Float {
        guard let parent = self.parent else {
            return self.alpha
        }
        if self._absoluteAlpha == nil {
            self._absoluteAlpha = parent.absoluteAlpha
        }
        return self._absoluteAlpha! * self.alpha
    }
    
}

public extension GraphicsNode {
    
    func needUpdateAbsoluteMatrix() {
        self._absoluteMatrix = nil
        self._absoluteInverseMatrix = nil
        for node in self.childs {
            node.needUpdateAbsoluteMatrix()
        }
    }
    
    func needUpdateAbsoluteAlpha() {
        self._absoluteAlpha = nil
        for node in self.childs {
            node.needUpdateAbsoluteAlpha()
        }
    }
    
    func move(node: GraphicsNode, to: Move) {
        guard let nodeIndex = self.childs.firstIndex(where: { $0 === node }) else {
            return
        }
        self.childs.remove(at: nodeIndex)
        let newIndex: Int
        switch to {
        case .front:
            newIndex = self.childs.startIndex
        case .back:
            newIndex = self.childs.endIndex
        case .before(let anchor):
            if let anchorIndex = self.childs.firstIndex(where: { $0 === anchor }) {
                newIndex = anchorIndex
            } else {
                newIndex = self.childs.startIndex
            }
        case .after(let anchor):
            if let anchorIndex = self.childs.firstIndex(where: { $0 === anchor }) {
                newIndex = min(anchorIndex + 1, self.childs.endIndex)
            } else {
                newIndex = self.childs.endIndex
            }
        }
        self.childs.insert(node, at: newIndex)
    }
    
    func insert(node: GraphicsNode) {
        guard self.childs.contains(where: { $0 === node }) == false else { return }
        self.childs.append(node)
        node.parent = self
        if node.owner == nil {
            node.owner = self.owner
        }
    }
    
    func remove(node: GraphicsNode) {
        guard let index = self.childs.firstIndex(where: { $0 === node }) else { return }
        self.childs.remove(at: index)
        node.parent = nil
        if node.owner === self {
            node.owner = nil
        }
    }
    
    func removeFromParent() {
        guard let parent = self.parent else { return }
        parent.remove(node: self)
    }
    
    func hitTest(at location: PointFloat) -> GraphicsNode? {
        guard self.hidden == false else { return nil }
        if self.content?.hitTest(self, global: location, local: location * self.absoluteInverseMatrix) == true {
            return self
        }
        for node in self.childs.reversed() {
            if let hit = node.hitTest(at: location) {
                return hit
            }
        }
        return nil
    }
    
    func draw(_ context: GraphicsContext, _ bounds: RectFloat) {
        guard self.hidden == false else { return }
        context.apply(
            matrix: self.relativeMatrix,
            alpha: self.absoluteAlpha,
            block: {
                self.content?.preDraw(self, context: context, bounds: bounds)
                for node in self.childs {
                    node.draw(context, bounds)
                }
                self.content?.postDraw(self, context: context, bounds: bounds)
            }
        )
    }
    
}

private extension GraphicsNode {
    
    @inline(__always)
    func _didUpdate(owner: IGraphicsNodeOwner?) {
        for child in self.childs {
            child.owner = owner
        }
    }
    
}
