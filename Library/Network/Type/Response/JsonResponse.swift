//
//  KindKit
//

import Foundation
import KindJSON

public protocol JsonResponse : DataResponse {
    
    func parse(meta: MetaResponse, json: KindJSON.Document) throws -> Result
    
    func failure(parse: KindJSON.AccessError) -> Failure
    
    func failure(parse: KindJSON.CodingError) -> Failure
    
}

public extension JsonResponse {
    
    func parse(meta: MetaResponse, data: Data) throws -> Result {
        do {
            let json = try KindJSON.Document(data: data)
            return try self.parse(meta: meta, json: json)
        } catch let error as KindJSON.AccessError {
            return .failure(self.failure(parse: error))
        } catch let error as KindJSON.CodingError {
            return .failure(self.failure(parse: error))
        } catch let error {
            throw error
        }
    }
    
}
