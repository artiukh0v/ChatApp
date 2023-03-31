//
//  CollectionViewItemViewModel.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 22.02.2023.
//

import UIKit
import SDWebImage

protocol TableViewCellViewModelType {
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void)
    var userImage: String! { get  }
    var userName: String! { get }
}

final class tableViewCellViewModel: TableViewCellViewModelType {
    // user that set when class is initializing
    private var user: User
   // the url string of user avatar
    var userImage: String! {
        return user.userAvatarUrl
    }
    // username of user
    var userName: String! {
        return user.userName
    }
    // func that returns userAvatar UIImage
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        SDWebImageManager.shared.loadImage(with: imageUrl, progress: nil) { image,_,_,_,_,_ in
            completion(image)
        }
    }
    // initializing 
    init(user: User) {
        self.user = user
       
    }
}
