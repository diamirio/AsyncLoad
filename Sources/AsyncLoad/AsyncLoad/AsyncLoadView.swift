import Foundation
#if canImport(SwiftUI)
import SwiftUI

public struct AsyncLoadView<
    Item: Equatable & Sendable,
    Content: View,
    ErrorContent: View
>: View {
    let state: AsyncLoad<Item>

    @ViewBuilder
    let content: (Item) -> Content

    @ViewBuilder
    let errorContent: (Error) -> ErrorContent

    public init(
        _ state: AsyncLoad<Item>,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder error: @escaping (Error) -> ErrorContent
    ) {
        self.state = state
        self.content = content
        errorContent = error
    }

    public init(
        _ state: AsyncLoad<Item>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) where ErrorContent == Text {
        self.state = state
        self.content = content

        errorContent = { error in
            Text(error.localizedDescription)
        }
    }

    public var body: some View {
        ZStack {
            if let item = state.item {
                content(item)
                    .opacity(state.item != nil ? 1 : 0)
            }

            switch state {
            case .loading, .none:
                ProgressView()
                    .frame(maxHeight: .infinity)
                    .controlSize(.large)
            case .loaded:
                EmptyView()
            case let .error(error):
                errorContent(error)
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
#Preview {
    @State
    @Previewable
    var state: AsyncLoad<String> = .loading
    
    AsyncLoadView(state) { test in
        Text(test)
    }
}

#endif
