import Foundation

public enum CachedAsyncAction<T: Equatable & Sendable>: Equatable, Sendable {
    case none
    case loading(T? = nil)
    case error(T? = nil, Error)
    case success(T)

    public var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    public var item: T? {
        switch self {
        case let .success(item):
            item
        default:
            nil
        }
    }

    public var error: Error? {
        switch self {
        case let .error(_, error):
            error
        default:
            nil
        }
    }
    
    public static func == (lhs: CachedAsyncAction<T>, rhs: CachedAsyncAction<T>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            true
        case let (.loading(lhsItem), .loading(rhsItem)):
            lhsItem == rhsItem
        case let (.error(lhsItem, _), .error(rhsItem, _)):
            lhsItem == rhsItem
        case let (.success(lhsItem), .success(rhsItem)):
            lhsItem == rhsItem
        default:
            false
        }
    }
}
