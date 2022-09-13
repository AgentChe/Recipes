//
//  TextSize.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 15.07.2022.
//

import CoreGraphics

struct TextSize: Codable, Hashable {
    let percent: Int
    
    var fontSize: CGFloat {
        switch percent {
        case 80:
            return 14.scale
        case 90:
            return 15.scale
        case 100:
            return 16.scale
        case 110:
            return 17.scale
        case 120:
            return 18.scale
        default:
            return 16.scale
        }
    }
    
    var lineHeight: CGFloat {
        switch percent {
        case 80:
            return 22.4.scale
        case 90:
            return 24.scale
        case 100:
            return 25.6.scale
        case 110:
            return 27.2.scale
        case 120:
            return 28.8.scale
        default:
            return 25.6.scale
        }
    }
}
