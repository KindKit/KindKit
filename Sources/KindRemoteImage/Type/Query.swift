//
//  KindKit
//

import KindGraphics
import KindNetwork

public final class Query : IQuery {
    
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
    
    public func local() throws -> Data {
        return try Data(contentsOf: self.url)
    }
    
    public func remote(
        provider: KindNetwork.Provider,
        queue: DispatchQueue,
        download: @escaping (_ progress: Progress) -> Void,
        success: @escaping (_ data: Data, _ image: Image) -> Void,
        failure: @escaping (_ error: Error) -> Void
    ) -> ICancellable {
        return provider.send(
            request: KindNetwork.Request(method: .get, path: .absolute(self.url)),
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

private extension Query {
    
    struct Response : KindNetwork.IDataResponse {
        
        typealias Success = (Data, Image)
        typealias Failure = Error
        typealias Result = Swift.Result< Success, Failure >
        
        func parse(meta: KindNetwork.Response.Meta, data: Data) throws -> Result {
            guard let image = Image(data: data) else {
                return .failure(.parse(.init(statusCode: meta.statusCode, response: data)))
            }
            return .success((data, image))
        }
        
        func failure(meta: KindNetwork.Response.Meta) -> Failure? {
            return nil
        }
        
        func failure(parse: KindNetwork.Error.Parse) -> Failure {
            return .parse(parse)
        }
        
        func failure(request: KindNetwork.Error.Request) -> Failure {
            return .request(request)
        }
        
        func failure(network: KindNetwork.Error.Network) -> Failure {
            return .network(network)
        }
        
        func failure(error: Swift.Error) -> Failure {
            return .unknown
        }
        
    }
    
}
