import SwiftUI

struct ChatInputBarView: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let action: () -> Void
    private let characterLimit = 200

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            TextField("Ask me anything...", text: $text, axis: .vertical)
                .focused(isFocused)
                .lineLimit(1...5)
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
                .onChange(of: text) {
                    if text.count > characterLimit {
                        text = String(text.prefix(characterLimit))
                    }
                }

            Button(action: action) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.largeTitle)
                    .symbolRenderingMode(.multicolor)
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(8)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
