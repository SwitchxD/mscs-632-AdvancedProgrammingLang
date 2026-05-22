#include <iostream>
using namespace std;

int main() {
    // Manual allocation
    int* ptr = new int(99);
    cout << "Allocated value: " << *ptr << "\n";
    delete ptr;
    ptr = nullptr;
    cout << "Memory freed manually\n";

    // Array allocation
    int* arr = new int[5]{1, 2, 3, 4, 5};
    cout << "Array: ";
    for (int i = 0; i < 5; i++) cout << arr[i] << " ";
    cout << "\n";
    delete[] arr;
    arr = nullptr;
    cout << "Array memory freed\n";

    // Dangling pointer demonstration (shown safely)
    int* dangling = new int(42);
    delete dangling;
    dangling = nullptr;
    cout << "Pointer set to nullptr after delete (safe practice)\n";

    return 0;
}