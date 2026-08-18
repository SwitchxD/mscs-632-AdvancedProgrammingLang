# Family Tree Program in Prolog

Prolog knowledge base with `parent`/`male`/`female` facts, derived
rules for `grandparent`, `sibling`, and `cousin`, and a recursive
`descendant` rule.

## Requirements

SWI-Prolog (tested on 9.0.4) — https://www.swi-prolog.org/Download.html

```bash
# Ubuntu/Debian/WSL
sudo apt-get install -y swi-prolog

# macOS
brew install swi-prolog
```

## Run

```bash
swipl family_tree.pl
```

This loads the program and drops you at the `?-` prompt. Type a
query ending in `.` and press Enter. Exit with `halt.`

Alternative one-off command (no interactive prompt):
```bash
swipl -q -g "consult('family_tree.pl'), children_of(mary, C), writeln(C), halt."
```

## Family Tree

```
        john  +  susan
           |       |
       -----------------
       |               |
      mary + david     mike + karen
       |      |          |      |
     -----             -------
     |    |            |      |
    ann   tom         lucy   paul
     |
   (+brian)
     |
    ella
```

## Predicates

| Predicate | Meaning |
|---|---|
| `grandparent(X, Y)` | X is a grandparent of Y |
| `sibling(X, Y)` | X and Y share a parent |
| `cousin(X, Y)` | X and Y's parents are siblings |
| `descendant(X, Y)` | X is a descendant of Y, any depth (recursive) |
| `children_of/siblings_of/cousins_of/descendants_of(Person, List)` | all matches as a list |

## Sample Queries (verified output)

```prolog
?- children_of(mary, C).
C = [ann, tom].

?- siblings_of(mary, S).
S = [mike].

?- grandparent(john, ann).
true.

?- cousin(tom, paul).
true.

?- cousins_of(tom, Cs).
Cs = [lucy, paul].

?- descendants_of(john, D).
D = [mary, mike, ann, tom, ella, lucy, paul].

?- descendant(ella, john).
true.
```