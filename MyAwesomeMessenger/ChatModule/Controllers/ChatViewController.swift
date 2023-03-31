//
//  ChatViewController.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 20.03.2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SDWebImage

class ChatViewController: MessagesViewController {
    // view model dependency with type protocol of viewmodel
    var viewModel: ChatViewModelType!
    // propertys that we get from usersViewController and sending in viewmodel
    var otherId: String!
    var avatarURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialising viewmodel
        viewModel = ChatViewModel(FB: ChatFBRequests(), otherId: otherId)
        // configuration functions
        configureMessageCollectionView()
        configureMessageInputBar()

        // bind func that reloading data of messagesCollectionView when messages are changing
        viewModel.messages.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToLastItem(animated: false)
            }
        }
    }
  // MARK: configureMessageCollectionView
    private func configureMessageCollectionView() {
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        showMessageTimestampOnSwipeLeft = true // default false

     
    }
    // MARK: configureMessageInputBar
    private func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.placeholder = "Message..."
        messageInputBar.sendButton.setTitleColor(.blue, for: .normal)
        messageInputBar.sendButton.setTitleColor(
          UIColor.red.withAlphaComponent(0.3),
          for: .highlighted)
        
        let inputBar = InputBarButtonItem()
        inputBar.setSize(CGSize(width: 36, height: 36), animated: false)
        inputBar.setImage(UIImage(systemName: "photo"), for: .normal)
        inputBar.onTouchUpInside { [weak self] _ in
            self?.presentPhotoLibrary()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([inputBar], forStack: .left, animated: false)
      }
    
    // MARK: presentPhotoLibrary
    private func presentPhotoLibrary() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
        
    }
    
    

}
// MARK: Extensions
extension ChatViewController: MessagesDisplayDelegate, MessagesDataSource, MessagesLayoutDelegate {
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return viewModel.messageCount()
    }
    func currentSender() -> MessageKit.SenderType {
        return viewModel.currentSender()
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) ->   MessageKit.MessageType {
        return viewModel.messageForItem(indeexPath: indexPath.section)
    }
    // sets avatars for both users
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == CurrentUserInfoUserDefaults.currentUser.userId {
            let url = URL(string: CurrentUserInfoUserDefaults.currentUser.userAvatarUrl)
            viewModel.getAvatarImage(url: url!) { image in
                let avatar = Avatar(image: image)
                avatarView.set(avatar: avatar)
            }
            
        } else if message.sender.senderId == otherId {
            let url = URL(string: avatarURL)
            viewModel.getAvatarImage(url: url!) { image in
                let avatar = Avatar(image: image)
                avatarView.set(avatar: avatar)
            }
        }
    }
    // sets image in imageMessage image view
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
            guard let message = message as? Message else { return  }

            switch message.kind {
            case .photo(let media):
                guard let imageUrl = media.url else { return }
                imageView.sd_setImage(with: imageUrl, completed: nil)
            default:
                break
            }
        }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    // func that fires when send button is pressed
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        viewModel.sendMessege(kind: .text(text))
            inputBar.inputTextView.text = nil
    }
}


extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.editedImage] as? UIImage {
            viewModel.sendImage(image: image)
        }
    }
}

    
   
