A tiny discrete language.

# Building

Make sure you have OCaml (<5.0.0), opam, dune. They can be all installed through a package manager of your choice. 

opam dependencies: menhir, ounit, qcheck, bignum, core, core_unix

After cloning, `cd` into the folder and run `dune build`.

# **Syntax**

The top-level syntax is in monadic-style:

```
e ::=
   | x <- e; e
   | observe e; e
   | flip q                         // q is a rational value
   | if e then e else e
   | return e
   | true | false
   | e && e | e && e | ! e |
   | ( e )

p ::= e
```
