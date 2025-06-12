import Foundation

public enum AsyncAction<T>: Equatable {
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
}
