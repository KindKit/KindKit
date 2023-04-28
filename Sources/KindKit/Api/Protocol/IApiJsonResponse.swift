//
//  KindKit
//

import Foundation

public protocol IApiJsonResponse : IApiDataResponse {
    
    func parse(meta: Api.Response.Meta, json: Json) throws -> Result
    
    func failure(parse: Json.Error.Coding) -> Failure
    
}

public extension IApiJsonResponse {
    
    func parse(meta: Api.Response.Meta, data: Data) throws -> Result {
        do {
            let json = try Json(data: data)
            return try self.parse(meta: meta, json: json)
        } catch let error as Json.Error.Coding {
            return .failure(self.failure(parse: error))
        } catch let error {
            throw error
        }
    }
    
}
