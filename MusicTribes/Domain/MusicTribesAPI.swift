//
//  MusicTribesAPI.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 22/5/24.
//

import Foundation
import Combine

enum MTEndpoint {
    case getCollectorSongsEndpoint(String)

    var relativeURL: String {
        switch self {
        case .getCollectorSongsEndpoint(let collector):
            return "api/collector?collectorId=\(collector)"
        }
    }
}

final class MusicTribesAPI {
    private var cancellables = Set<AnyCancellable>()
    let baseUrl = "https://api.webbed3.org/"
    let mtApiKey = "0b1b7080-0fe9-4b1e-b2d8-5879c46f9d03"

    func artistsFromUser(user: String) -> AnyPublisher<[CollectedArtist], Error> {
        return Future<[CollectedArtist], Error> { promise in
            promise(.success(MockData.collectedArtists)
            )
        }.eraseToAnyPublisher()
    }

    func fetchSongsForCollector(_ collector: String) -> Future<[Song], Error> {
        return Future { promise in
            let urlPath = self.baseUrl + MTEndpoint.getCollectorSongsEndpoint(collector).relativeURL
            print(urlPath)
            guard let url = URL(string: urlPath) else {
                print("[MusicTribesAPI] Invalid URL")
                promise(.failure(URLError(.badURL)))
                return
            }
            var request = URLRequest(url: url)
            request.addValue(self.mtApiKey, forHTTPHeaderField: "x-api-key")
  //          let session = URLSession(configuration: .default, delegate: CustomSessionDelegate(), delegateQueue: nil)
//            session.dataTaskPublisher(for: url)
            URLSession.shared.dataTaskPublisher(for: request)
                .map { data, response -> Data in
                    // Print the raw response and response type
                    print("[DEBUG] Raw Response: \(response)")

                    // Print the raw data as a string
                    if let rawString = String(data: data, encoding: .utf8) {
                        print("[DEBUG] Raw Data String: \(rawString)")
                    }

                    return data
                }
                .decode(type: [Song].self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        // If decoding fails, print more detailed error information
                        if let decodingError = error as? DecodingError {
                            switch decodingError {
                            case .dataCorrupted(let context):
                                print("[DEBUG] Data Corrupted: \(context)")
                            case .keyNotFound(let key, let context):
                                print("[DEBUG] Key Not Found: \(key), Context: \(context)")
                            case .typeMismatch(let type, let context):
                                print("[DEBUG] Type Mismatch: \(type), Context: \(context)")
                            case .valueNotFound(let type, let context):
                                print("[DEBUG] Value Not Found: \(type), Context: \(context)")
                            @unknown default:
                                print("[DEBUG] Unknown Decoding Error")
                            }
                        }
                        print("[MusicPlayerManager] Failed to load songs: \(error.localizedDescription)")
                        promise(.failure(error))
                        return
                    case .finished:
                        print("[MusicPlayerManager] Successfully loaded songs.")
                    }
                }, receiveValue: { [weak self] songs in
                    promise(.success(songs))
                })
                .store(in: &self.cancellables)
        }
    }
}

import Foundation

class CustomSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
