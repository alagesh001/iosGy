import SwiftUI
import Combine

class ClientListViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchAllClients(gymid: Int) {
        isLoading = true
        errorMessage = nil
        clients = [] // Clear the list before fetching

        // Start fetching from page 1
        fetchPage(gymid: gymid, page: 1)
    }

    private func fetchPage(gymid: Int, page: Int) {
        var components = URLComponents(string: "https://sdfx.in/getmemberdata.php")
        components?.queryItems = [
            URLQueryItem(name: "gymid", value: "\(gymid)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let url = components?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("sdfa", forHTTPHeaderField: "X-API-KEY")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    self.isLoading = false
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received."
                    self.isLoading = false
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(ClientResponse.self, from: data)
                    if decoded.success {
                        self.clients.append(contentsOf: decoded.result) // Append new clients
                        print("Fetched page \(page) with \(decoded.result.count) clients.")

                        // Check if there are more pages to fetch
                        if let currentPage = decoded.current_page, let totalPages = decoded.total_pages, currentPage < totalPages {
                            self.fetchPage(gymid: gymid, page: currentPage + 1) // Fetch next page
                        } else {
                            self.isLoading = false
                            print("Finished fetching all pages.")
                        }
                    } else {
                        self.errorMessage = decoded.message ?? "Unknown error."
                        self.isLoading = false
                    }
                } catch {
                    self.errorMessage = "Parsing error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }.resume()
    }
}


struct ClientResponse: Codable {
    let success: Bool
    let total_records: Int?
    let total_pages: Int?
    let current_page: Int?
    let limit: Int?
    let message: String?
    let result: [Client]
}
