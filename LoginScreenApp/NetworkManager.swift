import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func loginAdmin(
        url: String,
        apiKey: String,
        hashKey: String,
        mobile: Int64,
        password: String,
        completion: @escaping (Result<RootResponse, Error>) -> Void
    ) {
        guard let finalURL = URL(string: url) else {
            print("❌ Invalid URL string: \(url)")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        let body: [String: Any] = [
            "hashKey": hashKey,
            "mobile": mobile,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("❌ Error encoding request body: \(error)")
            completion(.failure(error))
            return
        }

        print("📤 POST Request URL: \(finalURL.absoluteString)")
        print("🔐 Headers: x-api-key = \(apiKey)")
        print("📨 Body: \(body)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📬 Response Status Code: \(httpResponse.statusCode)")
                print("📫 Response Headers: \(httpResponse.allHeaderFields)")
            }
            
            guard let data = data else {
                print("❗️ No data received from server")
                completion(.failure(NetworkError.noData))
                return
            }
            
            if let rawJSON = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("📦 Raw JSON Response: \(rawJSON)")
            }
            if let rawJSONString = String(data: data, encoding: .utf8) {
                print("Raw JSON String:", rawJSONString)
                let validJSONString = rawJSONString
                
            
            if let validData = validJSONString.data(using: .utf8) {
                do {
                    let response = try JSONDecoder().decode(RootResponse.self, from: validData)
                    let model = response.result
                   // print("✅ Decoded Response: \(model)")
                    completion(.success(response))
                } catch {
                    print("❌ Decoding error: \(error)")
                    completion(.failure(error))
                }
            } else {
                print("❌ Failed to convert preprocessed JSON string to Data")
                completion(.failure(NSError(domain: "Invalid JSON String", code: 0, userInfo: nil)))
            }
        }else {
            print("❌ Failed to convert Data to JSON string")
            completion(.failure(NSError(domain: "Invalid Data", code: 0, userInfo: nil)))
        }
        }.resume()
    }

    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}
