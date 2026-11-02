# Patterns

## With AsyncReactor (companion skill: `asyncreactor`)

```swift
@Observable
final class ProfileReactor: Reactor {
    enum Action { case load, delete }

    @Observable
    final class State {
        var profile = CachedAsyncLoad<Profile>.none
        var delete = AsyncLoadNoContent.none
    }

    private(set) var state = State()

    func action(_ action: Action) async {
        switch action {
        case .load:
            state.profile = .loading(state.profile.item)
            do {
                state.profile = .loaded(try await api.profile())
            } catch is CancellationError {
                return
            } catch {
                state.profile = .error(state.profile.item, error)
            }
        case .delete:
            state.delete = .loading
            do {
                try await api.deleteProfile()
                state.delete = .loaded
            } catch {
                state.delete = .error(error)
            }
        }
    }
}
```

View:

```swift
CachedAsyncLoadView(reactor.profile) { profile in
    ProfileContent(profile: profile)
} loading: { profile in
    ProfileContent(profile: profile).overlay { ProgressView() }
} error: { profile, error in
    ErrorCallout(error)
}
.task { await reactor.action(.load) }
```

Observe success of a write via its item: `.onChange(of: reactor.delete.item) { … }`.

## Composite screens

For a screen with several requests, keep one `AsyncLoad` per request and combine in the view; do not invent a "screen state" enum that duplicates them.

## Testing

```swift
@Test func loadedExposesItem() {
    let state = AsyncLoad<User>.loaded(User(name: "Ann"))
    #expect(state.item == User(name: "Ann"))
    #expect(state.error == nil)
}

@Test func errorsCompareEqual() {
    #expect(AsyncLoad<User>.error(TestingError.some) == .error(TestingError.other))
}
```

Test the reactor/view model that produces the states: assert `.loading` is set before the call and `.loaded`/`.error` after, using a mock service.
