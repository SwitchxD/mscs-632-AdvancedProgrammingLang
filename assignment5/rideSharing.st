"Ride Sharing System - Smalltalk
Demonstrates encapsulation, inheritance, and polymorphism."

Object subclass: Ride [
    | rideID pickup dropoff distance |

    Ride class >> id: anID pickup: p dropoff: d distance: dist [
        | r | r := self new. r setID: anID pickup: p dropoff: d distance: dist. ^r
    ]
    setID: anID pickup: p dropoff: d distance: dist [
        rideID := anID. pickup := p. dropoff := d. distance := dist.
    ]
    rideID [ ^rideID ]
    distance [ ^distance ]

    fare [ ^distance * 1.5 ]
    rideType [ ^'Generic' ]

    "Formats a dollar amount as dollars.cents using integer math only,
     avoiding a known GNU Smalltalk bug in Float>>printString."
    formatMoney: aNumber [
        | cents dollars remCents |
        cents := (aNumber * 100) rounded.
        dollars := cents // 100.
        remCents := cents \\ 100.
        ^dollars printString, '.', (remCents printPaddedWith: $0 to: 2)
    ]

    rideDetails [
        Transcript showCr:
            'Ride ', rideID printString, ' [', self rideType, '] ',
            pickup, ' -> ', dropoff, ' | ', (self formatMoney: distance),
            ' mi | $', (self formatMoney: self fare).
    ]
]

Ride subclass: StandardRide [
    fare [ ^2.0 + (self distance * 1.75) ]
    rideType [ ^'Standard' ]
]

Ride subclass: PremiumRide [
    | luxuryFee |
    PremiumRide class >> id: anID pickup: p dropoff: d distance: dist luxuryFee: fee [
        | r | r := self id: anID pickup: p dropoff: d distance: dist. r setLuxuryFee: fee. ^r
    ]
    setLuxuryFee: fee [ luxuryFee := fee ]
    fare [ ^4.0 + (self distance * 3.25) + luxuryFee ]
    rideType [ ^'Premium' ]
]

Object subclass: Driver [
    | driverID name rating assignedRides |

    Driver class >> id: anID name: n rating: r [
        | d | d := self new. d setID: anID name: n rating: r. ^d
    ]
    setID: anID name: n rating: r [
        driverID := anID. name := n. rating := r. assignedRides := OrderedCollection new.
    ]
    addRide: aRide [ assignedRides add: aRide ]
    getDriverInfo [
        | cents |
        cents := (rating * 10) rounded.
        Transcript showCr: 'Driver ', driverID printString, ' ', name,
            ' (', (cents // 10) printString, '.', (cents \\ 10) printString, ')',
            ' - ', assignedRides size printString, ' rides'.
        assignedRides do: [ :r | Transcript show: '  '. r rideDetails ].
    ]
]

Object subclass: Rider [
    | riderID name requestedRides |

    Rider class >> id: anID name: n [
        | r | r := self new. r setID: anID name: n. ^r
    ]
    setID: anID name: n [
        riderID := anID. name := n. requestedRides := OrderedCollection new.
    ]
    requestRide: aRide [ requestedRides add: aRide ]
    viewRides [
        Transcript showCr: 'Rider ', riderID printString, ' ', name,
            ' - ', requestedRides size printString, ' rides'.
        requestedRides do: [ :r | Transcript show: '  '. r rideDetails ].
    ]
]

"--- Demo ---"
| r1 r2 r3 allRides d1 p1 |
r1 := StandardRide id: 101 pickup: 'Downtown' dropoff: 'Airport' distance: 12.5.
r2 := PremiumRide id: 102 pickup: 'Uptown' dropoff: 'Stadium' distance: 8.0 luxuryFee: 5.0.
r3 := StandardRide id: 103 pickup: 'Mall' dropoff: 'University' distance: 5.2.

allRides := OrderedCollection new.
allRides add: r1; add: r2; add: r3.

Transcript showCr: '-- All Rides --'.
allRides do: [ :r | r rideDetails ]. "polymorphic dispatch"

d1 := Driver id: 201 name: 'Alex Johnson' rating: 4.9.
d1 addRide: r1; addRide: r2.

p1 := Rider id: 301 name: 'Priya Nair'.
p1 requestRide: r1; requestRide: r3.

Transcript showCr: ''; showCr: '-- Driver --'.
d1 getDriverInfo.

Transcript showCr: ''; showCr: '-- Rider --'.
p1 viewRides.