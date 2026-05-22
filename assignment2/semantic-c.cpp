#include <iostream>
#include <vector>
#include <functional>
using namespace std;

int main() {
    int x = 10;
    {
        int x = 20;
        cout << "inner value of x: " << x << "\n";
    }
    cout << "outer value of x: " << x << "\n";

    int base = 5;
    auto byValue = [base]()  { return base * 2; };
    auto byRef   = [&base]() { return base * 2; };

    base = 10;
    cout << "byValue after change: " << byValue() << "\n";
    cout << "byRef   after change: " << byRef()   << "\n";

    int count = 0;
    auto increment = [&count]() { return ++count; };
    cout << increment() << "\n";
    cout << increment() << "\n";
    cout << increment() << "\n";

    vector<function<int()>> funcs;
    for (int i = 0; i < 4; i++)
        funcs.push_back([i]() { return i * i; });
    for (auto& f : funcs) cout << f() << " ";
    cout << "\n";

    return 0;
}