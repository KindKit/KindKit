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
    var loader: RemoteImageLoader { get }
    var query: IRemoteImageQuery { set get }
    var filter: IRemoteImageFilter? { set get }
    
    @discardableResult
    func startLoading() -> Self
    
    @discardableResult
    func stopLoading() -> Self
    
    @discardableResult
    func placeholderView(_ value: IImageView) -> Self
    
    @discardableResult
    func progressView(_ value: IProgressView?) -> Self
    
    @discardableResult
    func errorView(_ value: IView?) -> Self
    
    @discardableResult
    func query(_ value: IRemoteImageQuery) -> Self
    
    @discardableResult
    func filter(_ value: IRemoteImageFilter?) -> Self
    
    @discardableResult
    func onProgress(_ value: ((_ progress: Float) -> Void)?) -> Self
    
    @discardableResult
    func onFinish(_ value: ((_ image: Image) -> IImageView)?) -> Self
    
    @discardableResult
    func onError(_ value: ((_ error: Error) -> Void)?) -> Self

}
