//
//  DateExtensions.swift
//  DreamLister
//
//  Created by Brian McAulay on 08/07/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import Foundation

let currentDate = Date()
let dateFormatter = DateFormatter()
let userCalendar = Calendar.current
let timeZone = NSTimeZone.local
let requestedComponent: Set<Calendar.Component> = [.month,.day,.hour,.minute,.second]

func getTimeDifference(dateToCheck: Date) -> String {
    //Check to see if we are in summer timne or not
    let endTime = getSummerTime(today: Date())
    //Calculate the time difference between the two dates
    let timeDifference = userCalendar.dateComponents(requestedComponent, from: dateToCheck, to: endTime as Date)
    //Check our time differences now
    if timeDifference.month! > 0{
        //One month or more had passed since the date was updated so just show that difference and ignore the rest
        return "\(timeDifference.month!) \(setPlurals(timeValue: timeDifference.month!, timePortion: "months")) ago"
    }else if timeDifference.day! > 0{
        //One week or more had passed since the date was updated so just show that difference and ignore the rest
        return "\(timeDifference.day!) \(setPlurals(timeValue: timeDifference.day!, timePortion: "days")) ago"
    }else if timeDifference.hour! > 0{
        //One hour or more had passed since the date was updated so just show that difference and ignore the rest
        return "\(timeDifference.hour!) \(setPlurals(timeValue: timeDifference.hour!, timePortion: "hours")) ago"
    }else if timeDifference.minute! > 0 {
        //One minute or more had passed since the date was updated so just show that difference and ignore the rest
        return "\(timeDifference.minute!) \(setPlurals(timeValue: timeDifference.minute!, timePortion: "minutes")) ago"
    }else{
        if timeDifference.second == 0{
            //Newly added item so just show 'Now' as the last updated
            return "Now"
        }
        //One second or more had passed since the date was updated so just show that difference and ignore the rest
        return "\(timeDifference.second!) \(setPlurals(timeValue: timeDifference.second!, timePortion: "seconds")) ago"
    } 
    
}

func setPlurals(timeValue: Int, timePortion: String) -> String{
    //Check to see if we should remove the last 's' on our time strings
    if timeValue < 2 {
        //Value is one so only show the single item e.g. minute instead of minutes
        let pluralIndicator = String(timePortion.characters.dropLast())
        return pluralIndicator
    }
    //No adjustment was required as the time portion was greater than 1
    return timePortion
}

func formatDate(dateToBeFormatted: Date) -> String{
    //This is the date string pattern match we are sending in from the system date
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
    //Convert our system date string to a Date type
    let dateString = dateFormatter.date(from: "\(dateToBeFormatted)")
    //Now rematch our expected output style
    dateFormatter.dateFormat = "dd MMM yyyy" //Show the day month and year
    //Return our formatted date
    return "\(dateFormatter.string(from: dateString!))"
}

func getSummerTime(today: Date) -> NSDate{
    //Check if we need to add an hour to the current system time
    if timeZone.isDaylightSavingTime(for: today){
        //We need to add an hour to our date as we're in BST(UK) or daylight savings elsewhere
        return (Calendar.current.date(byAdding:.hour, value: 1, to: today)! as NSDate)
    }else{
        //No daylight savings in operation for our location so just use the current system date
        return Date() as NSDate
    }
}
