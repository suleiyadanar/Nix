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
    let service = GTLRCalendarService()
    
    weak var delegate: ViewControllerDelegate?

    var startDateTime: Date?
        
    var endDateTime: Date?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController loaded with startDateTime: \(startDateTime), endDateTime: \(endDateTime)")
        
        GIDSignIn.sharedInstance().clientID = "619760553436-cvr4rum3g66l7knjji81n76n1rag8i0b.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        print("got here")
        
        if GIDSignIn.sharedInstance().hasPreviousSignIn(){
            GIDSignIn.sharedInstance().restorePreviousSignIn()
            print("has previous sign in detected")
            print(GIDSignIn.sharedInstance().currentUser)
            if let currentUser = GIDSignIn.sharedInstance().currentUser {
                // User is signed in, get their information
                print("user signed in info get")
                if let profile = currentUser.profile {
                    let userName = profile.name
                    print("User's name is \(userName)")
                } else {
                    print("User's profile is not available")
                }
                let button = UIButton(type: .system)

              button.setImage(UIImage(named: "google_calendar"), for:.normal)
         
              button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
                self.view.addSubview(button)
               
                getEvents(for:"primary")
            }else{
                print("signed in but can't get info")
                GIDSignIn.sharedInstance().signOut()
                setupUI()
            }
        }else {
            // User is not signed in, so set up the UI
            setupUI()
        }
    }
        
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
    
    func test() {
        print("view controller test")
    }
    private func setupUI() {
        print("supposed to set up")
            
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 50))
                   button.setImage(UIImage(named: "google_calendar"), for:.normal)
            
                 button.addTarget(self, action: #selector(googleSignInBtnPressed), for: .touchUpInside)
            self.view.addSubview(button)
            
        
        }
    
    
    @IBAction func googleSignInBtnPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        print("signed in")
    }
    
    @IBAction func signOut(sender: Any) {
      GIDSignIn.sharedInstance().signOut()
      print("signed out")
    }
    
    /// Creates calendar service with current authentication
    
    
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

   
    func getCalendarTimeZone(calendarId: String, completion: @escaping (String?) -> Void) {
        print("got here ")
       
        
        print("got here two")
        let calendarQuery = GTLRCalendarQuery_CalendarsGet.query(withCalendarId: "primary")
        service.executeQuery(calendarQuery) { (ticket, response, error) in
            guard error == nil, let calendar = response as? GTLRCalendar_Calendar else {
                print("Error fetching calendar metadata: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let timeZone = calendar.timeZone
            print(timeZone)
            completion(timeZone)
        }
    }

    func getEvents(for calendarId: String) {
//        guard let service = self.calendarService else {
//            return
//        }
        getCalendarTimeZone(calendarId: calendarId) { timeZoneIdentifier in
                guard let timeZoneIdentifier = timeZoneIdentifier,
                      let timeZone = TimeZone(identifier: timeZoneIdentifier) else {
                    print("Failed to fetch or parse calendar time zone.")
                    return
                }

            let offsetMinutes = timeZone.secondsFromGMT(for: self.startDateTime ?? Date()) / 60

            let startDateTimeGTLR = GTLRDateTime(date: self.startDateTime ?? Date(), offsetMinutes: offsetMinutes)
            let endDateTimeGTLR = GTLRDateTime(date: self.endDateTime ?? Date(), offsetMinutes: offsetMinutes)

            print("start time input", self.startDateTime)
            print("end time input", self.endDateTime)
                print("start time gtlr", startDateTimeGTLR)
                print("end time gtlr", endDateTimeGTLR)

                let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarId)
            
                eventsListQuery.timeMin = startDateTimeGTLR
                eventsListQuery.timeMax = endDateTimeGTLR

                // Execute the query to get events
            _ = self.service.executeQuery(eventsListQuery, completionHandler: { (ticket, result, error) in
                   guard error == nil, let items = (result as? GTLRCalendar_Events)?.items else {
                       print(error)
                       return
                   }

                   print("got here to items")
                   print(items)
                   if items.count > 0 {
                       var itemsList = [CalendarEvent]()
                       for item in items {
                           let start = self.getTime(gtlTime: item.start?.dateTime?.date)
                           let end = self.getTime(gtlTime: item.end?.dateTime?.date)

                           itemsList.append(
                               CalendarEvent(
                                   summary: item.summary ?? "",
                                   start: item.start?.dateTime?.date,
                                   startTime: (start[0] as! String),
                                   startTimeOfDay: (start[1] as! String),
                                   end: item.end?.dateTime?.date,
                                   endTime: (end[0] as! String),
                                   endTimeOfDay: (end[1] as! String)
                               )
                           )
                       }
                       self.delegate?.clasificationOccured(self, identifier: itemsList)
                   } else {
                       print("no events")
                   }
               })
            }
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
