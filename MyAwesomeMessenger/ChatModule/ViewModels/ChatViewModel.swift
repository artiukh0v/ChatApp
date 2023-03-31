//
//  ChatViewModel.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 27.03.2023.
//

import Foundation
import MessageKit
import SDWebImage

// MARK: Protocols 
// Protocol that have all propertys for ChaViewController
protocol ChatViewModelType {
    var otherId: String { get set}
    var FB: ChatFBRequestsType { get }
    var messages: Observer<[Message]> { get set }
    func currentSender() -> MessageKit.SenderType
    func messageCount() -> Int
    func messageForItem(indeexPath: Int) -> MessageKit.MessageType
    func sendMessege(kind: MessageKind)
    func getAvatarImage(url: URL, completion: @escaping (UIImage?) -> Void)
    func sendImage(image: UIImage)
}
// Protocol that have propertys that uses only in ChatViewModel
protocol ChatViewModelProtocol {
    var chatId: String? { get set }
    func getMesseges(conversetionId: String, completion: (() -> Void)?)
}
class ChatViewModel: ChatViewModelType, ChatViewModelProtocol{
    
    // MARK: Properties

    // Messages is an Observer object which stores an array of Message objects
    var messages: Observer<[Message]> = Observer([])

    // otherId is the ID of the other user in the conversation
    var otherId: String

    // chatId is the ID of the current conversation
    var chatId: String?

    // FB is an instance of the ChatFBRequestsType protocol, which is used to interact with Firebase
    var FB: ChatFBRequestsType

    // selfSenderId is the ID of the current user
    let selfSenderId: String

    // MARK: Computed Properties

    // selfSender is an instance of the Sender struct that represents the current user
    var selfSender: Sender {
        return Sender(senderId: selfSenderId, displayName: "")
    }

    // otherSender is an instance of the Sender struct that represents the other user
    var otherSender: Sender {
        return Sender(senderId: otherId, displayName: "")
    }

    // MARK: Initializers

    // Initializes the ChatViewModel with an instance of ChatFBRequestsType and the other user's ID
    init(FB: ChatFBRequestsType, otherId: String) {
        self.FB = FB
        self.otherId = otherId
        selfSenderId = CurrentUserInfoUserDefaults.currentUser.userId
        
        // If chatId is nil, retrieves the conversation ID from Firebase and loads the messages for that conversation
        if chatId == nil {
            FB.getConversationId(otherId: otherId) {[weak self] chatId in
                self?.chatId = chatId
                self?.getMesseges(conversetionId: chatId)
            }
        }
    }

    // MARK: Functions

    // Retrieves messages for a given conversation ID from Firebase and updates the messages property
    func getMesseges(conversetionId: String, completion: (() -> Void)? = nil) {
        FB.getAllMessages(chatId: conversetionId) {[weak self] messages in
            self?.messages.value = messages
        }
    }

    // Returns the current sender as an instance of MessageKit's SenderType
    func currentSender() -> MessageKit.SenderType {
        return selfSender
    }

    // Returns the number of messages in the messages array
    func messageCount() -> Int {
        return messages.value.count
    }

    // Returns the message at the specified index as an instance of MessageKit's MessageType
    func messageForItem(indeexPath: Int) -> MessageKit.MessageType {
        return messages.value[indeexPath]
    }
    // Sending Message in Firebase Firestore and set chatId if it nil
    func sendMessege(kind: MessageKind) {
        let message = Message(sender: selfSender, messageId: "", sentDate: Date(), kind: kind)
        messages.value.append(message)
        FB.sendMessege(otherId: otherId, conversationId: chatId, sendMessage: message) {[weak self] chatId in
            self?.chatId = chatId
        }
    }
    // Return Avatar(UIImage) of user with whom current user chatting
    func getAvatarImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { image, _, _, _, _, _ in
            completion(image)
        }
    }
    // Sending UIImage of Image Message
    // Return url of url of this image
    // Sending Image Message in Firebase Firestore
    func sendImage(image: UIImage)  {
        guard let chatId = chatId else { return }
        
        FB.uploadImage(image: image, chatId: chatId) { [self] urlString in
            
            guard let url = URL(string: urlString), let placeholder = UIImage(systemName: "plus") else { return }

            let media = Media(url: url,
                              image: nil,
                              placeholderImage: placeholder,
                              size: .zero)

            let message = Message(sender: selfSender,
                                  messageId: "",
                                  sentDate: Date(),
                                  kind: .photo(media))
            messages.value.append(message)
            self.FB.sendMessege(otherId: otherId, conversationId: chatId, sendMessage: message) {[weak self] chatId in
                self?.chatId = chatId
            }
        }
    }
}
