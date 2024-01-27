//
//  KindKit
//

public protocol Record {
    
    var id: Id { get }
    
    func isEquivalent(to record: any Record) -> Bool
    
    func record(by id: Id) -> (any Record)?
    
    func value< Cast >(as type: Cast.Type) -> Cast?
    
}

public extension Record {
    
    func record(by path: Path) -> (any Record)? {
        guard path.isNotEmpty else { return nil }
        var record: any Record = self
        for id in path.ids {
            guard let next = record.record(by: id) else {
                return nil
            }
            record = next
        }
        return record
    }
    
    func value< Cast >(by id: Id, as type: Cast.Type) -> Cast? {
        guard let record = self.record(by: id) else { return nil }
        return record.value(as: type)
    }
    
    func value< Cast >(by path: Path, as type: Cast.Type) -> Cast? {
        guard let record = self.record(by: path) else { return nil }
        return record.value(as: type)
    }
    
}
