//
//  File.swift
//
//
//  Created by Jeffrey Macko on 12/11/2020.
//

//import Foundation
//import MultipeerKit
//import MultipeerConnectivity
//
//extension Peer: Codable {
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        case .userDidTakeScreenshot:
//          try container.encode(true, forKey: .userDidTakeScreenshot)
//        case let .crash(crashContent):
//          try container.encode(crashContent, forKey: .crash)
//    }
//
//    public init(from decoder: Decoder) throws {
//
//    }
//
//    enum CodingKeys: CodingKey {
//        case underlyingPeer
//        case id
//        case name
//        case discoveryInfo
//        case isConnected
//    }
//}
//
//extension MCPeerID: Codable {
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.displayName, forKey: .displayName)
//    }
//
//    public convenience init(from decoder: Decoder) throws {
//      let container = try decoder.container(keyedBy: CodingKeys.self)
//      if let key = container.allKeys.first {
//        switch key {
//        case .displayName:
//            let content = try container.decode(
//                String.self,
//                forKey: .displayName
//            )
//            self.displayName = content
//        }
//      } else {
//        throw DecodingError.dataCorrupted(
//          DecodingError.Context(
//            codingPath: container.codingPath,
//            debugDescription: "Unabled to decode enum."
//          )
//        )
//      }
//    }
//
//    enum CodingKeys: CodingKey {
//        case displayName
//    }
//}
