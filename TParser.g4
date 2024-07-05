parser grammar TParser;

options {
	tokenVocab = TLexer;
}

// These are all supported parser sections:

// Parser file header. Appears at the top in all parser related files. Use e.g. for copyrights.
@parser::header {/* parser/listener/visitor header section */}

// Appears before any #include in h + cpp files.
@parser::preinclude {/* parser precinclude section */}

// Follows directly after the standard #includes in h + cpp files.
@parser::postinclude {
/* parser postinclude section */
#ifndef _WIN32
#pragma GCC diagnostic ignored "-Wunused-parameter"
#endif
}

// Directly preceeds the parser class declaration in the h file (e.g. for additional types etc.).
@parser::context {/* parser context section */}

// Appears in the private part of the parser in the h file.
// The function bodies could also appear in the definitions section, but I want to maximize
// Java compatibility, so we can also create a Java parser from this grammar.
// Still, some tweaking is necessary after the Java file generation (e.g. bool -> boolean).
@parser::members {
/* public parser declarations/members section */
bool myAction() { return true; }
bool doesItBlend() { return true; }
void cleanUp() {}
void doInit() {}
void doAfter() {}
}

// Appears in the public part of the parser in the h file.
@parser::declarations {/* private parser declarations section */}

// Appears in line with the other class member definitions in the cpp file.
@parser::definitions {/* parser definitions section */}

// Additionally there are similar sections for (base)listener and (base)visitor files.
@parser::listenerpreinclude {/* listener preinclude section */}
@parser::listenerpostinclude {/* listener postinclude section */}
@parser::listenerdeclarations {/* listener public declarations/members section */}
@parser::listenermembers {/* listener private declarations/members section */}
@parser::listenerdefinitions {/* listener definitions section */}

@parser::baselistenerpreinclude {/* base listener preinclude section */}
@parser::baselistenerpostinclude {/* base listener postinclude section */}
@parser::baselistenerdeclarations {/* base listener public declarations/members section */}
@parser::baselistenermembers {/* base listener private declarations/members section */}
@parser::baselistenerdefinitions {/* base listener definitions section */}

@parser::visitorpreinclude {/* visitor preinclude section */}
@parser::visitorpostinclude {/* visitor postinclude section */}
@parser::visitordeclarations {/* visitor public declarations/members section */}
@parser::visitormembers {/* visitor private declarations/members section */}
@parser::visitordefinitions {/* visitor definitions section */}

@parser::basevisitorpreinclude {/* base visitor preinclude section */}
@parser::basevisitorpostinclude {/* base visitor postinclude section */}
@parser::basevisitordeclarations {/* base visitor public declarations/members section */}
@parser::basevisitormembers {/* base visitor private declarations/members section */}
@parser::basevisitordefinitions {/* base visitor definitions section */}

// Actual grammar start.
main: statement* EOF;

statement: 
  ( settings_st
  | item_st 
  | union_st 
  | diff_st
  | query_st 
  | out_st 
  | map_to_area_st 
  | recurse_st
  | if_st
  | foreach_st
  | for_st
  | complete_st
  | is_in_st
  | timeline_st
  | local_st
  | convert_st
  | make_st
  | retro_st
  | compare_st
  ) Semicolon;

settings_st: setting_st+ Semicolon;

setting_st: OpenBracket UNICODE_ID Colon (exp_literal | UNICODE_ID) CloseBracket;

// query_st: type_specifier filter+ output_set_specifier?;
query_st: (UNICODE_ID | Area) filter+ output_set_specifier?;

filter
  : has_kv_filter 
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

// query_filter: conditional_filter;

// TODO: case insensitive switch not supported
has_kv_filter: OpenBracket (has_kv_filter_equals | has_kv_filter_regex | exists_filter) CloseBracket; // TODO: [~"foo"~"bar"] not yet supported

has_kv_filter_equals: key_value (Not Equal | Equal) key_value; // TODO: [~"foo"~"bar"] not yet supported

has_kv_filter_regex: key_value (Not Tilde | Tilde) key_value; // TODO: [~"foo"~"bar"] not yet supported

key_value: String | UNICODE_ID;

exists_filter: Not? key_value;

bounding_box_filter: OpenPar bbox ClosePar;

recurse_filter: OpenPar (recurse_filter_member | recurse_filter_way) ClosePar;

recurse_filter_member: recurse_type set_id? recurse_role_restriction?;

// recurse_forward_type: WayChar | RelationChar;

// recurse_backward_type: RecurseBackwards (NodeChar | WayChar | RelationChar);

recurse_type: UNICODE_ID; //recurse_forward_type | recurse_backward_type;

recurse_role_restriction: Colon String;

recurse_filter_way: (WayCnt | WayLink) set_id? Colon INT (Minus INT?)?;

set_filter: set_id;

element_id_filter: OpenPar (INT | IdLit Colon INT (Comma INT)*) ClosePar;

around_filter: OpenPar Around set_id? Colon radius (Comma coordinate_pair)* ClosePar;

radius: number;

polygon_filter: OpenPar Poly Colon String ClosePar; // TODO: proper coordinate parsing

newer_filter: OpenPar Newer Colon String ClosePar;

changed_filter: OpenPar Changed Colon String (Comma String)? ClosePar;

user_filter: OpenPar (user_filter_last | user_filter_touched) ClosePar;

// TODO: area filter and recurse filter are ambiguous without any keywords if both use arbitrary IDs
// e.g. node(area); vs. node(w);
// -> move to combined grammar (lexer/parser)?
area_filter: OpenPar Area set_id? ClosePar;

pivot_filter: OpenPar Pivot set_id? ClosePar;

conditional_filter: OpenPar If Colon expression ClosePar;

user_filter_last: (User Colon username_list | Uid Colon uid_list);
user_filter_touched: (UserTouched Colon username_list | UidTouched Colon uid_list);

username_list: String (Comma String)*;
uid_list: INT (Comma INT)*;


coordinate_pair: FLOAT Comma FLOAT;

out_st: input_set_specifier? Out out_st_params*;

out_st_params
  : out_st_param_verbosity 
  | out_st_param_noid
  | out_st_param_geoinfo
  | out_st_param_bbox
  | out_st_param_sort_order
  | out_st_param_limit
  ;

out_st_param_verbosity: (Ids | Skel | Body | Tags | Meta);
out_st_param_noid: Noid;
out_st_param_geoinfo: Geom | Bb | Center;
out_st_param_bbox: bounding_box_filter;
out_st_param_sort_order: Asc | Qt;
out_st_param_limit: INT;

bbox: FLOAT Comma FLOAT Comma FLOAT Comma FLOAT;

map_to_area_st: MapToArea output_set_specifier?;

item_st: set_id;

recurse_st: input_set_specifier? (recurse_up_st | recurse_up_rel_st | recurse_down_st | recurse_down_rel_st) output_set_specifier?;

recurse_up_st: LessThan;
recurse_up_rel_st: LessThan LessThan;
recurse_down_st: GreaterThan;
recurse_down_rel_st: GreaterThan GreaterThan;

is_in_st: input_set_specifier? IsIn (OpenPar coordinate_pair ClosePar)? output_set_specifier?;

timeline_st: Timeline OpenPar ClosePar output_set_specifier?;

local_st: Local (Ll | Llb)?;

convert_st: Convert;

make_st: Make;

union_st: OpenPar statement* ClosePar output_set_specifier?;
diff_st: OpenPar statement Minus statement ClosePar output_set_specifier?;

if_st: If OpenPar expression ClosePar OpenCurly statement* CloseCurly;

// TODO: older versions of overpass ql used normal parentheses for block?
foreach_st: Foreach input_set_specifier? output_set_specifier? OpenCurly statement* CloseCurly;

for_st: For input_set_specifier? output_set_specifier? OpenPar expression ClosePar OpenCurly statement* CloseCurly;

complete_st: Complete (OpenPar INT ClosePar)? input_set_specifier? output_set_specifier? OpenCurly statement* CloseCurly;

retro_st: Retro OpenPar expression ClosePar OpenCurly statement* CloseCurly;

compare_st: input_set_specifier? Compare OpenPar (Delta Colon expression) ClosePar output_set_specifier? (OpenCurly statement* CloseCurly)?;

input_set_specifier: set_id;
output_set_specifier: Minus GreaterThan set_id;

set_id: Period UNICODE_ID; // (ID | Underscore);

// type_specifier
//   : NodeChar
//   | Node
//   | WayChar
//   | Way 
//   | RelationChar
//   | RelationShort
//   | Relation 
//   | type_short_combined 
//   | Area 
//   | Derived
//   ;

// type_short_combined: NWR | NW | NR | WR;

expression
  : exp_literal 
  | exp_aggregator_function 
  | exp_container_accessor 
  | exp_unary_op
  | expression exp_binary_op_func expression // ANTLR handles direct left recursion
  | expression QuestionMark expression Colon expression;

exp_literal: INT | FLOAT | String;

exp_aggregator_function: (UNICODE_ID Period)? UNICODE_ID OpenPar (expression (Comma expression)*)? ClosePar;

exp_container_accessor: UNICODE_ID OpenBracket expression CloseBracket;

exp_unary_op: (Not | Minus) expression;

// TODO: fix left recursion

exp_ternary_op: expression QuestionMark expression Colon expression;

exp_binary_op_func
  : Star 
  | Plus 
  | Minus 
  | Equal Equal
  | Not Equal 
  | LessThan 
  | LessThan Equal 
  | GreaterThan 
  | GreaterThan Equal
  ;

number: INT | FLOAT;
