import Testing
@testable import AsyncLoad

@Suite("Test equatable CachedAsyncLoad")
struct CachedAsyncLoadEquatableItemTests {
    @Test<[CachedAsyncLoadParameter<String>]>("Should be equal <String>", arguments: [
        .init(.none, .none),
        .init(.loading(), .loading()),
        .init(.loaded("some"), .loaded("some")),
        .init(.loading("some"), .loading("some")),
        .init(.error("some", TestingError.some), .error("some", TestingError.some)),
    ])
    func equalString(param: CachedAsyncLoadParameter<String>) async throws {
        #expect(param.load1 == param.load2)
    }

    @Test<[CachedAsyncLoadParameter<String>]>("Should not be equal <String>", arguments: [
        .init(.loaded("Other"), .loaded("Other1")),
        .init(.loading("some"), .loading("other")),
        .init(.error(nil, TestingError.some), .error("some", TestingError.some)),
        .init(.error(nil, TestingError.some), .error("some", TestingError.other)),
        .init(.error("some", TestingError.some), .error(nil, TestingError.some)),
    ])
    func nonEqualString(param: CachedAsyncLoadParameter<String>) async throws {
        #expect(param.load1 != param.load2)
    }

    @Test<[CachedAsyncLoadParameter<User>]>("Should be equal <User>", arguments: [
        .init(.none, .none),
        .init(.loading(), .loading()),
        .init(.loaded(User(name: "some")), .loaded(User(name: "some"))),
        .init(.loading(User(name: "some")), .loading(User(name: "some"))),
        .init(.error(User(name: "some"), TestingError.some), .error(User(name: "some"), TestingError.some)),
    ])
    func equalUser(param: CachedAsyncLoadParameter<User>) async throws {
        #expect(param.load1 == param.load2)
    }

    @Test<[CachedAsyncLoadParameter<User>]>("Should not be equal <User>", arguments: [
        .init(.loaded(User(name: "Alex")), .loaded(User(name: "Daniel"))),
        .init(.loading(User(name: "Alex")), .loading(User(name: "Daniel"))),
        .init(.error(nil, TestingError.some), .error(User(name: "some"), TestingError.some)),
        .init(.error(User(name: "Alex"), TestingError.some), .error(User(name: "Daniel"), TestingError.some)),
    ])
    func nonEqualUser(param: CachedAsyncLoadParameter<User>) async throws {
        #expect(param.load1 != param.load2)
    }
}
