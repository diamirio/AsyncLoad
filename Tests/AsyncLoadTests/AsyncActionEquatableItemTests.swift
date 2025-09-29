import Testing
@testable import AsyncLoad

@Suite("Test equatable AsyncAction")
struct AsyncActionEquatableItemTests {
    @Test<[AsyncActionParameter<String>]>("Should be equal <String>", arguments: [
        .init(.none, .none),
        .init(.loading, .loading),
        .init(.error(TestingError.some), .error(TestingError.some)),
        .init(.error(TestingError.some), .error(TestingError.other)),
        .init(.success("some"), .success("some")),
    ])
    func equalString(param: AsyncActionParameter<String>) async throws {
        #expect(param.action1 == param.action2)
    }
    
    @Test<[AsyncActionParameter<String>]>("Should not be equal <String>", arguments: [
        .init(.success("some"), .success("other")),
        .init(.error(TestingError.some), .success("other")),
    ])
    func nonEqualString(param: AsyncActionParameter<String>) async throws {
        #expect(param.action1 != param.action2)
    }
    
    @Test<[AsyncActionParameter<User>]>("Should be equal <User>", arguments: [
        .init(.none, .none),
        .init(.loading, .loading),
        .init(.error(TestingError.some), .error(TestingError.some)),
        .init(.error(TestingError.some), .error(TestingError.other)),
        .init(.success(User(name: "some")), .success(User(name: "some"))),
    ])
    func equalUser(param: AsyncActionParameter<User>) async throws {
        #expect(param.action1 == param.action2)
    }
    
    @Test<[AsyncActionParameter<User>]>("Should not be equal <User>", arguments: [
        .init(.success(User(name: "some")), .success(User(name: "other"))),
        .init(.error(TestingError.some), .success(User(name: "some"))),
    ])
    func nonEqualuser(param: AsyncActionParameter<User>) async throws {
        #expect(param.action1 != param.action2)
    }
}
