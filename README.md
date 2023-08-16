A tiny discrete language.

# Syntax

The top-level syntax is in monadic-style:

```
e ::=
   | x <- e; e
   | observe e
   | flip q                         // q is a rational value
   | if e then e else e
   | return e
   | true | false
   | e && e | e && e | ! e |
   | ( e )

p ::= e
```
