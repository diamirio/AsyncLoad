import Testing
@testable import AsyncLoad

@Suite("Test equatable AsyncLoad")
struct AsyncLoadEquatableItemTests {
    @Test func testNone() async throws {
        let load1: AsyncLoad<User> = .none
        let load2: AsyncLoad<User> = .none
        
        #expect(load1 == load2)
    }
    
    @Test func testLoadedString() async throws {
        var load1: AsyncLoad<String> = .loaded("Some")
        var load2: AsyncLoad<String> = .loaded("Some")
        
        #expect(load1 == load2)
        
        load1 = .loaded("Other")
        load2 = .loaded("Other1")
        
        #expect(load1 != load2)
    }
    
    @Test func testLoadedUser() async throws {
        var load1: AsyncLoad<User> = .loaded(User(name: "Some"))
        var load2: AsyncLoad<User> = .loaded(User(name: "Some"))
        
        #expect(load1 == load2)
        
        load1 = .loaded(User(name: "Alex"))
        load2 = .loaded(User(name: "Daniel"))
        
        #expect(load1 != load2)
    }
    
    @Test func testError() async throws {
        var load1: AsyncLoad<User> = .error(TestingError.some)
        var load2: AsyncLoad<User> = .error(TestingError.some)
        
        #expect(load1 == load2)
        
        load1 = .error(TestingError.some)
        load2 = .error(TestingError.other)
        
        #expect(load1 == load2)
    }
    
    @Test func testMultiple() async throws {
        var load1: AsyncLoad<String> = .none
        var load2: AsyncLoad<String> = .none
        
        #expect(load1 == load2)
        
        load1 = .loading
        load2 = .loading
        
        #expect(load1 == load2)
        
        load1 = .loaded("Some")
        load2 = .loaded("Other")
        
        #expect(load1 != load2)
        
        load1 = .loaded("some")
        load2 = .loaded("some")
        
        #expect(load1 == load2)
        
        load1 = .error(TestingError.some)
        load2 = .error(TestingError.some)
        
        #expect(load1 == load2)
    }
}
