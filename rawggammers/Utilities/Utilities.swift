//
//  Utilities.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import Foundation
import UIKit

final class Utilities {
    static let shared = Utilities()
    private init() {}
    
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
