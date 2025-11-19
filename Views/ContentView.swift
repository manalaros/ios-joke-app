import SwiftUI

struct ContentView: View {
    @StateObject private var vm = JokeViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Group {
                    if vm.isLoading {
                        ProgressView()
                            .scaleEffect(1.2)
                    } else if let joke = vm.joke {
                        VStack(spacing: 12) {
                            Text(joke.setup)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .transition(.opacity)

                            Text(joke.punchline)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.accentColor)
                                .transition(.scale)
                                .animation(.spring(), value: vm.joke?.id)
                        }
                        .padding()
                    } else {
                        Text("Tap 'Hit me!' to start laughing")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Button(action: {
                    Task { await vm.loadJoke() }
                }) {
                    Text("Hit me!")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 8)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Joke Time")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
