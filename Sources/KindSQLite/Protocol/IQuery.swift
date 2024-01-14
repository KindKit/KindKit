//
//  KindKit
//

import Foundation

public protocol IQuery : IExpressable {
}

public protocol IInsertQuery : IQuery {
}

public protocol IUpdateQuery : IQuery {
}

public protocol ISelectQuery : IQuery {
}
