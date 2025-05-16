import SwiftUI
import Network


struct LoginView: View {
    @State private var mobile: Int64 = 0
    @State private var mobileString: String = ""

       @State private var password: String = ""
       @State private var rememberMe: Bool = false
       @State private var showingAlert = false
    @State private var navigateToNextPage = false
    @State private var gyms:[Gym] = []

       @State private var alertMessage = ""
    var body: some View {
        NavigationStack {
        ZStack
        {
            
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Spacer()
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Mobile", text: $mobileString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Toggle(isOn: $rememberMe) {
                    Text("Remember Me")
                }
                
                Button(action: handleLogin) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            NavigationLink(
                     destination: HomeScreenView(gyms: gyms),
                     isActive: $navigateToNextPage
                 ) {
                     EmptyView()
                 }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Login Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    }
    private func handleLogin() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Network available")
            } else {
                print("No network connection")
            }
        }
       
      //  monitor.start(queue: DispatchQueue.global())
        if let mobileValue = Int64(mobileString) {
            mobile = mobileValue
            // Proceed with API call
        } else {
            alertMessage = "Please enter a valid mobile number"
            showingAlert = true
        }
        NetworkManager.shared.loginAdmin(
            url: "https://sadf.in/getgymlist/",
            apiKey: "safd",
            hashKey: "asdf",
            mobile: Int64(mobile), // assuming email field is used for mobile number input
            password: password
        ) {
            result in
            DispatchQueue.main.async {
                print(result)
                switch result {
                case .success(let model):
                    if (model.success) {
                        print("✅ Gymlisttt: \(model)")
                        if let gymList = model.result {
                                          gyms = gymList // ✅ Store the gym list
                            print("✅ Gymlisttt: \(gyms)")

                                          navigateToNextPage = true
                                      } else {
                                          alertMessage = "⚠️ No gyms found in response."
                                          showingAlert = true
                                      }
                          } else {
                              alertMessage = "❌ Login failed"
                              showingAlert = true
                          }
                case .failure(let error):
                     alertMessage = "🚫 Error: \(error.localizedDescription)"
                    showingAlert = true

                 }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
