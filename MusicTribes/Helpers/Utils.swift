//
//  Utils.swift
//  MusicTribes
//
//  Created by Federico Lagarmilla on 19/6/24.
//

import SwiftUI

struct UtilDimensions {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}

struct Utils {
    static func checkiOS18Support() -> Bool {
        if #available(iOS 18, *) {
            return true
        }
        return false
    }

    // store in shared container so that live activity can access
    static func downloadAndCacheImage(from urlString: String, to fileName: String = "live_activity_image.png") async -> String? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string.")
            return nil
        }

        do {
            // Fetch image data asynchronously
            let (data, _) = try await URLSession.shared.data(from: url)

            // Get the shared container directory for the App Group
            guard let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.flagarmilla.MusicTribes") else {
                print("Failed to access shared container.")
                return nil
            }
            // Save the image to the shared container
            let fileURL = sharedContainerURL.appendingPathComponent(fileName)
            /*
            // Save image to temporary directory
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent(fileName)
*/
            try data.write(to: fileURL)
            print(fileURL.path)

            return fileURL.path
        } catch {
            print("Error downloading or saving image: \(error.localizedDescription)")
            return nil
        }
    }

    static func downloadImageData(from urlString: String?) async -> Data? {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("Invalid URL string.")
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data // Return the image data directly
        } catch {
            print("Error downloading image data: \(error.localizedDescription)")
            return nil
        }
    }

    static func downloadAndCompressImageData(from urlString: String?, maxWidth: CGFloat = 50) async -> Data? {
        // Helper function to resize the image
        func resizeImage(image: UIImage, maxWidth: CGFloat) -> UIImage {
            let aspectRatio = image.size.height / image.size.width
            let targetSize = CGSize(width: maxWidth, height: maxWidth * aspectRatio)

            UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return resizedImage ?? image
        }

        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("Invalid URL string.")
            return nil
        }

        do {
            // Fetch the image data asynchronously
            let (data, _) = try await URLSession.shared.data(from: url)

            // Create a UIImage from the original data
            guard let image = UIImage(data: data) else {
                print("Failed to create image from data.")
                return nil
            }

            // Resize the image
            let resizedImage = resizeImage(image: image, maxWidth: maxWidth)

            // Compress the resized image to JPEG format with reduced quality
            let compressedData = resizedImage.jpegData(compressionQuality: 0.3) // Adjust quality as needed
            return compressedData
        } catch {
            print("Error downloading or processing image data: \(error.localizedDescription)")
            return nil
        }
    }
}

struct SecurityManager {
    static func saveAPIKey(_ apiKey: String) {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.yourapp.service",
            kSecAttrAccount as String: "apiKey",
            kSecValueData as String: apiKey.data(using: .utf8)!
        ]

        SecItemDelete(keychainQuery as CFDictionary) // Remove any existing item
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)

        if status == errSecSuccess {
            print("[Keychain] API Key saved successfully.")
        } else {
            print("[Keychain] Failed to save API Key: \(status)")
        }
    }

    func getAPIKey() -> String {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.yourapp.service",
            kSecAttrAccount as String: "apiKey",
            kSecReturnData as String: true
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            if let data = dataTypeRef as? Data, let apiKey = String(data: data, encoding: .utf8) {
                return apiKey
            }
        }

        print("[Keychain] Failed to retrieve API Key: \(status)")
        return ""
    }
}
