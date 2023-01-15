//
//  This file is part of the 2FAS iOS app (https://github.com/twofas/2fas-ios)
//  Copyright © 2023 Two Factor Authentication Service, Inc.
//  Contributed by Zbigniew Cisiński. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <https://www.gnu.org/licenses/>
//

import Foundation

public enum Algorithm: String, Equatable, CaseIterable {
    case MD5
    case SHA1
    case SHA224
    case SHA256
    case SHA384
    case SHA512
        
    public static var defaultValue: Self {
        .SHA1
    }
    
    public static func create(_ value: String?) -> Self {
        guard let value, let instance = Algorithm(rawValue: value.uppercased()) else {
            return defaultValue
        }
        return instance
    }
    
    public static func verifyIfPresent(_ value: String?) -> Bool {
        guard let value else { return true }
        guard Algorithm(rawValue: value.uppercased()) != nil else { return false }
        return true
    }
}
