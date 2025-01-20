//
//  SongDownloadManager.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 25/10/24.
//

import Foundation

final class SongDownloadManager {
    static let shared = SongDownloadManager()

    func downloadSong(from url: URL, completion: @escaping (URL?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { location, response, error in
            guard let location = location, error == nil else {
                completion(nil)
                return
            }

            // Move the downloaded file to a local directory
            let destinationURL = self.localFilePath(for: url)
            try? FileManager.default.moveItem(at: location, to: destinationURL)
            completion(destinationURL)
        }
        task.resume()
    }

    func localFilePath(for url: URL) -> URL {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(url.lastPathComponent)
    }
}
