//
//  UIApplication+Extension.swift
//  Recipes
//
//  Created by Андрей Чернышев on 27.10.2022.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
