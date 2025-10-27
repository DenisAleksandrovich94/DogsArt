import Foundation

struct BreedsListResponse: Codable {
    let message: [String: [String]]
    let status: String
}
