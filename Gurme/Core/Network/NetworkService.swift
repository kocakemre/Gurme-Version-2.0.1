//
//  NetworkService.swift
//  Gurme
//
//  Created by Emre Kocak on 13.07.2024.
//

import Foundation

// MARK: - HTTPMethod
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - NetworkError
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Geçersiz URL."
        case .noData:
            "Sunucudan veri alınamadı."
        case .decodingFailed(let error):
            "Veri çözümlenirken hata: \(error.localizedDescription)"
        case .serverError(let code):
            "Sunucu hatası: \(code)"
        }
    }
}

// MARK: - NetworkService
final class NetworkService {
    static let shared = NetworkService()

    private let session: URLSession
    private let baseURL: String

    private enum Constant {
        static let baseURL = "http://kasimadalan.pe.hu/yemekler"
        static let requestTimeout: TimeInterval = 30
        static let formURLEncoded = "application/x-www-form-urlencoded"
        static let contentTypeHeader = "Content-Type"
        static let minSuccessCode = 200
        static let maxSuccessCode = 299
    }

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Constant.requestTimeout
        session = URLSession(configuration: configuration)
        baseURL = Constant.baseURL
    }

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil
    ) async throws -> T {
        let urlString = "\(baseURL)/\(endpoint)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let parameters, method == .post {
            let bodyString = parameters
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
            request.httpBody = bodyString.data(using: .utf8)
            request.setValue(
                Constant.formURLEncoded,
                forHTTPHeaderField: Constant.contentTypeHeader
            )
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }

        let successRange = Constant.minSuccessCode...Constant.maxSuccessCode
        guard successRange.contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
