import SwiftUI


struct HomeScreenView: View {
    let gyms: [Gym]
    
    var body: some View {
        NavigationView {
            List(gyms) { gym in
                NavigationLink(destination: MainScreenView(gym: gym)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(gym.gymName)
                            .font(.headline)
                        Text("Location: \(gym.location)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Members: \(gym.memberCount)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Gyms")
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView(gyms: [
            Gym(id: 1, gymName: "Gold's Gym", location: "Downtown", memberCount: 150),
            Gym(id: 2, gymName: "FitZone", location: "Uptown", memberCount: 120)
        ])
    }
}
