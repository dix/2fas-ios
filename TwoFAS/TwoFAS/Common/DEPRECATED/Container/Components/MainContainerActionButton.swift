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

import UIKit
import Common

final class MainContainerActionButton: UIButton {
    private var fixedHeight: CGFloat?
    var action: Callback?
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setTitle(_ title: String, style: Style<UIButton>) {
        setTitle(title, for: .normal)
        apply(style)
    }
    
    func setHeight(_ height: CGFloat) {
        fixedHeight = height
    }
    
    private func commonInit() {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        pointerStyleProvider = { button, effect, _ in
            let targetedPreview = UITargetedPreview(view: button)
            let effect: UIPointerEffect = .highlight(targetedPreview)
   
            return UIPointerStyle(effect: effect)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var fw = super.intrinsicContentSize.width + 2 * Theme.Metrics.standardMargin
        var fh = fixedHeight ?? super.intrinsicContentSize.height
        let minWidth: CGFloat = 3 * Theme.Metrics.doubleMargin
        let minHeight: CGFloat = 2 * Theme.Metrics.doubleMargin
        if fw < minWidth {
            fw = minWidth
        }
        if fh < minHeight {
            fh = minHeight
        }
        
        return CGSize(width: fw, height: fh)
    }
    
    @objc
    private func buttonTapped() {
        action?()
    }
}
