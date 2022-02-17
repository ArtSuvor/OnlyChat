//
//  ChatViewController.swift
//  OnlyChat
//
//  Created by Art on 15.02.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
//MARK: - Properties
    private let user: ModelUser
    private let chat: ChatModel
    private var messages: [MessageModel] = []
    
//MARK: - Init
    init(user: ModelUser, chat: ChatModel) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        
        title = chat.friendUserName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageInputBar()
        setDelegate()
        changeLayout()
    }
    
    private func insertNewMessage(message: MessageModel) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        messagesCollectionView.reloadData()
    }
    
    private func setDelegate() {
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    private func changeLayout() {
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
    }
}

//MARK: - ConfigMessageInputBar
extension ChatViewController {
    private func configureMessageInputBar() {
        messagesCollectionView.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1)
        
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .mainWhite()
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7098040581, green: 0.7098040581, blue: 0.7098040581, alpha: 1)
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.8745097518, green: 0.874509871, blue: 0.874509871, alpha: 0.5)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        messageInputBar.layer.shadowColor = UIColor.black.cgColor
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
    }
    
    private func configureSendButton() {
        messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
        messageInputBar.sendButton.applyGradients(cornerRadius: 10)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }
}

//MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        user
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        1
    }
}

//MARK: - MessageDelegate
extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        CGSize(width: 0, height: 8)
    }
}

//MARK: - MessageDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        .bubble
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MessageModel(user: user, content: text)
        insertNewMessage(message: message)
        inputBar.inputTextView.text = ""
    }
}
