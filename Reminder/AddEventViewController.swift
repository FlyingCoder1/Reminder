//
//  ViewController.swift
//  Reminder
//
//  Created by Ivan Sadovich on 4.01.22.
//

import UIKit
import CoreData
import UserNotifications
class AddEventViewController: UIViewController {

   
    @IBOutlet var firstLineTextField:UITextField!
    @IBOutlet var secondLineTextField:UITextField!
    @IBOutlet var eventPicker:UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        eventPicker.minimumDate = Date()
        // Do any additional setup after loading the view.
    }
    @IBAction func saveTapped (_sender:UIBarButtonItem) {
        print("Save button tapped")
        let firstLine = firstLineTextField.text ?? ""
        let secondLine = secondLineTextField.text ?? ""
        print(" My event is \(firstLine) \(secondLine)")
        let eventdate = eventPicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newEvent = Event(context:context)
        newEvent.firstLine = firstLine
        newEvent.secondLine = secondLine
        newEvent.thirdLine = eventdate as Date?
        newEvent.eventID = UUID().uuidString
        
        if let uniqueID = newEvent.eventID {
            print("eventID: \(uniqueID) ")
        }
        do {
            try context.save()
            let message = " \(firstLine) "
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            let dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: eventdate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            if let identifier = newEvent.eventID {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        } catch let error {
            print ("Unable to save due to error \(error)")
        }
        dismiss(animated: true, completion: nil)
        print("Note was created")
    }
    @IBAction func cancelTapped(_sender:UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

