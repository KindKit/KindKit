//
//  KindKit
//

import Foundation

public extension RemoteImage {

    final class Query : IRemoteImageQuery {
        
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
            provider: Api.Provider,
            queue: DispatchQueue,
            download: @escaping (_ progress: Progress) -> Void,
            success: @escaping (_ data: Data, _ image: UI.Image) -> Void,
            failure: @escaping (_ error: RemoteImage.Error) -> Void
        ) -> ICancellable {
            return provider.send(
                request: Api.Request(method: .get, path: .absolute(self.url)),
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
    
}

private extension RemoteImage.Query {
    
    struct Response : IApiDataResponse {
        
        typealias Success = (Data, UI.Image)
        typealias Failure = RemoteImage.Error
        typealias Result = Swift.Result< Success, Failure >
        
        func parse(meta: Api.Response.Meta, data: Data) throws -> Result {
            guard let image = UI.Image(data: data) else {
                return .failure(.parse(.init(statusCode: meta.statusCode, response: data)))
            }
            return .success((data, image))
        }
        
        func failure(meta: Api.Response.Meta) -> Failure? {
            return nil
        }
        
        func failure(parse: Api.Error.Parse) -> Failure {
            return .parse(parse)
        }
        
        func failure(request: Api.Error.Request) -> Failure {
            return .request(request)
        }
        
        func failure(network: Api.Error.Network) -> Failure {
            return .network(network)
        }
        
        func failure(error: Swift.Error) -> Failure {
            return .unknown
        }
        
    }
    
}
