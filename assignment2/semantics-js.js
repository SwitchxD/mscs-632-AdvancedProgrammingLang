let x = "global";

function outer() {
    let x = "enclosing";
    function inner() {
        let x = "local";
        console.log("inner value of x:", x);
    }
    inner();
    console.log("outer value of x:", x);
}
outer();
console.log("global value of x:", x);

function makeCounter() {
    let count = 0;
    return function() {
        count += 1;
        return count;
    };
}

const counter = makeCounter();
console.log(counter());
console.log(counter());
console.log(counter());

const staticLoop = [];
for (var i = 0; i < 4; i++) staticLoop.push(() => i);
console.log("loop1:", staticLoop.map(f => f()));

const dynamicLoop = [];
for (let j = 0; j < 4; j++) dynamicLoop.push(() => j);
console.log("loop2:", dynamicLoop.map(f => f()));