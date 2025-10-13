import Foundation
@testable import AsyncLoad

enum TestingError: Error {
    case some
    case other
}

final class NonEquatableItem: Sendable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct User: Equatable {
    let name: String
}

struct AsyncActionParameter<T: Equatable & Sendable> {
    let action1: AsyncAction<T>
    let action2: AsyncAction<T>
    
    init(_ action1: AsyncAction<T>, _ action2: AsyncAction<T>) {
        self.action1 = action1
        self.action2 = action2
    }
}

struct AsyncLoadParameter<T: Equatable & Sendable> {
    let load1: AsyncLoad<T>
    let load2: AsyncLoad<T>

    init(_ load1: AsyncLoad<T>, _ load2: AsyncLoad<T>) {
        self.load1 = load1
        self.load2 = load2
    }
}

struct CachedAsyncActionParameter<T: Equatable & Sendable> {
    let action1: CachedAsyncAction<T>
    let action2: CachedAsyncAction<T>

    init(_ action1: CachedAsyncAction<T>, _ action2: CachedAsyncAction<T>) {
        self.action1 = action1
        self.action2 = action2
    }
}

struct CachedAsyncLoadParameter<T: Equatable & Sendable> {
    let load1: CachedAsyncLoad<T>
    let load2: CachedAsyncLoad<T>
    
    init(_ load1: CachedAsyncLoad<T>, _ load2: CachedAsyncLoad<T>) {
        self.load1 = load1
        self.load2 = load2
    }
}
