import SwiftUI

struct ContentView: View {
    @StateObject private var vm = JokeViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // Clear background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Joke card
                    Group {
                        if vm.isLoading {
                            loadingCard
                        } else if let joke = vm.joke {
                            jokeCard(joke: joke)
                        } else {
                            placeholderCard
                        }
                    }
                    .frame(maxHeight: 400)
                    
                    Spacer()
                    
                    Button(action: {
                        Task { await vm.loadJoke() }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Get a Joke")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.blue)
                        )
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    
                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundColor(.red.opacity(0.8))
                            .padding(.horizontal, 24)
                            .padding(.bottom, 16)
                    }
                }
            }
            .navigationTitle("Jokes")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func jokeCard(joke: Joke) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Setup
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 14))
                        .foregroundColor(.blue.opacity(0.6))
                    Spacer()
                }
                
                Text(joke.setup)
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Separador sutil
            Rectangle()
                .fill(Color.blue.opacity(0.2))
                .frame(height: 1)
                .frame(maxWidth: 40)
            
            // Punchline
            Text(joke.punchline)
                .font(.system(size: 19, weight: .regular, design: .rounded))
                .foregroundColor(.blue)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)
                .shadow(color: Color.blue.opacity(0.08), radius: 1, x: 0, y: 0)
        )
        .padding(.horizontal, 24)
        .transition(.scale.combined(with: .opacity))
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: vm.joke?.id)
    }
    
    private var loadingCard: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.1)
                .tint(.blue)
            
            Text("Fetching a joke...")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)
        )
        .padding(.horizontal, 24)
    }
    
    private var placeholderCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "face.smiling")
                .font(.system(size: 48))
                .foregroundColor(.blue.opacity(0.3))
            
            Text("Ready to laugh?")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
            
            Text("Tap the button below to get a joke")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 8)
        )
        .padding(.horizontal, 24)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
