//
//  KindKit
//

public struct Position {
    
    public let holder: IHolder
    public let owner: IOwner
    public let index: Int
    
}

public extension Position {
    
    func appear(_ item : any IItem) {
        self.holder.insert(item, at: self.index)
    }

    func disappear(_ item : any IItem) {
        self.holder.remove(item)
        self.owner.remove(item)
    }

}

extension Position : Equatable {
    
    public static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.holder === rhs.holder && lhs.owner === rhs.owner && lhs.index == rhs.index
    }
    
}
