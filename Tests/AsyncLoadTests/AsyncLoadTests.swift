import Testing
@testable import AsyncLoad

enum TestingError: Error {
    case some
}

@Test func testAsyncLoadEquatable() async throws {
    var load1: AsyncLoad<String> = .none
    var load2: AsyncLoad<String> = .none
    
    #expect(load1 == load2)
    
    load1 = .loading
    load2 = .loading
    
    #expect(load1 == load2)
    
    load1 = .loaded("some")
    load2 = .loaded("other")
    
    #expect(load1 == load2)
    
    load1 = .error(TestingError.some)
    load2 = .error(TestingError.some)
    
    #expect(load1 == load2)
}


@Test func testCachedAsyncLoadEquatable() async throws {
    var load1: CachedAsyncLoad<String> = .none
    var load2: CachedAsyncLoad<String> = .none
    
    #expect(load1 == load2)
    
    load1 = .loading()
    load2 = .loading()
    
    #expect(load1 == load2)
    
    load1 = .loaded("some")
    load2 = .loaded("other")
    
    #expect(load1 == load2)

    load1 = .loading("some")
    load2 = .loading("other")
    
    #expect(load1 == load2)
    
    load1 = .error("some", TestingError.some)
    load2 = .error(nil, TestingError.some)
    
    #expect(load1 == load2)
}
