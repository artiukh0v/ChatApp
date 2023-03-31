//
//  UserTableViewCell.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 19.03.2023.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // view model set in UsersViewController 
    var viewModel: TableViewCellViewModelType? {
           didSet {
               usernameLabel.text = viewModel?.userName
              
               viewModel?.loadImage(from: (viewModel?.userImage)!, completion: { [weak self] image in
                   DispatchQueue.main.async {
                       self?.userImageView.image = image
                   }
                  
               })
           }
       }
}
