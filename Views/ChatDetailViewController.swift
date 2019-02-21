//
//  ChatDetailViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/28/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import SwiftDate

class ChatDetailViewController: JSQMessagesViewController  {
	
	var messagesS = [JSQMessage]()
	var conversation: Chat?
	var incomingBubble: JSQMessagesBubbleImage!
	var outgoingBubble: JSQMessagesBubbleImage!
	fileprivate var displayName: String!
	
	lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
	lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
	
	var chatID: String!
	var reciverPicture: String!
	var messages: [Chat] = []
    
    var recieverID: String!
    
    var timestamp: String!
    var timeStampDate = Dates()
    let formatter = DateFormatter()
    

    let regionNY = Region(tz: TimeZoneName.americaNewYork, cal: CalendarName.gregorian, loc: LocaleName.englishUnitedStates)

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		self.title = "Chat"
		
		self.navigationController?.navigationBar.tintColor = .white
		
		self.senderId = Auth.auth().currentUser?.uid
		self.senderDisplayName = Auth.auth().currentUser?.displayName
		
		
		
		

		print("rID", recieverID)
        
		print(messages.count)
		
		
        Database.database().reference(withPath: "chats").child(chatID).observe(.childAdded, with: { (snapshot) in
            
                        var values = snapshot.value as! [String : Any]
            
                        let text = values["chat_text"] as! String
                        print(text)
                        let time = values["time_chat_received"] as! String
                        print(time)
            
            
                        let userName = values["user_name"] as! String
            
                        if (self.messages.count == 0) {
                            if userName == Auth.auth().currentUser?.displayName {
								
                                self.messagesS.append(JSQMessage(senderId:  Auth.auth().currentUser?.uid, displayName: Auth.auth().currentUser?.displayName, text: text))

                               self.messages.append(Chat(text: text, time: time, userName: Auth.auth().currentUser?.displayName, sender: "true"))
                                self.collectionView.reloadData()
                            } else {
                                self.messagesS.append(JSQMessage(senderId: self.recieverID, displayName: "fuckboy", text: text))

                                self.messages.append(Chat(text: text, time: time, userName: "fuckboy", sender: "false"))
                                self.collectionView.reloadData()
                            }
                            
                        }
            
                        if (userName == Auth.auth().currentUser?.displayName) {
                           // self.messagesS.append(JSQMessage(senderId: Auth.auth().currentUser?.uid, displayName: Auth.auth().currentUser?.displayName, text: ))

                            
                            
                            if (!(self.messages.contains(where: {$0 == Chat(text: text, time: time, userName: userName, sender: "true")}))) {
                                self.messagesS.append(JSQMessage(senderId: UUID().uuidString, displayName: "fuckboy", text: text))

                                self.messages.append(Chat(text: text, time: time, userName: Auth.auth().currentUser?.displayName, sender: "true"))
                                self.collectionView.reloadData()
                            }
                        } else {
                            if (!(self.messages.contains(where: {$0 == Chat(text: text, time: time, userName: userName, sender: "false")}))) {
                                self.messagesS.append(JSQMessage(senderId: self.recieverID, displayName: "fuckboy", text: text))

                                self.messages.append(Chat(text: text, time: time, userName: "fuckboy", sender: "false"))
                                self.collectionView.reloadData()
                            }
                        }
            
                    })
        
        
		// This is a beta feature that mostly works but to make things more stable it is diabled.
		collectionView?.collectionViewLayout.springinessEnabled = false
		
		automaticallyScrollsToMostRecentMessage = true
		
		if #available(iOS 11.0, *){
			self.collectionView.contentInsetAdjustmentBehavior = .never
			self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
			self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset
		}
		
        
        
        
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData {
		return messagesS[indexPath.item]
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
		let message = messagesS[indexPath.item] // 1
		if message.senderId == senderId { // 2
			return outgoingBubbleImageView
		} else { // 3
			return incomingBubbleImageView
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
		let message = messagesS[indexPath.item]
		
		if message.senderId == senderId {
			cell.textView?.textColor = UIColor.white
		} else {
			cell.textView?.textColor = UIColor.black
		}
		return cell
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
		return nil
	}
	

	
    override func didPressSomeButton(_ sender: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!) {
        
        let todaysDate = Date()
        let todaysDateString = formatter.string(from: todaysDate)
		print(todaysDate)
        
        sendMessage(chatID: "", Message: text, Username: (Auth.auth().currentUser?.displayName)!, PictureID: "", Date: todaysDate.description)
        //chatID: statusSelected.chatID, Message: text, Username: userName, PictureID: pictureID, Date: todaysDateString
	}
	
	override func didPressAccessoryButton(_ sender: UIButton) {
		print("Not implemented yet")
	}
	
	
	private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
		let bubbleImageFactory = JSQMessagesBubbleImageFactory()
		return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
	}
	
	private func setupIncomingBubble() -> JSQMessagesBubbleImage {
		let bubbleImageFactory = JSQMessagesBubbleImageFactory()
		return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
	}
	
    private func addMessage(withId id: String, name: String, text: String, date: String) {
        
       let Date = date.date(formats: [.custom("E, MMM d, HH:mm"), .custom("E, MMM d, hh:mm aa"), .custom("E, MMM d, yyyy HH:mm"), .custom("E, MMM d, yyyy hh:mm aa")], fromRegion: regionNY)
        
        
        if let message = JSQMessage(senderId: id, senderDisplayName: name, date: Date?.absoluteDate, text: text){
            messagesS.append(message)
        }
	}
	
	
    func sendMessage(chatID: String, Message: String, Username: String, PictureID: String, Date: String)
	{
		
		
		
		Database.database().reference(withPath: "chats").child(self.chatID).child(UUID().uuidString).updateChildValues(["chat_text": Message, "time_chat_received":  Date, "user_name": Username])
		
		//ref.child("Chat").child(chatID).child(ref.childByAutoId().key).setValue(["messageID" : Message, "pictureID" : PictureID, "userID" : FIRAuth.auth()?.currentUser?.uid, "username" : Username])
		self.finishSendingMessage()
	}
	
}

extension JSQMessagesInputToolbar {
	override open func didMoveToWindow() {
		super.didMoveToWindow()
		if #available(iOS 11.0, *) {
			if self.window?.safeAreaLayoutGuide != nil {
				self.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow((self.window?.safeAreaLayoutGuide.bottomAnchor)!, multiplier: 1.0).isActive = true
			}
		}
	}
}


