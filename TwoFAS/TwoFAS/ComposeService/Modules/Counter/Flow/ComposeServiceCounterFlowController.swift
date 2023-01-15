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

protocol ComposeServiceCounterFlowControllerParent: AnyObject {
    func didChangeCounter(_ counter: Int)
}

protocol ComposeServiceCounterFlowControlling: AnyObject {
    func toChangeCounter(_ counter: Int)
}

final class ComposeServiceCounterFlowController: FlowController {
    private weak var parent: ComposeServiceCounterFlowControllerParent?
    
    static func push(
        on navigationController: UINavigationController,
        parent: ComposeServiceCounterFlowControllerParent,
        currentValue: Int?
    ) {
        let view = ComposeServiceCounterViewController()
        let flowController = ComposeServiceCounterFlowController(viewController: view)
        flowController.parent = parent
        let presenter = ComposeServiceCounterPresenter(
            flowController: flowController,
            currentValue: currentValue
        )
        presenter.view = view
        view.presenter = presenter
        
        navigationController.pushViewController(view, animated: true)
    }
}

extension ComposeServiceCounterFlowController: ComposeServiceCounterFlowControlling {
    func toChangeCounter(_ currentValue: Int) {
        parent?.didChangeCounter(currentValue)
    }
}
