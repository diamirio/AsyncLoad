import Testing
@testable import AsyncLoad

@Suite("Test equatable AsyncLoad")
struct AsyncLoadEquatableItemTests {
    @Test<[AsyncLoadParameter<String>]>("Should be equal <String>", arguments: [
        .init(.none, .none),
        .init(.loading, .loading),
        .init(.error(TestingError.some), .error(TestingError.some)),
        .init(.error(TestingError.some), .error(TestingError.other)),
        .init(.loaded("some"), .loaded("some")),
    ])
    func equalString(param: AsyncLoadParameter<String>) async throws {
        #expect(param.load1 == param.load2)
    }

    @Test<[AsyncLoadParameter<String>]>("Should not be equal <String>", arguments: [
        .init(.loaded("Some"), .loaded("Other")),
        .init(.error(TestingError.some), .loaded("some")),
    ])
    func nonEqualString(param: AsyncLoadParameter<String>) async throws {
        #expect(param.load1 != param.load2)
    }

    @Test<[AsyncLoadParameter<User>]>("Should be equal <User>", arguments: [
        .init(.none, .none),
        .init(.loading, .loading),
        .init(.error(TestingError.some), .error(TestingError.some)),
        .init(.error(TestingError.some), .error(TestingError.other)),
        .init(.loaded(User(name: "some")), .loaded(User(name: "some"))),
    ])
    func equalUser(param: AsyncLoadParameter<User>) async throws {
        #expect(param.load1 == param.load2)
    }

    @Test<[AsyncLoadParameter<User>]>("Should not be equal <User>", arguments: [
        .init(.loaded(User(name: "Alex")), .loaded(User(name: "Daniel"))),
        .init(.error(TestingError.some), .loaded(User(name: "some"))),
    ])
    func nonEqualUser(param: AsyncLoadParameter<User>) async throws {
        #expect(param.load1 != param.load2)
    }
}
