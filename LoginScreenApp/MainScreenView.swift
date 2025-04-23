struct MainScreenView: View {
    let gym: Gym
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to \(gym.gymName)")
                .font(.largeTitle)
                .padding()
            Text("Location: \(gym.location)")
            Text("Members: \(gym.memberCount)")
            Spacer()
        }
        .navigationTitle(gym.gymName)
        .padding()
    }
}
