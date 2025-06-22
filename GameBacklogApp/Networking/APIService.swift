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

    let baseURL = URL(string: "http://172.20.10.10:8080")!
    
    struct GameQuery {
        var status: GameStatus? = nil
        var platform: String? = nil
        var minRating: Int? = nil
        var maxRating: Int? = nil
        var search: String? = nil
        var genres: [String] = []
        var sortBy: String = "createdAt"
        var order: String  = "desc"
        var limit:  Int = 10
        var offset: Int = 0
    }

    func fetchGames(query: GameQuery = GameQuery(),
                    completion: @escaping (Result<GameListResponse,Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "NoToken", code: 401))); return
        }

        var comps = URLComponents(url: baseURL.appendingPathComponent("games"), resolvingAgainstBaseURL: false)!
        comps.queryItems = [
            query.status.map { URLQueryItem(name: "status", value: $0.rawValue) },
            query.platform.map { URLQueryItem(name: "platform", value: $0) },
            query.minRating.map { URLQueryItem(name: "minRating", value: String($0)) },
            query.maxRating.map { URLQueryItem(name: "maxRating", value: String($0)) },
            query.search.map    { URLQueryItem(name: "search",    value: $0) },
            query.genres.isEmpty ? nil : URLQueryItem(name: "genre", value: query.genres.joined(separator: ",")),
            URLQueryItem(name: "sortBy", value: query.sortBy),
            URLQueryItem(name: "order",  value: query.order),
            URLQueryItem(name: "limit",  value: String(query.limit)),
            URLQueryItem(name: "offset", value: String(query.offset)),
        ].compactMap { $0 }

        var request = URLRequest(url: comps.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data,_,error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { completion(.failure(NSError(domain:"NoData",code:-1))); return }
            do {
                let decoded = try JSONDecoder().decode(GameListResponse.self, from: data)
                completion(.success(decoded))
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
    
    func register(username: String, password: String, completion: @escaping (Result<String,Error>) -> Void) {

        let url = baseURL.appendingPathComponent("register")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        struct Body: Codable { let username: String; let password: String }
        request.httpBody = try? JSONEncoder().encode(Body(username: username, password: password))

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1))); return
            }
            do {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(decoded.token))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func createGame(_ game: Game, completion: @escaping (Result<Game, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "NoToken", code: 401)))
            return
        }

        var request = URLRequest(url: baseURL.appendingPathComponent("games"))
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        struct CreatePayload: Codable {
            let title: String
            let genres: [String]
            let platform: String
            let coverURL: String?
            let status: GameStatus
            let rating: Int?
            let notes: String?
        }

        let payload = CreatePayload(
            title: game.title,
            genres: game.genres,
            platform: game.platform,
            coverURL: game.coverURL,
            status: game.status,
            rating: game.rating,
            notes: game.notes
        )

        request.httpBody = try? JSONEncoder().encode(payload)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error)); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1))); return
            }
            do {
                let created = try JSONDecoder().decode(Game.self, from: data)
                completion(.success(created))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func updateGame(_ game: Game, completion: @escaping (Result<Game,Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "NoToken", code: 401)))
            return
        }

        var request = URLRequest(
            url: baseURL.appendingPathComponent("games/\(game.id.uuidString)")
        )
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        struct UpdatePayload: Codable {
            let title: String
            let genres: [String]
            let platform: String
            let coverURL: String?
            let status: GameStatus
            let rating: Int?
            let notes: String?
        }

        let payload = UpdatePayload(title: game.title, genres: game.genres, platform: game.platform, coverURL: game.coverURL, status: game.status, rating: game.rating, notes: game.notes)

        request.httpBody = try? JSONEncoder().encode(payload)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1))); return }
            do {
                let updated = try JSONDecoder().decode(Game.self, from: data)
                completion(.success(updated))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func deleteGame(_ id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "NoToken", code: 401)))
            return
        }

        var request = URLRequest(url: baseURL.appendingPathComponent("games/\(id.uuidString)"))
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "DeleteFailed", code: -1)))
            }
        }.resume()
    }
}

struct GameListResponse: Codable {
    let total: Int
    let games: [Game]
}
