import Testing
@testable import AsyncLoad

@Suite("Test equatable AsyncAction")
struct AsyncActionEquatableItemTests {
    @Test func testNone() async throws {
        let action1: AsyncAction<User> = .none
        let action2: AsyncAction<User> = .none

        #expect(action1 == action2)
    }

    @Test func testLoadedString() async throws {
        var action1: AsyncAction<String> = .success("Some")
        var action2: AsyncAction<String> = .success("Some")

        #expect(action1 == action2)

        action1 = .success("Other")
        action2 = .success("Other1")

        #expect(action1 != action2)
    }

    @Test func testLoadedUser() async throws {
        var action1: AsyncAction<User> = .success(User(name: "Some"))
        var action2: AsyncAction<User> = .success(User(name: "Some"))

        #expect(action1 == action2)

        action1 = .success(User(name: "Alex"))
        action2 = .success(User(name: "Daniel"))

        #expect(action1 != action2)
    }

    @Test func testError() async throws {
        var action1: AsyncAction<User> = .error(TestingError.some)
        var action2: AsyncAction<User> = .error(TestingError.some)

        #expect(action1 == action2)

        action1 = .error(TestingError.some)
        action2 = .error(TestingError.other)

        #expect(action1 == action2)
    }

    @Test func testMultiple() async throws {
        var action1: AsyncAction<String> = .none
        var action2: AsyncAction<String> = .none

        #expect(action1 == action2)

        action1 = .loading
        action2 = .loading

        #expect(action1 == action2)

        action1 = .success("Some")
        action2 = .success("Other")

        #expect(action1 != action2)

        action1 = .success("some")
        action2 = .success("some")

        #expect(action1 == action2)

        action1 = .error(TestingError.some)
        action2 = .error(TestingError.some)

        #expect(action1 == action2)
    }
}