import Testing
@testable import AsyncLoad

@Suite("Test equatable CachedAsyncLoad")
struct CachedAsyncLoadEquatableItemTests {
    @Test func testNone() async throws {
        let load1: CachedAsyncLoad<User> = .none
        let load2: CachedAsyncLoad<User> = .none
        
        #expect(load1 == load2)
    }
    
    @Test func testLoadedString() async throws {
        var load1: CachedAsyncLoad<String> = .loaded("Some")
        var load2: CachedAsyncLoad<String> = .loaded("Some")
        
        #expect(load1 == load2)
        
        load1 = .loaded("Other")
        load2 = .loaded("Other1")
        
        #expect(load1 != load2)
    }
    
    @Test func testLoadedUser() async throws {
        var load1: CachedAsyncLoad<User> = .loaded(User(name: "Some"))
        var load2: CachedAsyncLoad<User> = .loaded(User(name: "Some"))
        
        #expect(load1 == load2)
        
        load1 = .loaded(User(name: "Alex"))
        load2 = .loaded(User(name: "Daniel"))
        
        #expect(load1 != load2)
    }
    
    @Test func testError() async throws {
        var load1: CachedAsyncLoad<String> = .error("some", TestingError.some)
        var load2: CachedAsyncLoad<String> = .error("some", TestingError.some)
        
        #expect(load1 == load2)
        
        load1 = .error(nil, TestingError.some)
        load2 = .error("some", TestingError.some)
        
        #expect(load1 != load2)
        
        load1 = .error(nil, TestingError.some)
        load2 = .error("some", TestingError.other)
        
        #expect(load1 != load2)
    }
    
    @Test func testMultiple() async throws {
        var load1: CachedAsyncLoad<String> = .none
        var load2: CachedAsyncLoad<String> = .none
        
        #expect(load1 == load2)
        
        load1 = .loading()
        load2 = .loading()
        
        #expect(load1 == load2)
        
        load1 = .loaded("some")
        load2 = .loaded("some")
        
        #expect(load1 == load2)

        load1 = .loading("some")
        load2 = .loading("other")
        
        #expect(load1 != load2)
        
        load1 = .loading()
        load2 = .loading()
        
        #expect(load1 == load2)
        
        load1 = .error("some", TestingError.some)
        load2 = .error(nil, TestingError.some)
        
        #expect(load1 != load2)
    }
}
