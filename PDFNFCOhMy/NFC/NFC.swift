//
//  NFC.swift
//  PDFNFCOhMy
//
//  Created by Andrii Maliarchuk on 29.1.21.
//

import Foundation
import CoreNFC

enum NFCError: LocalizedError {
    case unavailable
    case invalidated(message: String)
    case invalidPayloadSize
    
    var errorDescription: String? {
        switch self {
        case .unavailable:
            return "NFC Reader Not Available"
        case let .invalidated(message):
            return message
        case .invalidPayloadSize:
            return "NDEF payload size exceeds the tag limit"
        }
    }
}

class NFCUtility: NSObject {
    
    static let shared = NFCUtility()
    
    private var session: NFCNDEFReaderSession?
    private var completion: ((Result<Void, NFCError>) -> Void)?
    private var url: URL?
    
    func sendURL(_ url: URL, completion: @escaping (Result<Void, NFCError>) -> Void) {
        guard NFCNDEFReaderSession.readingAvailable else {
            completion(.failure(.unavailable))
            print("NFC is not available on this device")
            return
        }
        self.url = url
        self.completion = completion
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Place tag near iPhone to pass the data"
        session?.begin()
    }
    
    private func writeURL(to tag: NFCNDEFTag) {
        guard let urlPayload = url.flatMap(NFCNDEFPayload.wellKnownTypeURIPayload) else {
            handleError(NFCError.invalidated(message: "Could not create payload"))
            return
        }
        // check url payload type and value
        let message = NFCNDEFMessage(records: [urlPayload])
        tag.writeNDEF(message) { [weak self] error in
            if let error = error {
                self?.handleError(error)
                return
            }
            self?.session?.alertMessage = "Wrote location data."
            self?.session?.invalidate()
            self?.completion?(.success(()))
        }
    }
}

// MARK: - NFC NDEF Reader Session Delegate
extension NFCUtility: NFCNDEFReaderSessionDelegate {
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print(#function)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print(messages)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first, tags.count == 1 else {
            session.alertMessage = "There are too many tags present. Remove all and then try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)) {
                session.restartPolling()
            }
            return
        }
        session.connect(to: tag) { error in
            if let error = error {
                self.handleError(error)
                return
            }
            tag.queryNDEFStatus { status, _, error in
                if let error = error {
                    self.handleError(error)
                    return
                }
                switch status {
                case .notSupported:
                    session.alertMessage = "Unsupported tag."
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "Unable to write to tag."
                    session.invalidate()
                case .readWrite:
                    self.writeURL(to: tag)
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let error = error as? NFCReaderError, ![.readerSessionInvalidationErrorFirstNDEFTagRead, .readerSessionInvalidationErrorUserCanceled].contains(error.code) {
            completion?(.failure(NFCError.invalidated(message: error.localizedDescription)))
        }
        self.session = nil
        completion = nil
    }
    
    private func handleError(_ error: Error) {
        session?.alertMessage = error.localizedDescription
        session?.invalidate()
    }
}
