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

    let baseURL = URL(string: "http://172.20.10.3:8080")!

    func fetchGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "NoToken", code: 401)))
            return
        }

        var request = URLRequest(url: baseURL.appendingPathComponent("games"))
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

    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let loginURL = baseURL.appendingPathComponent("login")
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LoginRequest(username: username, password: password)
        request.httpBody = try? JSONEncoder().encode(body)

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
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(decoded.token))
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
