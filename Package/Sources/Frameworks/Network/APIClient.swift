//
//  APIClient.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import Foundation

protocol APIClient {
  func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class DefaultAPIClient: APIClient {
  func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
    guard let url = endpoint.url else {
      throw NetworkError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
      throw NetworkError.invalidResponse
    }
    
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw NetworkError.decoding(error)
    }
  }
}
