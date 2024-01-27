//
//  KindKit
//

struct SequenceRecord : Record {
    
    public let id: Id
    public let records: [any Record]
    
    public init(
        id: Id,
        records: [any Record]
    ) {
        self.id = id
        self.records = records
    }
    
    public func isEquivalent(to record: any Record) -> Bool {
        guard self.id == record.id else { return false }
        guard let record = record as? SequenceRecord else { return false }
        return self.records.elementsEqual(record.records, by: { $0.isEquivalent(to: $1) })
    }
    
    public func record(by id: Id) -> (any Record)? {
        if self.id == id {
            return self
        }
        for record in self.records {
            if let first = record.record(by: id) {
                return first
            }
        }
        return nil
    }
    
    public func value< Cast >(as type: Cast.Type) -> Cast? {
        return nil
    }
    
}
