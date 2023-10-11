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

import WidgetKit
import SwiftUI
import Intents

extension CodeEntry {
    static func placeholder(with serviceCount: Int) -> CodeEntry {
        let data: [Entry] = (0..<serviceCount).map { _ in Entry(kind: .placeholder, data: EntryData.createSnapshot()) }
        return .init(date: Date(), entries: data)
    }
    
    static func snapshot(with serviceCount: Int) -> CodeEntry {
        let data: [Entry] = (0..<serviceCount).map { _ in Entry(kind: .singleEntry, data: EntryData.createSnapshot()) }
        return .init(date: Date(), entries: data)
    }
}

extension CodeEntry.Entry {
    static func placeholder() -> Self {
        .init(kind: .placeholder, data: CodeEntry.EntryData.createSnapshot())
    }
}

extension CodeEntry.EntryData {
    static func createSnapshot() -> Self {
        // swiftlint:disable discouraged_object_literal
        let theID = UUID().uuidString
        return .init(
            id: theID,
            name: "2FAS",
            info: "My secured account",
            code: "127 924",
            icon: #imageLiteral(resourceName: "TwoFASMainService"),
            iconType: .brand,
            labelTitle: "2F",
            labelColor: .red,
            serviceTypeID: UUID(),
            countdownTo: nil
        )
    }
}

// -

extension UIImage {
    static func icon(from file: INFile?) -> UIImage {
        if let data = file?.data, let image = UIImage(data: data) {
            return image
        }
        // swiftlint:disable discouraged_object_literal
        return #imageLiteral(resourceName: "TwoFASMainService")
    }
}

extension WidgetFamily {
    var servicesCount: Int {
        switch self {
        case .systemSmall: return 1
        case .systemMedium: return 3
        case .systemLarge: return 6
        case .systemExtraLarge: return 12
        default: return 1
        }
    }
}
