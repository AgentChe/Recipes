//
//  ReaderTableElement.swift
//  Recipes
//
//  Created by Андрей Чернышев on 13.10.2022.
//

import CoreGraphics
import Foundation

enum ReaderTableElement {
    case offset(CGFloat)
    case title(String)
    case text(String)
    case image(URL)
    case lastStepTitle(String)
    case lastStepText
}
