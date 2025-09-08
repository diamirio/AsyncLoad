import Foundation
#if canImport(SwiftUI)
import SwiftUI

public struct CachedAsyncLoadView<
    Item,
    Content: View,
    ErrorContent: View,
    LoadingContent: View
>: View {
    private let state: CachedAsyncLoad<Item>

    @ViewBuilder
    private let content: (Item) -> Content

    @ViewBuilder
    private let loadingContent: (Item?) -> LoadingContent

    @ViewBuilder
    private let errorContent: (Item?, Error) -> ErrorContent

    public init(
        _ state: CachedAsyncLoad<Item>,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder loading: @escaping (Item?) -> LoadingContent,
        @ViewBuilder error: @escaping (Item?, Error) -> ErrorContent
    ) {
        self.state = state
        self.content = content
        self.loadingContent = loading
        self.errorContent = error
    }

    public var body: some View {
        switch state {
        case .none:
            loadingContent(nil)

        case let .loading(item):
            loadingContent(item)

        case let .loaded(item):
            content(item)

        case let .error(item, error):
            errorContent(item, error)
        }
    }
}
#endif

fileprivate enum CustomError: Error {
    case test
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
#Preview {
    @State
    @Previewable
    var state: CachedAsyncLoad<String> = .none

    CachedAsyncLoadView(state) { item in
        Text(item)
    } loading: { item in
        VStack {
            if let item {
                Text(item)
            }
            
            ProgressView()
                .frame(maxWidth: .infinity)
        }
        .padding()
    } error: { item, error in
        VStack {
            if let item {
                Text(item)
            }
            
            Text(error.localizedDescription)
                .foregroundStyle(.red)
        }
        .padding()
    }
    .animation(.spring, value: state)
    .transition(.opacity)
    .onAppear() {
        Task {
            while(true) {
                try await Task.sleep(for: .seconds(0.5))
                state = .loading()
                try await Task.sleep(for: .seconds(2))
                state = .loaded("Working!")
                try await Task.sleep(for: .seconds(2))
                state = .loading("Working!")
                try await Task.sleep(for: .seconds(2))
                state = .error("Working!", CustomError.test)
            }
        }
    }
}
