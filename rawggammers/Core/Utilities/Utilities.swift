//
//  Utilities.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import Foundation
import UIKit

/// A utility class providing helper functions related to view controllers.
final class Utilities {
    
    /// The shared instance of `Utilities` for accessing its methods.
    static let shared = Utilities()
    
    private init() {}
    
    /// Retrieves the topmost view controller currently presented on the screen.
    ///
    /// This method traverses through the view controller hierarchy to find the topmost view controller, taking into account possible navigation controllers, tab bar controllers, and presented view controllers.
    ///
    /// - Parameter controller: The starting view controller to begin the search. If `nil`, it defaults to the root view controller of the key window.
    /// - Returns: The topmost view controller or `nil` if no view controller is found.
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let keyWindow: UIWindow? = {
            if #available(iOS 15.0, *) {
                return UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .compactMap { $0 as? UIWindowScene }
                    .first?.windows
                    .filter { $0.isKeyWindow }
                    .first
            } else {
                return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            }
        }()
        
        let controller = controller ?? keyWindow?.rootViewController
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
