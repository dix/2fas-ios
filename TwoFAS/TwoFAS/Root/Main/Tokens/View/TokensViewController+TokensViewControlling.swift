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

protocol TokensViewControlling: AnyObject {
    func reloadData(newSnapshot: NSDiffableDataSourceSnapshot<GridSection, GridCell>)
        
    func showList()
    func showEmptyScreen()
    func showSearchEmptyScreen()
    
    func enableDragging()
    func disableDragging()
    
    func updateAddIcon(using state: TokensViewControllerAddState)
    func updateEditState(using state: TokensViewControllerEditState)
    
    func lockBars()
    func unlockBars()
    
    func addSearchBar()
    func removeSearchBar()
    
    func enableBounce()
    func disableBounce()
}

extension TokensViewController: TokensViewControlling {
    // MARK: - Data managment
    func reloadData(newSnapshot: NSDiffableDataSourceSnapshot<GridSection, GridCell>) {
        if gridView.hasActiveDrag || gridView.hasActiveDrop {
            gridView.cancelInteractiveMovement()
        }
        dataSource.apply(newSnapshot, animatingDifferences: !gridView.hasActiveDrag, completion: nil)
        // no need to call reload other than seconds/consumer update
        gridView.reloadData()
    }
    
    // MARK: - Empty screen or list
    func showList() {
        if presenter.count > 1 {
            addSearchBar()
            gridView.alwaysBounceVertical = true
        } else {
            gridView.alwaysBounceVertical = false
        }
        UIView.animate(
            withDuration: Theme.Animations.Timing.show,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseInOut],
            animations: {
                self.emptyListScreenView.alpha = 0
                self.emptySearchScreenView.alpha = 0
            },
            completion: { _ in
                self.emptyListScreenView.isHidden = true
                self.emptySearchScreenView.isHidden = true
            }
        )
    }
    
    func showEmptyScreen() {
        removeSearchBar()
        VoiceOver.say(T.Voiceover.useAddServiceButtonTitle)
        emptyListScreenView.alpha = 0
        emptyListScreenView.isHidden = false
        UIView.animate(withDuration: Theme.Animations.Timing.show, animations: {
            self.emptyListScreenView.alpha = 1
        })
    }
    
    func showSearchEmptyScreen() {
        VoiceOver.say(T.Voiceover.noSearchResults)
        emptySearchScreenView.alpha = 0
        emptySearchScreenView.isHidden = false
        UIView.animate(
            withDuration: Theme.Animations.Timing.show,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseInOut]
        ) {
            self.emptySearchScreenView.alpha = 1
        }
    }
    
    // MARK: - Dragging
    func enableDragging() {
        gridView.dragInteractionEnabled = true
    }
    
    func disableDragging() {
        gridView.dragInteractionEnabled = false
    }
    
    // MARK: - Navibar icons
    func updateAddIcon(using state: TokensViewControllerAddState) {
        switch state {
        case .firstTime:
            let button = UIBarButtonItem(
                image: Asset.naviIconAddFirst.image,
                style: .plain,
                target: self,
                action: #selector(addServiceAction)
            )
            button.accessibilityLabel = T.Voiceover.addService
            navigationItem.rightBarButtonItems = nil
            navigationItem.rightBarButtonItem = button
        case .normal:
            let button = UIBarButtonItem(
                image: Asset.naviIconAdd.image,
                style: .plain,
                target: self,
                action: #selector(addServiceAction)
            )
            button.accessibilityLabel = T.Voiceover.addService
            navigationItem.rightBarButtonItems = nil
            navigationItem.rightBarButtonItem = button
        case .none:
            let buttonSection = UIBarButtonItem(
                image: Asset.addCategory.image,
                style: .plain,
                target: self,
                action: #selector(addSectionAction)
            )
            buttonSection.accessibilityLabel = T.Voiceover.addGroup
            let buttonSort = UIBarButtonItem(
                image: Asset.naviSortIcon.image,
                style: .plain,
                target: self,
                action: #selector(showSortSelection)
            )
            buttonSort.accessibilityLabel = T.Voiceover.sortByTitle
            navigationItem.rightBarButtonItems = [buttonSection, buttonSort]
        }
    }
    
    func updateEditState(using state: TokensViewControllerEditState) {
        let button: UIBarButtonItem?
        
        switch state {
        case .edit:
            button = UIBarButtonItem(
                title: T.Commons.edit,
                style: .plain,
                target: self,
                action: #selector(enterEditMode)
            )
            gridView.isEditing = false
        case .cancel:
            button = UIBarButtonItem(
                title: T.Commons.done,
                style: .plain,
                target: self,
                action: #selector(leaveEditMode)
            )
            gridView.isEditing = true
        case .none:
            button = nil
            gridView.isEditing = false
        }
        
        navigationItem.leftBarButtonItem = button
    }
    
    func gridCell(for indexPath: IndexPath) -> GridCell? {
        let snapshot = dataSource.snapshot()
        guard
            let section = snapshot.sectionIdentifiers[safe: indexPath.section],
            let cell = snapshot.itemIdentifiers(inSection: section)[safe: indexPath.row]
        else { return nil }
        return cell
    }
    
    // MARK: - Bars
    
    func lockBars() {
        tabBarController?.tabBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    func unlockBars() {
        tabBarController?.tabBar.isUserInteractionEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    // MARK: - Search Bars
    
    func addSearchBar() {
        guard !searchBarAdded else { return }
        searchBarAdded = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func removeSearchBar() {
        guard searchBarAdded else { return }
        searchBarAdded = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.searchController = nil
    }
    
    // MARK: - Bounce
    
    func enableBounce() {
        gridView.alwaysBounceVertical = true
    }
    
    func disableBounce() {
        gridView.alwaysBounceVertical = false
    }
}

private extension TokensViewController {
    @objc
    func addSectionAction() {
        presenter.handleShowSectionCreation()
    }
    
    @objc
    func showSortSelection() {
        presenter.handleShowSortSelection()
    }
    
    @objc
    func addServiceAction() {
        presenter.handleAddService()
    }
    
    @objc
    func enterEditMode() {
        presenter.handleEnterEditMode()
    }
    
    @objc
    func leaveEditMode() {
        presenter.handleLeaveEditMode()
    }
}

extension TokensViewController {
    @objc(notificationServicesWereUpdated:)
    func notificationServicesWereUpdated(notification: Notification) {
        let modified = notification.userInfo?[Notification.UserInfoKey.modified] as? [String]
        let deleted = notification.userInfo?[Notification.UserInfoKey.deleted] as? [String]
        presenter.handleServicesWereUpdated(modified: modified, deleted: deleted)
    }
    
    @objc
    func notificationSectionsWereUpdated() {
        presenter.handleSectionsUpdated()
    }
    
    @objc
    func notificationAppDidBecomeActive() {
        presenter.handleAppDidBecomeActive()
    }
    
    @objc
    func notificationAppDidBecomeInactive() {
        presenter.handleAppBecomesInactive()
    }
}
