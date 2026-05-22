x = "global"

def outer():
    x = "enclosing"
    def inner():
        x = "local"
        print("inner value of x:", x)
    inner()
    print("outer value of x:", x)

outer()
print("global value of x:", x)

def make_counter():
    count = 0
    def increment():
        nonlocal count
        count += 1
        return count
    return increment

counter = make_counter()
print(counter())
print(counter())
print(counter())

funcs = [lambda i=i: i * i for i in range(4)]
print([f() for f in funcs])