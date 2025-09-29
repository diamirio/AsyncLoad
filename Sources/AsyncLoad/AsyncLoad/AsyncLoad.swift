import Foundation

public enum AsyncLoad<T>: Equatable {
    case none
    case loading
    case error(Error)
    case loaded(T)

    public var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    public var item: T? {
        switch self {
        case let .loaded(item):
            item
        default:
            nil
        }
    }

    public var error: Error? {
        switch self {
        case let .error(error):
            error
        default:
            nil
        }
    }
    
    public static func == (lhs: AsyncLoad<T>, rhs: AsyncLoad<T>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            true
        case (.loading, .loading):
            true
        case (.error, .error):
            true
        case (.loaded, .loaded):
            true
        default:
            false
        }
    }
    
    public static func == (lhs: AsyncLoad<T>, rhs: AsyncLoad<T>) -> Bool where T : Equatable {
        switch (lhs, rhs) {
        case (.none, .none):
            true
        case (.loading, .loading):
            true
        case (.error, .error):
            true
        case let (.loaded(lhsItem), .loaded(rhsItem)):
            lhsItem == rhsItem
        default:
            false
        }
    }
    
    public static func != (lhs: AsyncLoad<T>, rhs: AsyncLoad<T>) -> Bool where T : Equatable {
        switch (lhs, rhs) {
        case (.none, .none):
            false
        case (.loading, .loading):
            false
        case (.error, .error):
            false
        case let (.loaded(rhsItem), .loaded(lhsItem)):
            lhsItem != rhsItem
        default:
            true
        }
    }
}
