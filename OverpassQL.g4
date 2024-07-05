grammar OverpassQL;

// Parser rules

main: statement* EOF;

statement
    : if_statement
    | foreach_statement
    | for_statement
    | complete_statement
    | retro_statement
    |   ( union_statement
        | difference_statement
        | compare_statement
        | out_statement
        | item_statement
        | recurse_statement
        | is_in_statement
        | timeline_statement
        | local_statement
        | convert_statement
        | make_statement
        | query_statement
        | map_to_area_statement
        ) ';';

// Union statement
union_statement: '(' statement+ ')' output_set_specifier?;

// Difference statement
difference_statement: '(' statement '-' statement ')' output_set_specifier?;

// If statement
if_statement: 'if' '(' expression ')' '{' statement* '}' ('else' '{' statement* '}')?;

// Foreach statement
foreach_statement: 'foreach' input_set_specifier? output_set_specifier? '{' statement* '}';

// For statement
for_statement: 'for' input_set_specifier? output_set_specifier? '(' expression ')' '{' statement* '}';

// Complete statement
complete_statement: 'complete' ('(' IntN0 ')')? input_set_specifier? output_set_specifier? '{' statement* '}';

// Retro statement
retro_statement: 'retro' '(' expression ')' '{' statement* '}';

// Compare statement
// TODO: why is this inconsistent with everything else?
compare_statement: input_set_specifier? 'compare' '(' ('delta' ':' expression)? ')' output_set_specifier? '{' statement* '}';

// Out statement
out_statement: input_set_specifier? 'out' out_params*;

out_params
  : out_param_verbosity 
  | out_param_noid
  | out_param_geoinfo
  | out_param_bbox
  | out_param_sort_order
  | out_param_limit
  ;

out_param_verbosity: 'ids' | 'skel' | 'body' | 'tags' | 'meta';
out_param_noid: 'noids';
out_param_geoinfo: 'geom' | 'bb' | 'center';
out_param_bbox: bounding_box_filter;
out_param_sort_order: 'asc' | 'qt';
out_param_limit: IntN0;

// Item statement
item_statement: set_id;

// Recurse statement
recurse_statement: input_set_specifier? ('<' | '<<' | '>' | '>>') output_set_specifier?;

// Is in statement
is_in_statement: input_set_specifier? 'is_in' ('('coordinate_pair ')')? output_set_specifier?;

// Timeline statement
timeline_statement: 'timeline' '(' object_type ',' IntN0 (',' IntN0)? ')' output_set_specifier?;


// Local statement
local_statement: input_set_specifier? 'local' localization_type? output_set_specifier?;

localization_type: 'll' | 'llb';

// Convert statement
convert_statement: 'convert' object_type convert_list_of_tags (',' convert_list_of_tags)*;

convert_list_of_tags
    : key_value '=' expression
    | '::' 'id' '=' expression
    | '::' '=' expression
    | '!' key_value
    ;

// Make statement
make_statement: 'make' object_type make_list_of_tags (',' make_list_of_tags)*;

make_list_of_tags
    : key_value '=' expression
    | special_field_prefix 'id' '=' expression
    | set_id '::' '=' expression
    | '!' key_value
    ;

// Query statement
query_statement: query_type filter+ output_set_specifier?;

query_type
    : 'node'
    | 'way'
    | 'relation'
    | 'rel'
    | 'n'
    | 'w'
    | 'r'
    | 'nwr'
    | 'nw'
    | 'nr'
    | 'wr'
    | 'derived'
    | 'area'
    ;

// TODO: map_to_area
// Map to area statement
map_to_area_statement: input_set_specifier? 'map_to_area' output_set_specifier?;

// Filters

filter
    : kv_filter
    | bounding_box_filter
    | recurse_filter
    | set_filter
    | element_id_filter
    | around_filter
    | polygon_filter
    | newer_filter
    | changed_filter
    | user_filter
    | area_filter
    | pivot_filter
    | conditional_filter
    ;

// KV filter
// The grammar for kv filters defined here is more lenient than strict OverpassQL and allows any combination of '!' and '~' for both key and value
kv_filter: '[' (kv_exists_filter | kv_match_filter) (',' kv_filter_options)? ']';

kv_exists_filter: '!'? '~'? key_value; // TODO: combine with kv match filter?

kv_match_filter: '!'? '~'? key_value '!'? ('=' | '~') key_value;

kv_filter_options: kv_case_insensitive_flag;

kv_case_insensitive_flag: 'i';

// Bounding box filter
bounding_box_filter: '(' number ',' number ',' number ',' number ')';

// Recurse filter
recurse_filter: '(' (recurse_member_filter | recurse_way_filter) ')';

recurse_member_filter: recurse_member_type input_set_specifier? recurse_role_restriction?;

recurse_member_type
    : 'w'
    | 'r'
    | 'bn'
    | 'bw'
    | 'br'
    ;

recurse_role_restriction: ':' String;

recurse_way_filter: ('way_cnt' | 'way_link') input_set_specifier? ':' IntN0 ('-' IntN0?)?;

// Set filter
set_filter: set_id;

// Element id filter
element_id_filter: '(' (IntN0 | 'id' ':' IntN0 (',' IntN0)*) ')';

// Around filter
around_filter: '(' 'around' input_set_specifier? ':' number  (',' coordinate_pair)* ')';

// Polygon filter
polygon_filter: '(' 'poly' ':' String ')';  // TODO: proper coordinate parsing

// Newer filter
newer_filter: '(' 'newer' ':' String ')';

// Changed filter
changed_filter: '(' 'changed' ':' String (',' String)? ')';

// User filter
user_filter: '(' (user_username_filter | user_uid_filter) ')';

user_username_filter: ('user' | 'user_touched') ':' String (',' String)*;
user_uid_filter: ('uid' | 'uid_touched') ':' IntN0 (',' IntN0)*;

// Area filter
area_filter: '(' 'area' (input_set_specifier | ':' IntN0)? ')';

// Area pivot filter
pivot_filter: '(' 'pivot' input_set_specifier? ')';

// Conditional filter
conditional_filter: '(' 'if' ':' expression ')';


// Evaluator expressions
expression
    : 
    | '(' expression ')'
    | literal_expression
    | tag_value_operator_expression
    | unary_operator_expression
    | expression binary_operator expression
    | expression '?' expression ':' expression
    ;

literal_expression: number | String;

// Element dependent operators

tag_value_operator_expression: 't' '[' expression ']';

// TODO: generic value operator ::

// TODO: is_tag(<Key name >)

// TODO: All Keys Evaluator keys()

// TODO: Id and Type of the Element id() type()

// TODO: Meta Data Operators
// version()
// timestamp()
// changeset()
// uid()
// user()

// TODO: Element Properties Count
// count_tags()
// count_members()
// count_distinct_members()
// count_by_role(<Evaluator>)
// count_distinct_by_role(<Evaluator>)


// Per Member Aggregators 

// TODO: per_member(<Evaluator>)
// TODO: per_vertex(<Evaluator>)


// Member Dependent Functions
// TODO:
// Position of the Member pos()
// Reference to the Member mtype() ref()
// Role of the Member role()
// Angle of a Way at the Position of a Member angle()


// Geometry Related Operators
// TODO:
// Closedness is_closed()
// Geometry geom()
// Length length()
// Latitude and Longitude lat() lon()


// Point evaluator
// TODO: pt(<latitude>, <longitude>)


// Linestring evaluator
// TODO: lstr(<Evaluator>, <Evaluator>[, ...])

// Polygon evaluator
// TODO: poly(<Evaluator>, <Evaluator>[, ...])


// Aggregators
// TODO:
// Union  [<Set>.]u(<Evaluator>)
// Set    [<Set>.]set(<Evaluator>)
// Min    [<Set>.]min(<Evaluator>)
// Max    [<Set>.]max(<Evaluator>)
// Sum    [<Set>.]sum(<Evaluator>)


// Statistical count
// TODO:
// [<Set>.]count(nodes)
// [<Set>.]count(ways)
// [<Set>.]count(relations)
// [<Set>.]count(deriveds)
// [<Set>.]count(nwr)
// [<Set>.]count(nw)
// [<Set>.]count(wr)
// [<Set>.]count(nr)

// Union of Geometry
// TODO: [<Set>.]gcat(<Evaluator>)


// Unary Operators
unary_operator_expression: unary_operator expression;

unary_operator
    : '!'
    | '-'
    ;

// Binary Operators
// TODO: precedence
binary_operator
    : '*'
    | '/'
    | '+'
    | '-'
    | '<'
    | '<' '='
    | '>'
    | '>' '='
    | '=='
    | '!='
    | '&&'
    | '||'
    ;


// String Endomorphisms
// TODO: <Function Name>(<Evaluator>)

// Number Check, Normalizer and Suffix
// TODO:
// number(<Evaluator>)
// is_number(<Evaluator>)
// suffix(<Evaluator>)

// Number Manipulation
// TODO:
// abs(<Evaluator>)

// Date Check and Normalizer
// TODO: 
// date(<Evaluator>)
// is_date(<Evaluator>)


// Geometry Endomorphisms
// TODO: <Function Name>(<Evaluator>)
// Center center(<Evaluator>)
// Trace trace(<Evaluator>)
// Hull hull(<Evaluator>)


// List Represented Set Operators

// List Represented Set Theoretic Operators
// TODO: 
// lrs_in(<Evaluator>, <Evaluator>)
// lrs_isect(<Evaluator>, <Evaluator>)
// lrs_union(<Evaluator>, <Evaluator>)

// List Represented Set Statistic Operators
// TODO:
// lrs_min(<Evaluator>)
// lrs_max(<Evaluator>)

// Set Key-Value Evaluator
// TODO: <Set>.<Property>


// Misc

object_type: object_type_long | object_type_short;
object_type_long: 'node' | 'way' | 'relation';
object_type_short: 'n' | 'w' | 'r' | 'rel';

input_set_specifier: set_id;
output_set_specifier: '->' set_id;

special_field_prefix: '::';
special_field_name: special_field_prefix key_value;

key_value: String | UnicodeId;

coordinate_pair: number ',' number;

number: int_z | Float;

int_z: '-'? IntN0;

// Terminals

set_id: '.' UnicodeId;


//------------------------------------
// Lexer rules
// Need to start with uppercase letter

UnicodeId : [\p{Alpha}\p{General_Category=Other_Letter}_] [\p{Alnum}\p{General_Category=Other_Letter}_]* ; // match full Unicode alphabetic ids

// TODO: escaping
// TODO: single quotes
String: '"' .*? '"';



fragment Digit: [0-9];
fragment DigitSequence: [0-9]+;

fragment Sign: [+-];

Float   : '-'? (DigitSequence? '.' DigitSequence
               | DigitSequence '.')
        ;

IntN0: Digit+;

// TODO: negative integer constants
// INT_Z: '-'? DIGIT+;



// Comments

BlockComment
    : '/*' .*? '*/' -> channel(HIDDEN)
    ;

LineComment
    : '//' ~[\r\n]* -> channel(HIDDEN)
    ;

// Whitespace

UnicodeWhitespace : [\p{White_Space}]+ -> channel(HIDDEN);
