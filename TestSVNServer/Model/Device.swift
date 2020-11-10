//
//  Device.swift
//  TCA Debugger
//
//  Created by Jeffrey Macko on 04/11/2020.
//

import SwiftUI
import ServerTCADebugger

struct Device : Equatable, Identifiable {
    enum Model : String, Hashable {
        typealias RawValue = String
        
        case iPhone
        case iPad
        case iPod
        case mac
        case watch
        case tv
        case unknow
        
        var systemImage : String {
            switch self {
            case .iPhone:
                return "iphone"
            case .iPad:
                return "ipad"
            case .iPod:
                return "ipodtouch"
            case .mac:
                return "desktopcomputer"
            case .watch:
                return "applewatch"
            case .tv:
                return "appletv"
            case .unknow:
                return "display"
            }
        }
    }
    var id : String { get { client.peer.id } }
    let client: SVNServerTransceiver.Client
}
