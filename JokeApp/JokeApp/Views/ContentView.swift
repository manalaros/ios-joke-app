import SwiftUI

struct ContentView: View {
    @StateObject private var vm = JokeViewModel()
    @State private var shimmerPhase: CGFloat = 0

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Clean background
                    Color(.systemBackground)
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                    // Custom header (prettier app title)
                    VStack(spacing: 6) {
                        Text("Joke Time")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "6A00FF"), Color(hex: "00C2FF")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("Laugh a little — one tap at a time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 18)
                    .padding(.bottom, 6)

                    Spacer()

                    // Joke card (centered & constrained on wide screens)
                    HStack { Spacer(minLength: 0)
                        Group {
                            if vm.isLoading {
                                LoadingView()
                            } else if let joke = vm.joke {
                                JokeCardView(joke: joke)
                            } else {
                                placeholderCard
                            }
                        }
                        .frame(maxWidth: min(720, geometry.size.width * 0.9), maxHeight: 450)
                        Spacer(minLength: 0)
                    }
                    
                    Spacer()
                    
                    // Vibrant gradient button
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        Task { await vm.loadJoke() }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Get a Joke")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
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
                        )
                        .foregroundColor(.white)
                        .shadow(color: Color(hex: "0066FF").opacity(0.28), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal, geometry.size.width > 700 ? 40 : 24)
                    .padding(.bottom, 50)

                    // Error message (inside the main VStack so it's visible below the button)
                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundColor(.red)
                            .padding(.horizontal, geometry.size.width > 700 ? 40 : 24)
                            .padding(.bottom, 20)
                    }
                } // VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } // ZStack
        } // GeometryReader
    } // NavigationView
    .navigationBarHidden(true)
    .navigationViewStyle(StackNavigationViewStyle())
}
    
    
    
    private var placeholderCard: some View {
        VStack(spacing: 24) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "0066FF").opacity(0.10),
                                Color(hex: "6A00FF").opacity(0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                
                Image(systemName: "face.smiling.fill")
                    .font(.system(size: 44, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(hex: "0066FF"),
                                Color(hex: "6A00FF")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 12) {
                Text("Ready to laugh?")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Tap the button below to get\na hilarious joke")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        var a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            a = 255
            r = (int >> 8) * 17
            g = (int >> 4 & 0xF) * 17
            b = (int & 0xF) * 17
        case 6: // RGB (24-bit)
            a = 255
            r = int >> 16
            g = int >> 8 & 0xFF
            b = int & 0xFF
        case 8: // ARGB (32-bit)
            a = int >> 24
            r = int >> 16 & 0xFF
            g = int >> 8 & 0xFF
            b = int & 0xFF
        default:
            a = 255
            r = 0
            g = 0
            b = 0
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
