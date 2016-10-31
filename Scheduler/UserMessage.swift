//
//  UserMessage.swift
//  Scheduler
//
//  Created by James Brown on 10/31/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import Foundation
import MessageUI

class UserMessage: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    func send(reminder: Reminder?, viewController: UIViewController) {
        if let reminder = reminder {
            if let message = reminder.message, let recipient = reminder.recipient {
                if reminder.type == "text", MFMessageComposeViewController.canSendText() {
                    let messageController = MFMessageComposeViewController()
                    messageController.body = message
                    messageController.recipients = [recipient]
                    messageController.messageComposeDelegate = self
                    
                    viewController.present(messageController, animated: true, completion: nil)
                } else if reminder.type == "email", MFMailComposeViewController.canSendMail() {
                    let mailController = MFMailComposeViewController()
                    mailController.mailComposeDelegate = self
                    
                    mailController.setToRecipients([recipient])
                    mailController.setMessageBody(message, isHTML: false)
                    
                    if let subject = reminder.subject {
                        mailController.setSubject(subject)
                    }
                    
                    viewController.present(mailController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            
        }
    }
}
