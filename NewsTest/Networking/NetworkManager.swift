import Foundation
import Reachability

class NetworkManager: NSObject {
    
    var reachability: Reachability!
    
    // Create a singleton instance
    static let instance: NetworkManager = { return NetworkManager() }()
    
    
    override init() {
        super.init()
        
        reachability = Reachability()!
    
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if self.reachability.connection != .none {
            //Client.instance.getDataFromServer()
        }
    }
    
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkManager.instance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.instance.reachability).connection != .none {
            completed(NetworkManager.instance)
        }
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.instance.reachability).connection == .none {
            completed(NetworkManager.instance)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.instance.reachability).connection == .cellular {
            completed(NetworkManager.instance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.instance.reachability).connection == .wifi {
            completed(NetworkManager.instance)
        }
    }
}
