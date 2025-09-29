import Foundation

public enum AsyncAction<T>: Equatable {
    case none
    case loading
    case error(Error)
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
        case let .error(error):
            error
        default:
            nil
        }
    }
    
    public static func == (lhs: AsyncAction<T>, rhs: AsyncAction<T>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            true
        case (.loading, .loading):
            true
        case (.error, .error):
            true
        case (.success, .success):
            true
        default:
            false
        }
    }
    
    public static func == (lhs: AsyncAction<T>, rhs: AsyncAction<T>) -> Bool where T : Equatable {
        switch (lhs, rhs) {
        case (.none, .none):
            true
        case (.loading, .loading):
            true
        case (.error, .error):
            true
        case (.success, .success):
            lhs.item == rhs.item
        default:
            false
        }
    }
    
    public static func != (lhs: AsyncAction<T>, rhs: AsyncAction<T>) -> Bool where T : Equatable {
        switch (lhs, rhs) {
        case (.none, .none):
            true
        case (.loading, .loading):
            true
        case (.error, .error):
            true
        case let (.success(lhsItem), .success(rhsItem)):
            lhsItem != rhsItem
        default:
            false
        }
    }
}
