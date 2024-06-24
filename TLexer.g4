lexer grammar TLexer;

// These are all supported lexer sections:

// Lexer file header. Appears at the top of h + cpp files. Use e.g. for copyrights.
@lexer::header {/* lexer header section */}

// Appears before any #include in h + cpp files.
@lexer::preinclude {/* lexer precinclude section */}

// Follows directly after the standard #includes in h + cpp files.
@lexer::postinclude {
/* lexer postinclude section */
#ifndef _WIN32
#pragma GCC diagnostic ignored "-Wunused-parameter"
#endif
}

// Directly preceds the lexer class declaration in the h file (e.g. for additional types etc.).
@lexer::context {/* lexer context section */}

// Appears in the public part of the lexer in the h file.
@lexer::members {/* public lexer declarations section */
bool canTestFoo() { return true; }
bool isItFoo() { return true; }
bool isItBar() { return true; }

void myFooLexerAction() { /* do something*/ };
void myBarLexerAction() { /* do something*/ };
}

// Appears in the private part of the lexer in the h file.
@lexer::declarations {/* private lexer declarations/members section */}

// Appears in line with the other class member definitions in the cpp file.
@lexer::definitions {/* lexer definitions section */}

channels { CommentsChannel, DirectiveChannel }

tokens {
	DUMMY
}

NodeChar: 'n';
WayChar: 'w';
RelationChar: 'r';

RelationShort: 'rel';

Node: 'node';
Way: 'way';
Relation: 'relation';

// Rel: 'rel';

// N: 'n';
// W: 'w';
// R: 'r';

NWR: 'nwr';
NW: 'nw';
NR: 'nr';
WR: 'wr';

Area: 'area';
Derived: 'derived';

// RecurseBackwards: 'b';

WayCnt: 'way_cnt';
WayLink: 'way_link';

Out: 'out';

IdLit: 'id';


Around: 'around';
Poly: 'poly';
Newer: 'newer';
Changed: 'changed';
User: 'user';
Uid: 'uid';
UserTouched: 'user_touched';
UidTouched: 'uid_touched';
Pivot: 'pivot';
If: 'if';
For: 'for';
Foreach: 'foreach';
Complete: 'complete';
Retro: 'retro';
Compare: 'compare';

Delta: 'delta';

// Out
Ids: 'ids';
Skel: 'skel';
Body: 'body';
Tags: 'tags';
Meta: 'meta';

Noid: 'noid';

Geom: 'geom';
Bb: 'bb';
Center: 'center';

Asc: 'asc';
Qt: 'qt';

MapToArea: 'map_to_area';
IsIn: 'is_in';
Timeline: 'timeline';
Local: 'local';
Convert: 'convert';
Make: 'make';

Ll: 'll';
Llb: 'llb';

// Return: 'return';
// Continue: 'continue';

fragment DIGIT: [0-9];
INT: DIGIT+;

FLOAT   : DIGIT+ '.' DIGIT*
        | '.' DIGIT+
        ;





LessThan: '<';
GreaterThan:  '>';
Equal: '=';
// Unequal: '!=';
Tilde: '~';
// NotTilde: '!~';
// And: 'and';

Not: '!';

// ExclamationMark: '!';

Period: '.';
Colon: ':';
Semicolon: ';';
Plus: '+';
Minus: '-';
Star: '*';
Underscore: '_';
OpenPar: '(';
ClosePar: ')';
OpenCurly: '{';
CloseCurly: '}';
OpenBracket: '[';
CloseBracket: ']';
QuestionMark: '?';
Comma: ',';
// Comma: ',' -> skip;
// Dollar: '$' -> more, mode(Mode1);
// Ampersand: '&' -> type(DUMMY);

ID: LETTER (LETTER | '0'..'9')*;
fragment LETTER : [a-zA-Z\u0080-\u{10FFFF}];

UNICODE_ID : [\p{Alpha}\p{General_Category=Other_Letter}] [\p{Alnum}\p{General_Category=Other_Letter}]* ; // match full Unicode alphabetic ids

String: '"' .*? '"';
// Foo: {canTestFoo()}? 'foo' {isItFoo()}? { myFooLexerAction(); };
// Bar: 'bar' {isItBar()}? { myBarLexerAction(); };
// Any: Foo Dot Bar? DotDot Baz;

// Comment : '#' ~[\r\n]* '\r'? '\n' -> channel(CommentsChannel);
// WS: [ \t\r\n]+ -> channel(99);

BlockComment
    : '/*' .*? '*/' -> channel(CommentsChannel)
    ;

LineComment
    : '//' ~[\r\n]* -> channel(CommentsChannel)
    ;

UNICODE_WS : [\p{White_Space}] -> skip; // match all Unicode whitespace


// fragment Baz: 'Baz';

// mode Mode1;
// Dot: '.';

// mode Mode2;
// DotDot: '..';
