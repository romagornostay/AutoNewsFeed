//
//  NetworkError.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 23.06.2025.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
  case invalidURL
  case invalidResponse
  case decoding(Error)
  case unknown(Error)
  
  public var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "⛔️ Невалидный URL"
    case .invalidResponse:
      return "⚠️ Некорректный ответ сервера"
    case .decoding(let error):
      return "💥 Ошибка декодирования: \(error.localizedDescription)"
    case .unknown(let error):
      return "❓ Неизвестная ошибка: \(error.localizedDescription)"
    }
  }
}
