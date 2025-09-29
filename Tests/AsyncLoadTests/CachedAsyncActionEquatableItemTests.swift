import Testing
@testable import AsyncLoad

@Suite("Test equatable CachedAsyncAction")
struct CachedAsyncActionEquatableItemTests {
    @Test<[CachedAsyncActionParameter<String>]>("Should be equal <String>", arguments: [
        .init(.none, .none),
        .init(.loading(), .loading()),
        .init(.success("some"), .success("some")),
        .init(.loading("some"), .loading("some")),
        .init(.error("some", TestingError.some), .error("some", TestingError.some)),
    ])
    func equalString(param: CachedAsyncActionParameter<String>) async throws {
        #expect(param.action1 == param.action2)
    }

    @Test<[CachedAsyncActionParameter<String>]>("Should not be equal <String>", arguments: [
        .init(.success("Other"), .success("Other1")),
        .init(.loading("some"), .loading("other")),
        .init(.error(nil, TestingError.some), .error("some", TestingError.some)),
        .init(.error(nil, TestingError.some), .error("some", TestingError.other)),
        .init(.error("some", TestingError.some), .error(nil, TestingError.some)),
    ])
    func nonEqualString(param: CachedAsyncActionParameter<String>) async throws {
        #expect(param.action1 != param.action2)
    }

    @Test<[CachedAsyncActionParameter<User>]>("Should be equal <User>", arguments: [
        .init(.none, .none),
        .init(.loading(), .loading()),
        .init(.success(User(name: "some")), .success(User(name: "some"))),
        .init(.loading(User(name: "some")), .loading(User(name: "some"))),
        .init(.error(User(name: "some"), TestingError.some), .error(User(name: "some"), TestingError.some)),
    ])
    func equalUser(param: CachedAsyncActionParameter<User>) async throws {
        #expect(param.action1 == param.action2)
    }

    @Test<[CachedAsyncActionParameter<User>]>("Should not be equal <User>", arguments: [
        .init(.success(User(name: "Alex")), .success(User(name: "Daniel"))),
        .init(.loading(User(name: "Alex")), .loading(User(name: "Daniel"))),
        .init(.error(nil, TestingError.some), .error(User(name: "some"), TestingError.some)),
        .init(.error(User(name: "Alex"), TestingError.some), .error(User(name: "Daniel"), TestingError.some)),
    ])
    func nonEqualUser(param: CachedAsyncActionParameter<User>) async throws {
        #expect(param.action1 != param.action2)
    }
}
