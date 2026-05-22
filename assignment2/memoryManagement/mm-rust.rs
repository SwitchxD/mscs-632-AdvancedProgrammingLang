fn main() {
    // Ownership: value moves, original is invalid
    let s1 = String::from("hello");
    let s2 = s1;
    // println!("{}", s1); // would not compile: s1 moved
    println!("Ownership moved to s2: {}", s2);

    // Borrowing: lend without transferring ownership
    let s3 = String::from("world");
    print_str(&s3);
    println!("s3 still valid after borrow: {}", s3);

    // Box: heap allocation, freed automatically when out of scope
    let boxed = Box::new(42);
    println!("Boxed value: {}", boxed);
    // memory freed here when boxed goes out of scope
}

fn print_str(s: &String) {
    println!("Borrowed: {}", s);
}