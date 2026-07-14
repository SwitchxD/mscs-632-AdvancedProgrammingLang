#include <iostream>
#include <string>
#include <vector>
#include <memory>
using namespace std;

// Base class
class Ride {
private:
    int rideID;
    string pickup, dropoff;
    double distance;

public:
    Ride(int id, string p, string d, double dist)
        : rideID(id), pickup(p), dropoff(d), distance(dist) {}
    virtual ~Ride() {}

    int getRideID() const { return rideID; }
    double getDistance() const { return distance; }

    virtual double fare() const { return distance * 1.5; }
    virtual string rideType() const { return "Generic"; }

    virtual void rideDetails() const {
        cout << "Ride " << rideID << " [" << rideType() << "] "
             << pickup << " -> " << dropoff
             << " | " << distance << " mi | $" << fare() << endl;
    }
};

// Derived classes (inheritance + polymorphism)
class StandardRide : public Ride {
public:
    StandardRide(int id, string p, string d, double dist) : Ride(id, p, d, dist) {}
    double fare() const override { return 2.0 + getDistance() * 1.75; }
    string rideType() const override { return "Standard"; }
};

class PremiumRide : public Ride {
private:
    double luxuryFee;
public:
    PremiumRide(int id, string p, string d, double dist, double fee = 5.0)
        : Ride(id, p, d, dist), luxuryFee(fee) {}
    double fare() const override { return 4.0 + getDistance() * 3.25 + luxuryFee; }
    string rideType() const override { return "Premium"; }
};

// Driver class (encapsulation)
class Driver {
private:
    int driverID;
    string name;
    double rating;
    vector<shared_ptr<Ride>> assignedRides;

public:
    Driver(int id, string n, double r) : driverID(id), name(n), rating(r) {}
    void addRide(shared_ptr<Ride> r) { assignedRides.push_back(r); }
    void getDriverInfo() const {
        cout << "Driver " << driverID << " " << name << " (" << rating << ")"
             << " - " << assignedRides.size() << " rides" << endl;
        for (auto& r : assignedRides) { cout << "  "; r->rideDetails(); }
    }
};

// Rider class (encapsulation)
class Rider {
private:
    int riderID;
    string name;
    vector<shared_ptr<Ride>> requestedRides;

public:
    Rider(int id, string n) : riderID(id), name(n) {}
    void requestRide(shared_ptr<Ride> r) { requestedRides.push_back(r); }
    void viewRides() const {
        cout << "Rider " << riderID << " " << name
             << " - " << requestedRides.size() << " rides" << endl;
        for (auto& r : requestedRides) { cout << "  "; r->rideDetails(); }
    }
};

int main() {
    auto r1 = make_shared<StandardRide>(101, "Downtown", "Airport", 12.5);
    auto r2 = make_shared<PremiumRide>(102, "Uptown", "Stadium", 8.0);
    auto r3 = make_shared<StandardRide>(103, "Mall", "University", 5.2);

    vector<shared_ptr<Ride>> allRides = {r1, r2, r3};
    cout << "-- All Rides --" << endl;
    for (auto& r : allRides) r->rideDetails(); // polymorphic dispatch

    Driver d1(201, "Alex Johnson", 4.9);
    d1.addRide(r1);
    d1.addRide(r2);

    Rider p1(301, "Priya Nair");
    p1.requestRide(r1);
    p1.requestRide(r3);

    cout << "\n-- Driver --" << endl;
    d1.getDriverInfo();

    cout << "\n-- Rider --" << endl;
    p1.viewRides();

    return 0;
}