//
//  KindKitRemoteImageView
//

import Foundation
import KindKitCore
import KindKitView

public protocol IRemoteImageView : IView, IViewColorable, IViewBorderable, IViewCornerRadiusable, IViewShadowable, IViewAlphable {
    
    var isLoading: Bool { get }
    var placeholderView: IImageView { set get }
    var imageView: IImageView? { get }
    var progressView: IProgressView? { set get }
    var errorView: IView? { set get }
    var loader: RemoteImage.Loader { get }
    var query: IRemoteImageQuery { set get }
    var filter: IRemoteImageFilter? { set get }
    
    @discardableResult
    func startLoading() -> Self
    
    @discardableResult
    func stopLoading() -> Self
    
    @discardableResult
    func onProgress(_ value: ((_ progress: Float) -> Void)?) -> Self
    
    @discardableResult
    func onFinish(_ value: ((_ image: Image) -> IImageView)?) -> Self
    
    @discardableResult
    func onError(_ value: ((_ error: Error) -> Void)?) -> Self

}

public extension IRemoteImageView {
    
    @inlinable
    @discardableResult
    func placeholderView(_ value: IImageView) -> Self {
        self.placeholderView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func progressView(_ value: IProgressView?) -> Self {
        self.progressView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func errorView(_ value: IView?) -> Self {
        self.errorView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func query(_ value: IRemoteImageQuery) -> Self {
        self.query = value
        return self
    }
    
    @inlinable
    @discardableResult
    func filter(_ value: IRemoteImageFilter?) -> Self {
        self.filter = value
        return self
    }
    
}
