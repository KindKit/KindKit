//
//  KindKit
//

import KindJSON

public protocol IJsonResponse : IDataResponse {
    
    func parse(meta: Response.Meta, json: KindJSON.Document) throws -> Result
    
    func failure(parse: KindJSON.Error.Coding) -> Failure
    
}

public extension IJsonResponse {
    
    func parse(meta: Response.Meta, data: Data) throws -> Result {
        do {
            let json = try KindJSON.Document(data: data)
            return try self.parse(meta: meta, json: json)
        } catch let error as KindJSON.Error.Coding {
            return .failure(self.failure(parse: error))
        } catch let error {
            throw error
        }
    }
    
}
