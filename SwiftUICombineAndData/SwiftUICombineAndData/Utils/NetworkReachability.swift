//
//  NetworkReachability.swift
//  SwiftUICombineAndData
//
//  Created by Stanly Shiyanovskiy on 25.08.2022.
//

import Foundation
import SystemConfiguration

final class NetworkReachability: ObservableObject {
    
    @Published var reachable: Bool = false
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    
    init() {
        reachable = checkConnection()
    }
    
    func checkConnection() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        return isNetworkReachable(with: flags)
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let connectionRequired = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutIntervention = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!connectionRequired || canConnectWithoutIntervention)
    }
}
