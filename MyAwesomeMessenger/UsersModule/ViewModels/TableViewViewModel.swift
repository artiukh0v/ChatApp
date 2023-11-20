//
//  UsersCollectionViewViewModel.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 22.02.2023.
//

import FirebaseFirestore

protocol TableViewViewModelType {
    init(FB: UsersFBRequestsProtocol)
    var FB: UsersFBRequestsProtocol { get }
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType
    var users: [User] { get set }
    var user: User? { get }
}

final class TableViewViewModel: TableViewViewModelType {
    // dependency of class which confirm the UsersFBRequestsProtocol protocol
    var FB: UsersFBRequestsProtocol

    // massive of users
    var users: [User] = []

    // current user
    var user: User?
    
    // returns number of rows in table view wich equal to count of elements in users massive
    func numberOfRows() -> Int {
        return users.count
    }

    // returns the view model of table view cell
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType {
        let user = users[indexPath.row]
        return tableViewCellViewModel(user: user)
    }

    
   
    init(FB: UsersFBRequestsProtocol) {
        // set class of type UsersFBRequestsProtocol in self.FB preperty
        self.FB = FB
        FB.getCurrentUserInfo { [weak self] error, user in
            guard let user = user else { print(error?.localizedDescription as Any); return }
            self?.user = user
        }
    }
}
