import UIKit


//: ## 1. Create custom types to represent an Airport Departures display
//: ![Airport Departures](matthew-smith-5934-unsplash.jpg)
//: Look at data from [Departures at JFK Airport in NYC](https://www.airport-jfk.com/departures.php) for reference.
//:
//: a. Use an `enum` type for the FlightStatus (En Route, Scheduled, Canceled, Delayed, etc.)
//:
//: b. Use a struct to represent an `Airport` (Destination or Arrival)
//:
//: c. Use a struct to represent a `Flight`.
//:
//: d. Use a `Date?` for the departure time since it may be canceled.
//:
//: e. Use a `String?` for the Terminal, since it may not be set yet (i.e.: waiting to arrive on time)
//:
//: f. Use a class to represent a `DepartureBoard` with a list of departure flights, and the current airport
let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .none
dateFormatter.timeStyle = .short

enum FlightStatus: String {
    case scheduled = "Scheduled"
    case onTime = "On Time"
    case landed = "Landed"
    case delayed = "Delayed"
    case cancelled = "Cancelled"
    case boarding = "Boarding"
}

struct Airport {
    let name: String
    let code: String
    let city: String
    let numberOfTerminals: Int
}

struct Flight {
    let airline: String
    let destination: String
    let flightNumber: String
    let departure: Date?
    let arrival: Date?
    let terminal: String?
    let flightStatus: FlightStatus
}

class DepartureBoard {
    let airport: Airport
    var departures: [Flight]
    
    init(airport: Airport, departures: [Flight]) {
        self.airport = airport
        self.departures = departures
    }
    
    func flightAlert() {
        for flight in departures {
            switch flight.flightStatus {
            case .cancelled:
                print("We're sorry. Your flight to \(flight.destination) was cancelled. Here is a $500 voucher.")
            case .scheduled:
                print("Your flight to \(flight.destination) is scheduled to depart at", terminator: " ")
                if let unwrappedDeparture = flight.departure {
                    print(dateFormatter.string(from: unwrappedDeparture), terminator: " ")
                } else {
                    print("TBD", terminator: " ")
                }
                if let unwrappedTerminal = flight.terminal {
                        print("from terminal: \(unwrappedTerminal)")
                } else {
                        print("from terminal: TBD")
                }
            case .boarding:
                print("Your flight is boarding. Please head to terminal:", terminator: " ")
                if let unwrappedTerminal = flight.terminal {
                    print(unwrappedTerminal, terminator: " ")
                } else {
                    print("TBD", terminator: " ")
                }
                print("immediately. The doors are closing soon.")
            default:
                break
            }
            if flight.terminal == nil {
                print("Your flight has not been assigned a terminal. Please see the nearest information desk for more details.")
            }
        }
    }
}
    
//: ## 2. Create 3 flights and add them to a departure board
//: a. For the departure time, use `Date()` for the current time
//:
//: b. Use the Array `append()` method to add `Flight`'s
//:
//: c. Make one of the flights `.canceled` with a `nil` departure time
//:
//: d. Make one of the flights have a `nil` terminal because it has not been decided yet.
//:
//: e. Stretch: Look at the API for [`DateComponents`](https://developer.apple.com/documentation/foundation/datecomponents?language=objc) for creating a specific time
let JFK = Airport(name: "John F. Kennedy International Airport", code: "JFK", city: "New York", numberOfTerminals: 6)

let myDate = DateComponents(calendar: Calendar.current, year: 2020, month: 8, day: 20, hour: 6, minute: 30)

let flightDL567S = Flight(airline: "Delta", destination: "Boston", flightNumber: "DL567S", departure: Date(), arrival: myDate.date, terminal: "2", flightStatus: FlightStatus.scheduled)

let flightAA302 = Flight(airline: "American", destination: "Los Angeles", flightNumber: "AA302", departure: Date(), arrival: myDate.date, terminal: nil, flightStatus: FlightStatus.scheduled)

let flightKL646 = Flight(airline: "KLM", destination: "Amsterdam", flightNumber: "KL646", departure: nil, arrival: nil, terminal: "3", flightStatus: FlightStatus.cancelled)

let myBoard = DepartureBoard(airport: JFK, departures: [flightDL567S])

myBoard.departures.append(flightAA302)
myBoard.departures.append(flightKL646)

myBoard.flightAlert()
//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function


func printDepartures(departureBoard: DepartureBoard) {
    for flight in departureBoard.departures {
        print("Destination: \(flight.destination) Airline: \(flight.airline) Flight: \(flight.flightNumber)", terminator:" ")

        if let unwrappedDeparture = flight.departure {
            print("Departure: \(dateFormatter.string(from: unwrappedDeparture))", terminator: " ")
        } else {
            print("Departure: ", terminator: " ")
        }
        if let unwrappedArrival = flight.arrival {
            print("Arrival: \(dateFormatter.string(from: unwrappedArrival))", terminator: " ")
        } else {
            print("Arrival: ", terminator: " ")
        }
        if let unwrappedTerminal = flight.terminal {
            print("Terminal: \(unwrappedTerminal)", terminator: " ")
        } else {
            print("Terminal: ", terminator: " ")
        }
        print("Status: \(flight.flightStatus.rawValue)")
    }
}

printDepartures(departureBoard: myBoard)

//: ## 4. Make a second function to print print an empty string if the `departureTime` is nil
//: a. Createa new `printDepartures2(departureBoard:)` or modify the previous function
//:
//: b. Use optional binding to unwrap any optional values, use string interpolation to turn a non-optional date into a String
//:
//: c. Call the new or udpated function. It should not print `Optional(2019-05-30 17:09:20 +0000)` for departureTime or for the Terminal.
//:
//: d. Stretch: Format the time string so it displays only the time using a [`DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter) look at the `dateStyle` (none), `timeStyle` (short) and the `string(from:)` method
//:
//: e. Your output should look like:
//:
//:     Destination: Los Angeles Airline: Delta Air Lines Flight: KL 6966 Departure Time:  Terminal: 4 Status: Canceled
//:     Destination: Rochester Airline: Jet Blue Airways Flight: B6 586 Departure Time: 1:26 PM Terminal:  Status: Scheduled
//:     Destination: Boston Airline: KLM Flight: KL 6966 Departure Time: 1:26 PM Terminal: 4 Status: Scheduled

//  See above section, function modified

//: ## 5. Add an instance method to your `DepatureBoard` class (above) that can send an alert message to all passengers about their upcoming flight. Loop through the flights and use a `switch` on the flight status variable.
//: a. If the flight is canceled print out: "We're sorry your flight to \(city) was canceled, here is a $500 voucher"
//:
//: b. If the flight is scheduled print out: "Your flight to \(city) is scheduled to depart at \(time) from terminal: \(terminal)"
//:
//: c. If their flight is boarding print out: "Your flight is boarding, please head to terminal: \(terminal) immediately. The doors are closing soon."
//:
//: d. If the `departureTime` or `terminal` are optional, use "TBD" instead of a blank String
//:
//: e. If you have any other cases to handle please print out appropriate messages
//:
//: d. Call the `alertPassengers()` function on your `DepartureBoard` object below
//:
//: f. Stretch: Display a custom message if the `terminal` is `nil`, tell the traveler to see the nearest information desk for more details.

// see DepartureBoard for method


//: ## 6. Create a free-standing function to calculate your total airfair for checked bags and destination
//: Use the method signature, and return the airfare as a `Double`
//:
//:     func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
//:     }
//:
//: a. Each bag costs $25
//:
//: b. Each mile costs $0.10
//:
//: c. Multiply the ticket cost by the number of travelers
//:
//: d. Call the function with a variety of inputs (2 bags, 2000 miles, 3 travelers = $750)
//:
//: e. Make sure to cast the numbers to the appropriate types so you calculate the correct airfare
//:
//: f. Stretch: Use a [`NumberFormatter`](https://developer.apple.com/documentation/foundation/numberformatter) with the `currencyStyle` to format the amount in US dollars.
func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
    let bagPrice: Double = 25
    let milePrice: Double = 0.10
    let ticketCost = Double(distance) * milePrice * Double(travelers)
    let bagCost = Double(checkedBags) * bagPrice
    let total = ticketCost + bagCost
    return total
}

let airfare = calculateAirfare(checkedBags: 6, distance: 2500, travelers: 13)


let currencyFormatter = NumberFormatter()
currencyFormatter.usesGroupingSeparator = true
currencyFormatter.numberStyle = .currency
currencyFormatter.locale = Locale.current

let airfarePrice = currencyFormatter.string(from: NSNumber(value: airfare))

if let unwrappedPrice = airfarePrice {
    print("Total airfare for this flight is \(unwrappedPrice)")
}
