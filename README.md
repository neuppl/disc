# Syntax

The top-level syntax is in monadic-style:

```
t ::=
   | type t = t_1 | t_2 | ... | t_n

e ::= 
   | x <- e; e
   | observe e
   | flip q                         // q is a rational value
   | int_dist [0 -> q_1, 1 -> q_2, ..., n -> q_n]
   | discrete [t_1 -> q_1, t_2 -> q_2, ..., t_n -> q_n]
   | match e with v_1 -> e_1 | v_2 -> e_2 | ... | v_n -> e_n
   | return e
   | if e then e else e
   | (e, e) | fst e | snd e
   | let x = e in e
   | \x -> e
   | true | false | int
   | e and e | e or e | not e | 
   | e + e | e - e | e * e | e / e | e % e

p ::= 
   t_1; t_2; ...; t_n;
   e
```
