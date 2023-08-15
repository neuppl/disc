%{
  open Syntax
%}

/* Tokens */
%token EOF
%token PLUS MINUS MULTIPLY DIVIDE MODULUS
%token LT LTE GT GTE EQUAL_TO NEQ EQUAL LEFTSHIFT RIGHTSHIFT
%token AND OR NOT DISCRETE IFF XOR SAMPLE
%token LPAREN RPAREN
%token IF THEN ELSE TRUE FALSE IN INT
%token SEMICOLON COMMA COLON
%token LET OBSERVE FLIP LBRACE RBRACE FST SND FUN BOOL ITERATE UNIFORM BINOMIAL
%token LIST LBRACKET RBRACKET CONS HEAD TAIL LENGTH BIND

%token <int>    INT_LIT
%token <string> FLOAT_LIT
%token <string> ID

/* associativity rules */
%left OR
%left AND
%left NOT
%left IFF
%left XOR
%left LTE GTE LT GT NEQ
%right CONS
%left PLUS MINUS EQUAL_TO LEFTSHIFT RIGHTSHIFT
%left MULTIPLY DIVIDE MODULUS
/* entry point */

%start program
%type <Syntax.program> program

%%
num:
    | FLOAT_LIT { (Bignum.of_string $1) }
    | INT_LIT { (Bignum.of_int $1) }
    | INT_LIT DIVIDE INT_LIT { Bignum.($1 // $3) }

expr:
    | (* (e) *) delimited(LPAREN, expr, RPAREN) { $1 }
    | TRUE { True({startpos=$startpos; endpos=$endpos}) }
    | FALSE { False({startpos=$startpos; endpos=$endpos}) }
    | (* (e, e) *)
      delimited(LPAREN, separated_pair(expr, COMMA, expr), RPAREN) { Tup({startpos=$startpos; endpos=$endpos}, fst $1, snd $1) }
    | FST expr { Fst({startpos=$startpos; endpos=$endpos}, $2) }
    | SND expr { Snd({startpos=$startpos; endpos=$endpos}, $2) }
    | (* x *)ID { Ident({startpos=$startpos; endpos=$endpos}, $1) }
    | (* e && e *) expr AND expr { And({startpos=$startpos; endpos=$endpos}, $1, $3) }
    | (* e || e *) expr OR expr { Or({startpos=$startpos; endpos=$endpos}, $1, $3) }
    | (* !e *) NOT expr { Not({startpos=$startpos; endpos=$endpos}, $2) }
    | (* flip num *) FLIP LPAREN num RPAREN { Flip({startpos=$startpos; endpos=$endpos}, $3) }
    | (* observe e *) OBSERVE expr { Observe({startpos=$startpos; endpos=$endpos}, $2) }
    | (* if e then e else e *) IF expr THEN expr ELSE expr { Ite({startpos=$startpos; endpos=$endpos}, $2, $4, $6) }
    | (* x <- e; e *)
      ID BIND expr SEMICOLON expr { Bind({startpos=$startpos; endpos=$endpos}, $1, $3, $5) }


program:
  body=expr; EOF { { body=body } }
