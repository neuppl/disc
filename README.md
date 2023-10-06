A tiny discrete language.

## What's inside

* `bin/` defines the binary. You shouldn't need to change anything here.
* `lib`: contains the core of the codebase
  - `syntax.ml`: defines the external user-facing grammar, which is the parser target
  - `core_grammar.ml`: contains an internal grammar that is desugared from the external
    grammar. This is the main grammar that you will be interacting with. It has a function `subst` that lets you substitute expressions in for free variables in a superexpression. 
  - `lexer.mll` and `parser.mly`: these define the parser and lexer for the project using [menhir](https://dev.realworldocaml.org/parsing-with-ocamllex-and-menhir.html). You do 
  not need to edit these files for the project.
  - `enumerate.ml` is where you'll implement the exhaustive enumeration big-step semantics.
  - `kc.ml` is where you'll implement the Boolean compilation semantics.
  - `util.ml` contains various convenience utilities used across different parts of the library
* `programs/`: contains sample programs for you to tinker with.
* `tests/`: contains the test suite.

## Building

Make sure you have OCaml (<5.0.0), opam, and dune. They can be all installed through a package manager of your choice. 

opam dependencies: `menhir`, `ounit`, `qcheck`, `bignum`, `core`, `core_unix`, `rsdd`

After cloning, `cd` into the folder and run `opam install . --deps-only` to install dependencies. 

Then run `dune build`. If it gives errors on missing packages, install them using `opam install $PACKAGE_NAME`.

## Running

After you build using `dune build`, an executable will be available under `_build/`. Alternatively, you can also do `dune exec -- disc $FILE $FLAGS`.
Try it out with some of the sample programs in the `programs` folder, with no flags raised. It should say that the program parsed, but no inference strategy was selected. 

## Testing

After you implement both inference strategies, you can compare values using `dune test`. 

## **Syntax**

The top-level syntax is in monadic-style:

```
e ::=
   | x <- e; e
   | observe e; e
   | flip q                         // q is a rational value
   | if e then e else e
   | return e
   | true | false
   | e && e | e || e | ! e |
   | ( e )

p ::= e
```
