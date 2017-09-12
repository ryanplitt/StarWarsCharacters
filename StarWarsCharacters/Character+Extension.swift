//
//  Character+Extension.swift
//  StarWarsCharacters
//
//  Created by Ryan Plitt on 9/12/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import Foundation

extension Character {
    
    enum Affiliation: String {
        case resistance = "RESISTANCE"
        case jedi = "JEDI"
        case firstOrder = "FIRST_ORDER"
        case sith = "SITH"
        case unknown = "unknown"
    }
    
    var affiliation: Affiliation {
        return Affiliation(rawValue: affiliationString ?? "") ?? .unknown
    }
    
}
