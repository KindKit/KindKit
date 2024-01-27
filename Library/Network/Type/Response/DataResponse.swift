//
//  KindKit
//

import Foundation

public protocol DataResponse : Response {
    
    func parse(meta: MetaResponse, data: Data) throws -> Result
    
    func failure(meta: MetaResponse) -> Failure?
    func failure(parse: ParseError) -> Failure
    func failure(request: RequestError) -> Failure
    func failure(network: NetworkError) -> Failure
    func failure(error: Swift.Error) -> Failure
    
}

public extension DataResponse {
    
    func parse(meta: MetaResponse, data: Data?) -> Result {
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
    
    func parse(error: Swift.Error) -> Result {
        if let error = self.hasRequest(error: error) {
            return .failure(self.failure(request: error))
        } else if let error = self.hasNetwork(error: error) {
            return .failure(self.failure(network: error))
        }
        return .failure(self.failure(error: error))
    }
    
}
