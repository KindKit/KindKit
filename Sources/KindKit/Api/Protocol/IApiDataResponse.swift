//
//  KindKit
//

import Foundation

public protocol IApiDataResponse : IApiResponse {
    
    func parse(meta: Api.Response.Meta, data: Data) throws -> Result
    
    func failure(meta: Api.Response.Meta) -> Failure?
    func failure(parse: Api.Error.Parse) -> Failure
    func failure(request: Api.Error.Request) -> Failure
    func failure(network: Api.Error.Network) -> Failure
    func failure(error: Swift.Error) -> Failure
    
}

public extension IApiDataResponse {
    
    func parse(meta: Api.Response.Meta, data: Data?) -> Result {
        if let failure = self.failure(meta: meta) {
            return .failure(failure)
        }
        guard let data = data else {
            return .failure(self.failure(parse: .init(
                statusCode: meta.statusCode)
            ))
        }
        do {
            return try self.parse(meta: meta, data: data)
        } catch {
            return .failure(self.failure(parse: .init(
                statusCode: meta.statusCode,
                response: data
            )))
        }
    }
    
    func parse(error: Error) -> Result {
        if let error = self.hasRequest(error: error) {
            return .failure(self.failure(request: error))
        } else if let error = self.hasNetwork(error: error) {
            return .failure(self.failure(network: error))
        }
        return .failure(self.failure(error: error))
    }
    
}
