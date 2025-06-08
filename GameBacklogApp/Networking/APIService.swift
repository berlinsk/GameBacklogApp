//
//  APIService.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 08.06.2025.
//

import Foundation

class APIService {
    static let shared = APIService()
    private init() {}

    let baseURL = URL(string: "http://172.20.10.3")!
    let token = "TED4Mm2kpDXJljpC3ZgIuw=="

    func fetchGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent("games"), resolvingAgainstBaseURL: false)!
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(GameListResponse.self, from: data)
                completion(.success(decoded.games))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct GameListResponse: Codable {
    let total: Int
    let games: [Game]
}
