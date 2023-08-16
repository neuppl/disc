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
   | (e, e) | fst e | snd e
   | true | false
   | e and e | e or e | ! e |

p ::= e
```
