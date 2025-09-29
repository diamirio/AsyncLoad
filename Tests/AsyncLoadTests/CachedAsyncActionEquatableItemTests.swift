import Testing
@testable import AsyncLoad

@Suite("Test equatable CachedAsyncAction")
struct CachedAsyncActionEquatableItemTests {
    @Test func testNone() async throws {
        let action1: CachedAsyncAction<User> = .none
        let action2: CachedAsyncAction<User> = .none

        #expect(action1 == action2)
    }

    @Test func testLoadedString() async throws {
        var action1: CachedAsyncAction<String> = .success("Some")
        var action2: CachedAsyncAction<String> = .success("Some")

        #expect(action1 == action2)

        action1 = .success("Other")
        action2 = .success("Other1")

        #expect(action1 != action2)
    }

    @Test func testLoadedUser() async throws {
        var action1: CachedAsyncAction<User> = .success(User(name: "Some"))
        var action2: CachedAsyncAction<User> = .success(User(name: "Some"))

        #expect(action1 == action2)

        action1 = .success(User(name: "Alex"))
        action2 = .success(User(name: "Daniel"))

        #expect(action1 != action2)
    }

    @Test func testError() async throws {
        var action1: CachedAsyncAction<String> = .error("some", TestingError.some)
        var action2: CachedAsyncAction<String> = .error("some", TestingError.some)

        #expect(action1 == action2)

        action1 = .error(nil, TestingError.some)
        action2 = .error("some", TestingError.some)

        #expect(action1 != action2)

        action1 = .error(nil, TestingError.some)
        action2 = .error("some", TestingError.other)

        #expect(action1 != action2)
    }

    @Test func testMultiple() async throws {
        var action1: CachedAsyncAction<String> = .none
        var action2: CachedAsyncAction<String> = .none

        #expect(action1 == action2)

        action1 = .loading()
        action2 = .loading()

        #expect(action1 == action2)

        action1 = .success("some")
        action2 = .success("some")

        #expect(action1 == action2)

        action1 = .loading("some")
        action2 = .loading("other")

        #expect(action1 != action2)

        action1 = .loading()
        action2 = .loading()

        #expect(action1 == action2)

        action1 = .error("some", TestingError.some)
        action2 = .error(nil, TestingError.some)

        #expect(action1 != action2)
    }
}
