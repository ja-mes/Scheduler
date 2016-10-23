//
//  RemindersViewController.swift
//  Scheduler
//
//  Created by James Brown on 10/11/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import UserNotifications

class RemindersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    // MARK: vars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var intro: UIStackView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Reminder>!
    
    // MARK: overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchReminders()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkShowIntro()
        
        checkPastDues()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReminderDetail" {
            if let destination = segue.destination as? AddTableViewController {
                if let reminder = sender as? Reminder {
                    destination.reminder = reminder
                }
            }
       }
    }

    
    // MARK: Table View Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as? ReminderCell {
            configureCell(cell: cell, indexPath: indexPath)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ReminderDetail", sender: controller.object(at: indexPath))
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object  = controller.object(at: indexPath)
            
            if let id = object.id {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            }
            
            context.delete(object)
            ad.saveContext()
            
            checkShowIntro()
        }
    }

    
    // MARK: message compose view controller
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: fetched results controller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRow(at: indexPath) as? ReminderCell {
                    configureCell(cell: cell, indexPath: indexPath)
                }
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    // MARK: IBActions
    @IBAction func addTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: "ReminderDetail", sender: nil)
    }
    
    @IBAction func segmentChanged(_ sender: AnyObject) {
        fetchReminders()
        tableView.reloadData()
    }

    
    
    // MARK: Functions
    func checkShowIntro() {
        if let count = controller.fetchedObjects?.count {
            if count == 0 {
                tableView.isHidden = true
                intro.isHidden = false
                view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            } else {
                tableView.isHidden = false
                intro.isHidden = true
                view.backgroundColor = UIColor.white
            }
        }
    }
    
    func checkPastDues() {
        if let objects = controller.fetchedObjects {
            let currentDate = Date()
            
            for i in objects {
                if let entryDate = i.entryDate, currentDate.compare(entryDate) == ComparisonResult.orderedDescending {
                    tableView.reloadData()
                }
            }
        }
    }
    
    func fetchReminders() {
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        var displaySent = false
        
        if segment.selectedSegmentIndex == 1 {
            displaySent = true
        }
        
        fetchRequest.predicate = NSPredicate(format: "sent == %@", displaySent as CVarArg)
        
        // sort descriptors
        let recipientSort = NSSortDescriptor(key: "recipient", ascending: true)
        fetchRequest.sortDescriptors = [recipientSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print(error)
        }
    }
    
    func configureCell(cell: ReminderCell, indexPath: IndexPath) {
        let reminder = controller.object(at: indexPath)
        cell.recipientLbl.text = reminder.recipient
        
        if reminder.type == "email" {
            cell.icon.image = #imageLiteral(resourceName: "email_icon")
        } else {
            cell.icon.image = #imageLiteral(resourceName: "messages_chat")
        }
        
        if let date = reminder.entryDate {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.short
            formatter.timeStyle = .short
            
            cell.dateLbl.text = formatter.string(from: date)
            
            if Date().compare(date) == ComparisonResult.orderedDescending {
                cell.pastDue.isHidden = false
            } else {
                cell.pastDue.isHidden = true
            }
        }
    }

 }















