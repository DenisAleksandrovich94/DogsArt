import Foundation

class DogAPIClient {
    
    private let baseURL = URL(string: "https://dog.ceo/api")!
    
    func fetchAllBreeds(
        completion: @escaping (Result<[String: [String]], APIError>) -> Void
    ) {
        let url = baseURL.appendingPathComponent("breeds/list/all")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let breedsListResponse = try decoder.decode(BreedsListResponse.self, from: data)
                completion(.success(breedsListResponse.message))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        .resume()
    }
    
    func fetchBreedImages(
        breed: String,
        completion: @escaping (Result<[String], APIError>) -> Void
    ) {
        let url = baseURL.appendingPathComponent("breed/\(breed)/images")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let breedImagesResponse = try decoder.decode(BreedImagesResponse.self, from: data)
                completion(.success(breedImagesResponse.message))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
