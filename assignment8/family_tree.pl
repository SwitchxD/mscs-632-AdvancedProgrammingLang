% ============================================================
% family_tree.pl
% Simple Family Tree Program in Prolog
%
% Implements:
%   - Basic facts: parent/2, male/1, female/1
%   - Derived rules: grandparent/2, sibling/2, cousin/2
%   - Recursive rule: descendant/2 (all indirect descendants)
%   - Helper predicates that collect results into lists so a
%     single query can answer "who are all of X's ...?"
% ============================================================

% ------------------------------------------------------------
% 1. FACTS
% ------------------------------------------------------------
% parent(Parent, Child) - Parent is a parent of Child.

parent(john, mary).
parent(john, mike).
parent(susan, mary).
parent(susan, mike).

parent(mary, ann).
parent(mary, tom).
parent(david, ann).
parent(david, tom).

parent(mike, lucy).
parent(mike, paul).
parent(karen, lucy).
parent(karen, paul).

parent(ann, ella).
parent(brian, ella).

% Gender facts, used to derive gendered relationships later
% (father/mother, brother/sister, etc. if needed).

male(john).
male(mike).
male(david).
male(tom).
male(paul).
male(brian).

female(susan).
female(mary).
female(ann).
female(karen).
female(lucy).
female(ella).

% ------------------------------------------------------------
% 2. DERIVED RELATIONSHIPS (RULES)
% ------------------------------------------------------------

% grandparent(X, Y) - X is a grandparent of Y.
% True if X is the parent of some person Z, and Z is in turn
% the parent of Y (two "parent" hops).
grandparent(X, Y) :-
    parent(X, Z),
    parent(Z, Y).

% sibling(X, Y) - X and Y are siblings.
% True if some person P is a parent of both X and Y, and X and
% Y are not the same person (a person is not their own sibling).
sibling(X, Y) :-
    parent(P, X),
    parent(P, Y),
    X \== Y.

% cousin(X, Y) - X and Y are (first) cousins.
% True if X's parent and Y's parent are siblings of each other.
cousin(X, Y) :-
    parent(PX, X),
    parent(PY, Y),
    sibling(PX, PY),
    X \== Y.

% ------------------------------------------------------------
% 3. RECURSIVE RULE: DESCENDANT
% ------------------------------------------------------------
% descendant(X, Y) - X is a descendant of Y, at any depth
% (child, grandchild, great-grandchild, and so on).
%
% Base case:
%   X is a descendant of Y if X is a direct child of Y.
% Recursive case:
%   X is a descendant of Y if X is a child of some Z, and Z is
%   itself a descendant of Y. This lets the rule walk down the
%   tree an arbitrary number of generations.

descendant(X, Y) :-
    parent(Y, X).

descendant(X, Y) :-
    parent(Y, Z),
    descendant(X, Z).

% ------------------------------------------------------------
% 4. QUERY HELPERS
% ------------------------------------------------------------
% These use findall/3 to collect ALL matching answers into a
% single list, so one query returns a complete answer instead
% of requiring the user to backtrack through results one by one.
%
% list_to_set/2 removes duplicates. Duplicates can occur, for
% example, when two people share more than one parent in
% common (e.g. mary and mike share both john and susan), which
% would otherwise cause sibling/2 and cousin/2 to succeed more
% than once for the same pair.

% children_of(Person, Children) - all children of Person.
children_of(Person, Children) :-
    findall(C, parent(Person, C), Children).

% siblings_of(Person, Siblings) - all siblings of Person.
siblings_of(Person, Siblings) :-
    findall(S, sibling(Person, S), Raw),
    list_to_set(Raw, Siblings).

% cousins_of(Person, Cousins) - all first cousins of Person.
cousins_of(Person, Cousins) :-
    findall(C, cousin(Person, C), Raw),
    list_to_set(Raw, Cousins).

% descendants_of(Person, Descendants) - all descendants of
% Person, at any depth (uses the recursive descendant/2 rule).
descendants_of(Person, Descendants) :-
    findall(D, descendant(D, Person), Descendants).

% ------------------------------------------------------------
% End of file
% ------------------------------------------------------------