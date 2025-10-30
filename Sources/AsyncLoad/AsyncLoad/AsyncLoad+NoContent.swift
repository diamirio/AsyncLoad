import Foundation

public typealias AsyncLoadNoContent = AsyncLoad<NoContent>

public struct NoContent: Equatable, Sendable {
    public init() { }
}

public extension AsyncLoad where T == NoContent {
    init(_ type: AsyncLoad = .none) {
        self = type
    }
    
    static var loaded: AsyncLoad<NoContent> {
        .loaded(NoContent())
    }
}
