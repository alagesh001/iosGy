struct RootResponse: Decodable {
    let success: Bool
    let result: [Gym]?
}

struct Gym: Identifiable, Decodable {
    let id: Int
    let gymName: String
    let location: String
    
    let memberCount: Int
 

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case gymName = "GymName"
        case location = "Location"
        case memberCount = "membercount"
  
    }
}

struct Client: Identifiable, Codable {
    var id: Int { userid } // Using `Int` for `userid` since it's numeric
    let name: String
    let mobile: Int64 // Adjusted to `String` to handle leading zeros
    let renewal_date: String?
    let email: String?
    let userid: Int // `userid` is numeric in the JSON
    let referral_id: String?
    let dob: String?
    let height: String?
    let weight: String?
    let goal: Int? // `goal` is numeric in the JSON
    let coachid: Int? // `coachid` can be null or numeric
    let gender: String?
    let referred_by: String?
    let due_amount: Int? // `due_amount` is numeric
    let attendance_count: Int? // `attendance_count` is numeric
    let last_attend: String?
}
