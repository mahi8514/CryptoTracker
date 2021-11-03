//
//  BGDownloadManager.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 01/11/2021.
//

import Foundation

protocol BackgroundFetchDelegate: AnyObject {
    func didFetchCryptoData(bitcoinResponse: BitcoinResponse)
}

class BGDownloadManager: NSObject {
    
    static var shared = BGDownloadManager()
    
    private var urlSession: URLSession?
    private var downloadRequest: URLSessionDownloadTask?
    
    weak var delegate: BackgroundFetchDelegate?
    
    private override init() {
        super.init()
        let config = URLSessionConfiguration.background(withIdentifier: Constants.Identifiers.backgroundURLSessionId)
        config.sessionSendsLaunchEvents = true
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    func fetch() {
        guard let url = URL(string: Constants.Network.baseUrl + Constants.Network.currentPricePath), let urlSession = urlSession else { return }
        downloadRequest = urlSession.downloadTask(with: url)
        downloadRequest?.resume()
    }
}

extension BGDownloadManager: URLSessionDownloadDelegate, URLSessionDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let dataFromURL = try Data(contentsOf: location)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let bitcoinResponse = try jsonDecoder.decode(BitcoinResponse.self, from: dataFromURL)
            delegate?.didFetchCryptoData(bitcoinResponse: bitcoinResponse)
        } catch {
            print("error in data - \(error.localizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error?.localizedDescription ?? "No error produced")
    }
}
