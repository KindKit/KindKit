//
//  KindKit
//

import Foundation
import KindGraphics
import KindNetwork

public final class Query {
    
    public let url: URL
    public let key: String
    public var isLocal: Bool {
        return self.url.isFileURL
    }
    
    public init(url: URL) {
        self.url = url
        if let key = url.absoluteString.kk_sha256 {
            self.key = key
        } else {
            self.key = url.lastPathComponent
        }
    }
    
    func local() throws -> Data {
        return try .init(contentsOf: self.url)
    }
    
    func remote(
        provider: KindNetwork.Provider,
        queue: DispatchQueue,
        download: @escaping @Sendable (Progress) -> Void,
        success: @escaping @Sendable (Data, Image) -> Void,
        failure: @escaping @Sendable (Error) -> Void
    ) -> CancelTrait {
        return provider.send(
            request: Request(
                method: .get,
                path: .absolute(self.url)
            ),
            response: Response(),
            queue: queue,
            download: download,
            completed: { response in
                switch response {
                case .success(let result): success(result.0, result.1)
                case .failure(let error): failure(error)
                }
            }
        )
    }
    
}

extension Query : @unchecked Sendable {
}

fileprivate extension Query {
    
    struct Response : DataResponse {
        
        typealias Success = (Data, Image)
        typealias Failure = Error
        typealias Result = Swift.Result< Success, Failure >
        
        func parse(meta: MetaResponse, data: Data) throws -> Result {
            guard let image = Image(data: data) else {
                return .failure(.parse(.init(statusCode: meta.statusCode, response: data)))
            }
            return .success((data, image))
        }
        
        func failure(meta: MetaResponse) -> Failure? {
            return nil
        }
        
        func failure(parse: ParseError) -> Failure {
            return .parse(parse)
        }
        
        func failure(request: RequestError) -> Failure {
            return .request(request)
        }
        
        func failure(network: NetworkError) -> Failure {
            return .network(network)
        }
        
        func failure(error: Swift.Error) -> Failure {
            return .unknown
        }
        
    }
    
}
