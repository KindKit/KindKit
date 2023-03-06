//
//  KindKit
//

import Foundation

public protocol IDatabaseQuery : IDatabaseExpressable {
}

public protocol IDatabaseInsertQuery : IDatabaseQuery {
}

public protocol IDatabaseUpdateQuery : IDatabaseQuery {
}

public protocol IDatabaseSelectQuery : IDatabaseQuery {
}
