import Foundation

public enum CachedAsyncLoad<T>: Equatable {
    case none
    case loading(T? = nil)
    case error(T? = nil, Error)
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
        case let .error(_, error):
            error
        default:
            nil
        }
    }
    
    public static func == (lhs: CachedAsyncLoad<T>, rhs: CachedAsyncLoad<T>) -> Bool {
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
    
    public static func == (lhs: CachedAsyncLoad<T>, rhs: CachedAsyncLoad<T>) -> Bool where T : Equatable {
        switch (lhs, rhs) {
        case (.none, .none):
            true
        case (.loading, .loading):
            lhs.item == rhs.item
        case (.error, .error):
            true
        case (.loaded, .loaded):
            lhs.item == rhs.item
        default:
            false
        }
    }
}
