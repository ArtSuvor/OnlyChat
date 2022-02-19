//
//  ChatViewController.swift
//  OnlyChat
//
//  Created by Art on 15.02.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

class ChatViewController: MessagesViewController {
    
//MARK: - Properties
    private let user: ModelUser
    private let chat: ChatModel
    private var messages: [MessageModel] = []
    private var messageListener: ListenerRegistration?
    
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
    
    deinit {
        messageListener?.remove()
    }
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageInputBar()
        setDelegate()
        changeLayout()
    }
    
//MARK: - InsertMessage
    private func insertNewMessage(message: MessageModel) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        messagesCollectionView.reloadData()
        scrollToLastMessage(message: message)
    }
    
//MARK: - ScrollToLastMessage
    private func scrollToLastMessage(message: MessageModel) {
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    
//MARK: - SendPhoto
    private func sendPhoto(image: UIImage) {
        StorageService.shared.uploadImageMessage(photo: image, to: chat) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(url):
                var message = MessageModel(user: self.user, image: image)
                message.downloadURL = url
                
                FirebaseService.shared.sendMessage(chat: self.chat, message: message) { result in
                    switch result {
                    case .success:
                        self.messagesCollectionView.scrollToLastItem()
                    case let .failure(error):
                        self.showAlert(with: "Error", and: error.localizedDescription)
                    }
                }
            case let .failure(error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
//MARK: - SetDelegate
    private func setDelegate() {
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
//MARK: - ChangeLayout
    private func changeLayout() {
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
        }
    }
    
//MARK: - SetListener
    private func setListener() {
        messageListener = ListenerService.shared.messagesObserver(chat: chat) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case var .success(message):
                if let url = message.downloadURL {
                    StorageService.shared.downloadImage(url: url) { result in
                        switch result {
                        case let .success(image):
                            message.image = image
                            self.insertNewMessage(message: message)
                        case let .failure(error):
                            self.showAlert(with: "Error", and: error.localizedDescription)
                        }
                    }
                } else {
                    self.insertNewMessage(message: message)
                }
            case let .failure(error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
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
        configCameraIcon()
    }
    
    private func configureSendButton() {
        messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
        messageInputBar.sendButton.applyGradients(cornerRadius: 10)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }
    
    private func configCameraIcon() {
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = #colorLiteral(red: 0.747739017, green: 0.5907533169, blue: 0.9361074567, alpha: 1)
        let cameraImage = UIImage(systemName: "camera")
        cameraItem.image = cameraImage
        
        cameraItem.addTarget(self, action: #selector(cameraButtonTapped), for: .primaryActionTriggered)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
    }
    
//MARK: - CameraButtonAction
    @objc private func cameraButtonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true)
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
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.item % 4 == 0 {
            return  NSAttributedString(
                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10),
                             NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        } else {
            return nil
        }
    }
}

//MARK: - MessageDelegate
extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        CGSize(width: 0, height: 8)
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.item % 4 == 0 {
            return CGFloat(30)
        } else {
            return CGFloat(0)
        }
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

//MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MessageModel(user: user, content: text)
        
        FirebaseService.shared.sendMessage(chat: chat, message: message) {[weak self] result in
            switch result {
            case .success:
                self?.messagesCollectionView.scrollToLastItem()
            case let .failure(error):
                self?.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
    }
}

//MARK: - UIimagePickerDeleagte
extension ChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        sendPhoto(image: image)
    }
}
