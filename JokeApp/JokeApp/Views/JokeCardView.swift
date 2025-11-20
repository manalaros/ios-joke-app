import SwiftUI

struct JokeCardView: View {
    let joke: Joke

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Setup with icon
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "0066FF"))
                    Spacer()
                }

                Text(joke.setup)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Gradient separator
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "0066FF"),
                            Color(hex: "00C2FF"),
                            Color(hex: "6A00FF")
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
                .frame(maxWidth: 60)

            // Punchline
            Text(joke.punchline)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(hex: "0066FF"),
                            Color(hex: "6A00FF")
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
                .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .padding(.horizontal, 24)
        .transition(.scale.combined(with: .opacity))
        .animation(.spring(response: 0.6, dampingFraction: 0.75), value: joke.id)
    }
}

struct JokeCardView_Previews: PreviewProvider {
    static var previews: some View {
        JokeCardView(joke: Joke(id: 1, type: "general", setup: "Setup example", punchline: "Punchline example"))
    }
}
