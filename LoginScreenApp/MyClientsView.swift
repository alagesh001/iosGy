import SwiftUI

struct MyClientsView: View {
    
    @StateObject private var viewModel = ClientListViewModel()
    @State private var searchText: String = ""

    var filteredClients: [Client] {
        if searchText.isEmpty {
            return viewModel.clients
        } else {
            return viewModel.clients.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(filteredClients) { client in
                        VStack(alignment: .leading) {
                            Text(client.name)
                                .font(.headline)
                            
                            Text("Mobile: \(String(client.mobile))")
                                .font(.subheadline)
                            if let renewalDate = client.renewal_date {
                                Text("Renewal: \(renewalDate)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Client List")
            .searchable(text: $searchText, prompt: "Search Clients")
            .onAppear {
                viewModel.fetchAllClients(gymid: 86966844) // Your gym ID
            }
        }
    }
}

