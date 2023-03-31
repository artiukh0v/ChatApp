//
//  Messages.swift
//  MyAwesomeMessenger
//
//  Created by Ваня Артюхов on 20.03.2023.
//

import MessageKit
// The sender struct represent the sender of message
struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

// The Message struct represents a single message.
// sender: The sender of the message.
// messageId: An identifier for the message.
// sentDate: The date and time the message was sent.
// kind: The type of message.

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

// The Media struct represents a media item, such as an image or video, that can be attached to a message.
// url: The URL of the media item.
// image: The image object of the media item.
// placeholderImage: The placeholder image to be displayed while the media item is loading.
// size: The size of the media item.

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
// An extension of MessageKind that provides a string representation of each message kind.
extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "customc"
        case .linkPreview(_):
            return "link"
        }
    }
}

