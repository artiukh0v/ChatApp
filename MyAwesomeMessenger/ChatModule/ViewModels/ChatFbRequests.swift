//
//  FirebaseRequests.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 24.03.2023.
//

import FirebaseAuth
import FirebaseFirestore
import MessageKit
import FirebaseStorage
// MARK: Protocols
protocol ChatFBRequestsType {
    func sendMessege(otherId: String, conversationId: String?, sendMessage: Message, completion: @escaping (String) -> Void)
    func getConversationId(otherId: String, completion: @escaping (String) -> Void)
    func getAllMessages(chatId: String, completion: @escaping ([Message]) -> Void )
    func uploadImage(image: UIImage, chatId: String, complition: @escaping(String)->Void)
}
class ChatFBRequests: ChatFBRequestsType {
    // MARK: func sendMessege
    // this func sending message in Firebase Firestore and return chatId(id of current conversation)
    public func sendMessege(otherId: String, conversationId: String?, sendMessage: Message, completion: @escaping (String) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            // text of message it can be just text of urlString of image
            var text = ""
            
            // Check what's the kind of message
            switch sendMessage.kind {
            case .text(let messageText):
                text = messageText
            case .attributedText(_):
                break
            case .photo(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    text = targetUrlString
                }
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_), .linkPreview(_):
                break
            }
            
            // Checkind id conversation id equal nil
            if conversationId == nil {
                let newConversationId = UUID().uuidString // rename local constant
                
                let selfData: [String: Any] = ["otherId": otherId]
                let otherData: [String: Any] = ["otherId": uid]
                
                // putting in our firestore otherUserId
                Firestore.firestore().collection("users")
                    .document(uid)
                    .collection("conversation")
                    .document(newConversationId)
                    .setData(selfData) { error in
                        if error != nil {
                            return
                        }
                        
                    }
                // putting in otherUser our Id
                Firestore.firestore().collection("users")
                    .document(otherId)
                    .collection("conversation")
                    .document(newConversationId)
                    .setData(otherData) { error in
                        if error != nil {
                            return
                        }
                    }
                // current message that we send
                let message: [String: Any] = [
                    "dateSent": Date(),
                    "senderId": uid,
                    "kind": sendMessage.kind.messageKindString,
                    "text": text
                ]
                // conversation info that we need to understand who is sender
                let conversationInfo: [String: Any] = [
                    "dateStarted": Date(),
                    "selfSender": uid,
                    "otherSender": otherId
                ]
                // set conversation info in new conversation
                Firestore.firestore().collection("conversation")
                    .document(newConversationId)
                    .setData(conversationInfo) { error in
                        if let error = error {
                            print("Error setting conversation document: \(error.localizedDescription)")
                            return
                        }
                        // sending first message in new conversation
                        Firestore.firestore().collection("conversation")
                            .document(newConversationId)
                            .collection("messages")
                            .addDocument(data: message) { error in
                                if let error = error {
                                    print("Error adding message document: \(error.localizedDescription)")
                                    return
                                }
                                completion(newConversationId)
                            }
                    }
            } else {
                // now we know that we have conversation id
                // message that we sending
                let message: [String: Any] = [
                    "dateSent": Date(),
                    "senderId": uid,
                    "kind": sendMessage.kind.messageKindString,
                    "text": text
                ]
                // putting our message in firestore
                Firestore.firestore().collection("conversation")
                    .document(conversationId!)
                    .collection("messages")
                    .addDocument(data: message) { error in
                        if let error = error {
                            print("Error adding message document: \(error.localizedDescription)")
                            return
                        }
                        completion(conversationId!)
                    }
                
            }
        }
    }
    // MARK: getConversationId
    // this func return conversation id from other user info in firestore
    public func getConversationId(otherId: String, completion: @escaping (String) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            Firestore.firestore().collection("users")
                .document(uid)
                .collection("conversation")
                .whereField("otherId", isEqualTo: otherId)
                .getDocuments { snap, error in
                    if error != nil {
                        return
                    }
                    if let snap = snap, !snap.isEmpty {
                        
                        let document = snap.documents.first
                        if let conversationId = document?.documentID {
                            completion(conversationId)
                        }
                    }
                }
        }
    }
    // MARK: getAllMessages
    public func getAllMessages(chatId: String, completion: @escaping ([Message]) -> Void ) {
        Firestore.firestore().collection("conversation")
            .document(chatId)
            .collection("messages")
            .order(by: "dateSent", descending: false)
            .limit(toLast: 50)
            .addSnapshotListener { snap, error in
                if error != nil {
                    return
                }
                if let snap = snap, !snap.documents.isEmpty {
                    var messages = [Message]()
                    // for message in messages
                    for document in snap.documents {
                        // all data of message
                        let data = document.data()
                        // id of user who send message
                        let userId = data["senderId"] as! String
                        // message id
                        let messageId = document.documentID
                        // date when message was sent
                        let date = data["dateSent"] as! Timestamp
                        let sendDate = date.dateValue()
                        // text of message it can be just text of urlString of image
                        let text = data["text"] as! String
                        // kind of message
                        let kindString = data["kind"] as! String
                        // message sender now type MessageSender
                        let sender = Sender(senderId: userId, displayName: "")
                        
                        // checking what's the kind of message
                        var kind: MessageKind?
                        if kindString == "photo" {
                            guard let imageUrl = URL(string: text), let placeHolder = UIImage(systemName: "photo") else { return }
                            let media = Media(url: imageUrl,
                                              image: nil,
                                              placeholderImage: placeHolder,
                                              size: CGSize(width: 200, height: 200))
                            kind = .photo(media)
                            
                        } else {
                            kind = .text(text)
                        }
                        guard let finalKind = kind else { return }
                        let message = Message(sender: sender, messageId: messageId, sentDate: sendDate, kind: finalKind)
                        messages.append(message)
                    }
                    completion(messages)
                }
            }
    }
    // MARK: uploadImage
    // that function sending image in storage and returning a url of this image 
    public func uploadImage(image: UIImage, chatId: String, complition: @escaping(String)->Void) {
        let referens = Storage.storage().reference().child("photoMessage\(chatId)\(Date())")
        guard let date = image.pngData() else { return }
        referens.putData(date, metadata: nil, completion: {  metadata, error in
            
            referens.downloadURL(completion: { url, error in
                guard let url = url else { return }
                let urlString = url.absoluteString
                complition(urlString)
            })
        })
    }
}
