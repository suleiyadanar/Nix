//
//  ViewController.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/22/24.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcherCore
import Foundation

protocol ViewControllerDelegate: AnyObject {
    func clasificationOccured(_ viewController: ViewController, identifier: [CalendarEvent])
}

class ViewController: UIViewController{
    
    private let scopes = [kGTLRAuthScopeCalendar]
    private let service = GTLRCalendarService()
    
    weak var delegate: ViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = "619760553436-cvr4rum3g66l7knjji81n76n1rag8i0b.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        let connectText = UILabel()
        connectText.frame = CGRect(x: 100, y: 0, width: 200, height: 20)
        connectText.text = "Connect to your Calendar"
        
        let button = UIButton(frame: CGRect(x: 90, y: 30, width: 220, height: 50))
            button.setImage(UIImage(named: "google_calendar"), for:.normal)
     
          button.addTarget(self, action: #selector(googleSignInBtnPressed), for: .touchUpInside)

        self.view.addSubview(connectText)
        self.view.addSubview(button)
    }
    
    
    @IBAction func googleSignInBtnPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()

    }
    
    /// Creates calendar service with current authentication
    fileprivate lazy var calendarService: GTLRCalendarService? = {
        let service = GTLRCalendarService()
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them
        service.shouldFetchNextPages = true
        // Have the service object set tickets to retry temporary error conditions
        // automatically
        service.isRetryEnabled = true
        service.maxRetryInterval = 15

        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
            let authentication = currentUser.authentication else {
                return nil
        }

        service.authorizer = authentication.fetcherAuthorizer()
        return service
    }()
    
    // Extract Time
    func getTime (gtlTime: Date?) -> [Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm" // 12-hour format with AM/PM
        let timeString = timeFormatter.string(from: gtlTime ?? Date())
        timeFormatter.dateFormat = "a"
        let ampmString = timeFormatter.string(from: gtlTime ?? Date())

        return [timeString as String?,ampmString as String?,gtlTime ?? Date()]
    }

    // you will probably want to add a completion handler here
    func getEvents(for calendarId: String) {
        guard let service = self.calendarService else {
            return
        }

        // You can pass start and end dates with function parameters
        let startDateTime = GTLRDateTime(date: Calendar.current.startOfDay(for: Date()))
        let endDateTime = GTLRDateTime(date: Date().addingTimeInterval(60*60*24))

        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarId)
        eventsListQuery.timeMin = startDateTime
        eventsListQuery.timeMax = endDateTime

        _ = service.executeQuery(eventsListQuery, completionHandler: { (ticket, result, error) in
            guard error == nil, let items = (result as? GTLRCalendar_Events)?.items else {
                return
            }
            if items.count > 0 {
                var itemsList = [CalendarEvent]()
                for item in items {
                    let start = self.getTime(gtlTime: item.start?.dateTime?.date)
                    let end = self.getTime(gtlTime: item.end?.dateTime?.date)
                   
                    itemsList.append(
                        CalendarEvent(
                            summary:item.summary ?? "",
                            start: item.start?.dateTime?.date,
                            startTime:(start[0] as! String),
                            startTimeOfDay: (start[1] as! String),
                            end: item.end?.dateTime?.date,
                            endTime: (end[0] as! String),
                            endTimeOfDay: (end[1] as! String)))
                }
//                print(itemsList)
                self.delegate?.clasificationOccured(self, identifier: itemsList)
            }
                // Do stuff with your events
            else {
                // No events
                print("no events")
//                let noEvent = UILabel()
//                noEvent.text = "No eventsr"
//                self.view.addSubview(noEvent)

            }
        })
    }
    
    // Create an event to the Google Calendar's user
    func addEventoToGoogleCalendar(summary : String, description :String, startTime : String, endTime : String) {
        let calendarEvent = GTLRCalendar_Event()
        
        calendarEvent.summary = "\(summary)"
        calendarEvent.descriptionProperty = "\(description)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let startDate = dateFormatter.date(from: startTime)
        let endDate = dateFormatter.date(from: endTime)
        
        guard let toBuildDateStart = startDate else {
            print("Error getting start date")
            return
        }
        guard let toBuildDateEnd = endDate else {
            print("Error getting end date")
            return
        }
        
        calendarEvent.end = buildDate(date: toBuildDateEnd)
        var startTime = GTLRCalendar_EventDateTime()
    }
    
    // Helper to build date
    func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
        let datetime = GTLRDateTime(date: date)
        let dateObject = GTLRCalendar_EventDateTime()
        dateObject.dateTime = datetime
        return dateObject
    }
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}


extension ViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            getEvents(for:"primary")
//            addEventoToGoogleCalendar(summary: "summary9", description: "description", startTime: "25/02/2020 09:00", endTime: "25/02/2020 10:00")
        }
    }
}
