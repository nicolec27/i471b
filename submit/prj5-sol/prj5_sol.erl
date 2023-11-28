-module(prj5_sol).
-include_lib("eunit/include/eunit.hrl").
-compile([nowarn_export_all, export_all]).

%---------------------------- Test Control ------------------------------
%% Enabled Tests
%%   comment out -define to deactivate test.
%%   alternatively, enclose deactivated tests within
%%   -if(false). and -endif. lines
%% Enable all tests before submission.
%% The skeleton file is distributed with all tests deactivated
%% by being enclosed within if(false) ... endif directives.

-if(false).  
-define(test_eval_num_expr, enabled).
-define(test_assoc_lookup, enabled).
-define(test_eval_expr_0, enabled).
-define(test_eval_expr_throw, enabled).
-define(test_eval_stmt_0, enabled).
-define(test_eval_stmt_throw, enabled).
-define(test_server_fn, enabled).
-endif.


%------------------------------ Utilities -------------------------------

% Given a format string containing printf-like specifiers like ~p,
% return string resulting from substituting terms from ArgsList for ~p
% specifiers.
%
% For example, format("values are ~p and ~p", [22, {a, 33}])
% will result in the string "values are 22 and {a,33}".
format(Fmt, ArgsList) ->
    lists:flatten(io_lib:format(Fmt, ArgsList)).

% DEBUGGING.
% Use the ?debugFmt(Fmt, ArgsList) macro to produce debugging output
% when running tests.  For example, 
%    ?debugFmt("values are ~p and ~p", [22, {a, 33}]) 
% will output the line
%    values are 22 and {a,33}


%----------------------- Arithmetic Expressions -------------------------

% The following exercises deal with arithmetic expressions.  An
% arithmetic expression is defined inductively as follows (the { }
% indicates erlang tuples):
%
%   Expr
%     : { leaf, NUMBER }      %NUMBER is an erlang number
%     | { id, ID }            %ID is an erlang atom
%     | { add, Expr, Expr }
%     | { sub, Expr, Expr }
%     | { mul, Expr, Expr }
%     | { uminus, Expr }
%     ;


%---------------------- Evaluate Numeric Expressions --------------------

% #1: 15-points

% Given an arithmetic expression Expr which is purely numeric (i.e. it
% does not contain any `id` sub-expressions), evaluate and return its
% numeric value.  If given an expression which is not a leaf, add,
% sub, mul or uminus produce an erlang:error({ bad_expr, Msg }) where
% Msg is a string describing the error.
%
% Hint: use the format() utility to format a detailed error message.
eval_num_expr(_Expr) ->
    'TODO'.

-ifdef(test_eval_num_expr).
eval_num_expr_test_() -> 
    [ { "num", ?_assert(eval_num_expr( {leaf, 42} ) =:= 42) },
      { "add", 
	?_assert(eval_num_expr({add, {leaf, 2}, {leaf, 42} }) =:= 44) },
      { "sub", 
	?_assert(eval_num_expr({sub, {leaf, 2}, {leaf, 42} }) =:= -40) },
      { "mul", 
	?_assert(eval_num_expr({mul, {leaf, 2}, {leaf, 42} }) =:= 84) },
      { "uminus", 
	?_assert(eval_num_expr({uminus, {leaf, 42} }) =:= -42) },
      { "complex", 
	?_assert(eval_num_expr({sub, { mul, {leaf, 2}, 
					 {add, {uminus, {leaf, 2}}, {leaf, 42} }
				       },
				       { leaf, 20 } } ) =:= 60) },
      { "id", ?_assertError({bad_expr, _}, eval_num_expr({id, a})) },
      { "assign", ?_assertError({bad_expr, _}, 
				eval_num_expr({assign, a, {leaf, 42}})) }
    ].
-endif. %test_eval_num_expr


%----------------------- Assoc List Lookup ------------------------------

% #2: 15-points

% Lookup the Value of Key in assoc list Assoc list containing
% { Key, Value } pairs.  If not found, return the result of
% calling DefaultFn().
%
% Hint: implement by wrapping lists:keyfind() and using a case
% to pattern-match on the result.
assoc_lookup(_Key, _Assoc, _DefaultFn) ->
    'TODO'.

% Lookup the Value of Key in assoc list Assoc list containing
% { Key, Value } pairs.  If not found, return 0.
%
% Hint: wrap assoc_lookup.
assoc_lookup_0(_Key, _Assoc) ->
    'TODO'.
				     
% Lookup the Value of Key in assoc list Assoc list containing
% { Key, Value } pairs.  If not found, throw an exception
% of the form { not_found Msg } where Msg is a string 
% describing the error.
%
% Hint: wrap assoc_lookup.
assoc_lookup_throw(_Key, _Assoc) ->
    'TODO'.

-ifdef(test_assoc_lookup).
assoc_lookup_test_() -> 
    Assoc = [ {a, 22}, {b, 33}, {a, 44}, {b, 55}, {c, 66} ],
    [ { "find_first_0", ?_assert(assoc_lookup_0(a, Assoc) =:= 22) },
      { "find_mid_0", ?_assert(assoc_lookup_0(b, Assoc) =:= 33) },
      { "find_last_0", ?_assert(assoc_lookup_0(c, Assoc) =:= 66) },
      { "find_fail_0", ?_assert(assoc_lookup_0(e, Assoc) =:= 0) },
      { "find_first_throw", ?_assert(assoc_lookup_throw(a, Assoc) =:= 22) },
      { "find_mid_throw", ?_assert(assoc_lookup_throw(b, Assoc) =:= 33) },
      { "find_last_throw", ?_assert(assoc_lookup_throw(c, Assoc) =:= 66) },
      { "find_fail_throw", 
	?_assertThrow({not_found, _}, assoc_lookup_throw(e, Assoc)) }
    ].
  
-endif.


%--------------------------- Evaluate Expressions -----------------------

% #3: 25-points
% Given a lookup function LookupFn, return a function Eval(Expr, Env)
% to evaluate expression Expr in environment Env.  Specifically, the
% returned Eval(Expr, Env) function should evaluate an unrestricted
% expression Expr which may contain `leaf`, `id` `add`, `sub`, `mul`,
% and `uminus` sub-expressions in an environment given by association
% list Env used to resolve `id` expressions using `LookupFn`.  The
% returned Eval() function should the result of evaluating Expr.  If
% Expr is not valid Expr, then Eval() should produce an erlang:error({
% bad_expr, Msg }) where Msg is a string describing the error.
%
% Hint: return fun Eval (Expr, Env) -> ... end where the body of
% Eval() is implemented using pattern matching on Expr and can
% make recursive calls to Eval().
make_expr_evaluator(_LookupFn) ->
    'TODO'.

% Return the result of evaluating Expr in environment given by
% assoc-list Env.  A sub-expression of Expr of the form {id, ID}
% where ID is not in Env should evaluate to 0.
%
% Hint: Implement as a wrapper around make_expr_evaluator().
% Note that you cannot refer to assoc_lookup_0 directly
% as that is simply an atom; instead use the syntax
% fun assoc_lookup_0/2.
eval_expr_0(_Expr, _Env) ->
    'TODO'.
    
% Return the result of evaluating Expr in environment given by
% assoc-list Env.  A sub-expression of Expr of the form {id, ID}
% where ID is not in Env should result in throwing an 
% exception { not_found, Msg } where Msg is a string describing
% the error.
%
% Hint: Implement as a wrapper around make_expr_evaluator().
eval_expr_throw(_Expr, _Env) ->
    'TODO'.

-ifdef(test_eval_expr_0).
eval_expr_0_test_() -> 
    Env1 = [{a, 2}, {x, 42}, {b, 2}, {x, 22}],
    [ { "num", ?_assert(eval_expr_0( {leaf, 42}, Env1 ) =:= 42) },
      { "id_ok", ?_assert(eval_expr_0( {id, b}, Env1 ) =:= 2) },
      { "id_default", ?_assert(eval_expr_0( {id, y}, Env1 ) =:= 0) },
      { "add", 
	?_assert(eval_expr_0({add, {id, b}, {id, x} }, Env1 ) 
		 =:= 44) },
      { "sub", 
	?_assert(eval_expr_0({sub, {id, b}, {id, x} }, Env1 ) 
		 =:= -40) },
      { "mul", 
	?_assert(eval_expr_0({mul, {id, b}, {id, x} }, Env1 ) 
		 =:= 84) },
      { "uminus", 
	?_assert(eval_expr_0({uminus, {id, x} }, Env1 ) =:= -42) },
      { "complex", 
	?_assert(eval_expr_0(
		   {sub, { mul, {id, b}, 
			   {add, {uminus, {id, b}}, {id, x} }
			 },
		         { leaf, 20 } }, Env1  ) 
		 =:= 60) },
      { "complex_0", 
	?_assert(eval_expr_0(
		   {sub, { mul, {id, b}, 
			   {add, {uminus, {id, b1}}, {id, x} }
			 },
		         { leaf, 20 } }, Env1  ) 
		 =:= 64) },
      { "assign", ?_assertError({bad_expr, _}, 
				eval_expr_0({assign, a, {leaf, 42}}, Env1)) }
    ].
-endif. %test_eval_expr_0


-ifdef(test_eval_expr_throw).
eval_expr_throw_test_() -> 
    Env1 = [{a, 2}, {x, 42}, {b, 2}, {x, 22}],
    [ { "num", ?_assert(eval_expr_throw( {leaf, 42}, Env1 ) =:= 42) },
      { "id_ok", ?_assert(eval_expr_throw( {id, b}, Env1 ) =:= 2) },
      { "id_throw", ?_assertThrow({not_found, _},
				  eval_expr_throw( {id, y}, Env1 )) }, 
      { "add", 
	?_assert(eval_expr_throw({add, {id, b}, {id, x} }, Env1 )
		 =:= 44) },
      { "sub", 
	?_assert(eval_expr_throw({sub, {id, b}, {id, x} }, Env1 ) 
		 =:= -40) },
      { "mul", 
	?_assert(eval_expr_throw({mul, {id, b}, {id, x} }, Env1 ) 
		 =:= 84) },
      { "uminus", 
	?_assert(eval_expr_throw({uminus, {id, x} }, Env1 ) =:= -42) },
      { "complex", 
	?_assert(eval_expr_throw(
		   {sub, { mul, {id, b}, 
			   {add, {uminus, {id, b}}, {id, x} }
			 },
		         { leaf, 20 } }, Env1  ) 
		 =:= 60) },
      { "complex", 
	?_assertThrow({not_found, _},
		      eval_expr_throw(
			{sub, { mul, {id, b}, 
				{add, {uminus, {id, y}}, {id, x} }
			      },
		         { leaf, 20 } }, Env1  ) 
		      =:= 60) },
      { "complex_throw", 
	?_assertThrow({ not_found, _ },
		      eval_expr_throw(
			{sub, { mul, {id, b}, 
				{add, {uminus, {id, b1}}, {id, x} }
			      },
		         { leaf, 20 } }, Env1  )) },
      { "assign", 
	?_assertError({bad_expr, _}, 
		      eval_expr_throw({assign, a, {leaf, 42}}, Env1)) }
    ].
-endif. %test_eval_expr_throw

%-------------------------------- Eval Stmt -----------------------------

% #4: 15-points
% A statement is an assignment statement or an Expr.
%
%   Stmt
%    : { assign, ID, Expr } 
%    | Expr
%    ;

% Given an expression evaluator ExprEval(Expr, Env), return a function
% StmtEval(Stmt, Env) which returns the result of evaluating statement
% Stmt.  
% 
%    If Stmt is { assign, ID, Expr1 }, then StmtEval should return 
%    the pair { void, Env1 } where Env1 is the assoc-list 
%    [ { ID, ExprEval(Expr1,Env) } | Env ].
%
%    Otherwise, if Stmt is an Expr, then StmtEval() should simply
%    return the pair { ExprEval(Expr, Env), Env }.
%
% Hint: Return an anonymous function fun (Stmt, Env) -> ... end.
make_stmt_evaluator(_ExprEval) ->
    'TODO'.

% Return the result of evaluating Stmt in environment given by
% assoc-list Env.  A sub-expression of Stmt of the form {id, ID}
% where ID is not in Env should evaluate to 0.
%
% Hint: Implement as a wrapper around make_stmt_evaluator().
eval_stmt_0(_Stmt, _Env) ->
    'TODO'.

% Return the result of evaluating Stmt in environment given by
% assoc-list Env.  A sub-expression of Stmt of the form {id, ID}
% where ID is not in Env should result in throwing an 
% exception { not_found, Msg } where Msg is a string describing
% the error.
%
% Hint: Implement as a wrapper around make_stmt_evaluator().
eval_stmt_throw(_Stmt, _Env) ->
    'TODO'.

-ifdef(test_eval_stmt_0).
eval_stmt_0_test_() -> 
    Env1 = [{a, 2}, {x, 42}, {b, 2}, {x, 22}],
    [ { "num", 
	?_assertEqual({void, [{var, 42}|Env1]},
		      eval_stmt_0( {assign, var, {leaf, 42}}, Env1 )) },
      { "id_ok", 
	?_assertEqual({ void, [{var, 2}|Env1]},
		      eval_stmt_0( {assign, var, {id, b}}, Env1 )) },
      { "id_default", 
	?_assertEqual({ void, [{var, 0}|Env1] },
		      eval_stmt_0( {assign, var, {id, y}}, Env1 )) },
      { "add", 
	?_assertEqual({ void, [{var, 44}|Env1] },
		      eval_stmt_0({assign, var, {add, {id, b}, {id, x} }}, 
				  Env1 )) },
      { "sub", 
	?_assertEqual({ void, [{var, -40}|Env1] },
		      eval_stmt_0({assign, var, {sub, {id, b}, {id, x} }}, 
				  Env1 )) },
      { "mul", 
	?_assertEqual({ void, [{var, 84}|Env1] },
		      eval_stmt_0({assign, var, {mul, {id, b}, {id, x} }}, 
				  Env1 )) },
      { "uminus", 
	?_assertEqual({ void, [{var, -42}|Env1] },
		      eval_stmt_0({assign, var, {uminus, {id, x} }}, 
				  Env1 )) },
      { "complex", 
	?_assertEqual({ void, [{var, 60}|Env1] },
		      eval_stmt_0(
			{assign, var, 
			 {sub, { mul, {id, b}, 
				      {add, {uminus, {id, b}}, {id, x} } },
			       { leaf, 20 } }}, Env1  )) },
      { "complex_0", 
	?_assertEqual({ void, [{var, 64}|Env1] },
		      eval_stmt_0(
			{assign, var, 
			 {sub, { mul, {id, b}, 
				      {add, {uminus, {id, b1}}, {id, x} }},
			       { leaf, 20 } }}, Env1  )) },
      { "bad_expr", ?_assertError({bad_expr, _}, 
				  eval_stmt_0({assign1, a, {leaf, 42}}, Env1)) }
    ].
-endif. %test_eval_stmt_0


-ifdef(test_eval_stmt_throw).
eval_stmt_throw_test_() -> 
    Env1 = [{a, 2}, {x, 42}, {b, 2}, {x, 22}],
    [ { "num", 
	?_assertEqual({void, [{var, 42}|Env1]},
		      eval_stmt_throw( {assign, var, {leaf, 42}}, Env1 )) },
      { "id_ok", 
	?_assertEqual({ void, [{var, 2}|Env1]},
		      eval_stmt_throw( {assign, var, {id, b}}, Env1 )) },
      { "id_throw", 
	?_assertThrow({ not_found, _ },
		      eval_stmt_throw( {assign, var, {id, y}}, Env1 )) },
      { "add", 
	?_assertEqual({ void, [{var, 44}|Env1] },
		      eval_stmt_throw({assign, var, {add, {id, b}, {id, x} }}, 
				  Env1 )) },
      { "sub", 
	?_assertEqual({ void, [{var, -40}|Env1] },
		      eval_stmt_throw({assign, var, {sub, {id, b}, {id, x} }}, 
				  Env1 )) },
      { "mul", 
	?_assertEqual({ void, [{var, 84}|Env1] },
		      eval_stmt_throw({assign, var, {mul, {id, b}, {id, x} }}, 
				  Env1 )) },
      { "uminus", 
	?_assertEqual({ void, [{var, -42}|Env1] },
		      eval_stmt_throw({assign, var, {uminus, {id, x} }}, 
				  Env1 )) },
      { "complex", 
	?_assertEqual({ void, [{var, 60}|Env1] },
		      eval_stmt_throw(
			{assign, var, 
			 {sub, { mul, {id, b}, 
				      {add, {uminus, {id, b}}, {id, x} } },
			       { leaf, 20 } }}, Env1  )) },
      { "complex_throw", 
	?_assertThrow({ not_found, _},
		      eval_stmt_throw(
			{assign, var, 
			 {sub, { mul, {id, b}, 
				      {add, {uminus, {id, b1}}, {id, x} }},
			       { leaf, 20 } }}, Env1  )) },
      { "bad_expr", 
	?_assertError({bad_expr, _}, 
		      eval_stmt_throw({assign1, a, {leaf, 42}}, Env1)) }
    ].
-endif. %test_eval_stmt_throw

%---------------------------- Server Function ---------------------------

% #5: 30-points

% server_fn(Fn, State) should receive messages Msg from clients and
% respond based on the form of Msg:
%
%    { ClientPid, stop }: the server should send a { self(), stopped }
%    reply to ClientPid and return.
%
%    { ClientPid, set_fn, Fn1 }: the server should send a { self(), set_fn }
%    reply to ClientPid and recurse with Fn set to Fn1 and State unchanged.
%
%    { ClientPid, set_state, State1 }: the server should send a 
%    { self(), set_state } reply to ClientPid and recurse with Fn
%    unchanged and State set to State1.
%
%    { ClientPid, do_fn, Arg }: the server should call Fn(Arg, State)
%    which should return some Result.  
%
%        If Result is a pair { Value,
%        State1 } it should send a { self(), Value } reply to ClientPid
%        and recurse with Fn unchanged and State set to State1.
%
%        If Result is not a pair, it should send a { self(), Result }
%        reply to ClientPid and recurse with both Fn and State
%        unchanged.  
%
%        If the call to Fn() throws an exception throw:E, then send a
%        { self(), throw, E } reply triple to ClientPid.
%
%        If the call to Fn() results in an error error:E, then send a
%        { self(), error, E } reply triple to ClientPid.
%
% Hint: evaluate Fn() within a try-catch, with the catch matching
% throw:Exception or error:Error.
server_fn(_Fn, _State) ->
    'TODO'.
			
-ifdef(test_server_fn).

server_set_fn(Pid, Fn) ->
    Pid ! { self(), set_fn, Fn },
    receive
	{ Pid, X } ->
	    X 
    end.

server_set_state(Pid, State) ->
    Pid ! { self(), set_state, State },
    receive
	{ Pid, X } ->
	    X
    end.

server_do_fn(Pid, Stmt) ->
    Pid ! { self(), do_fn, Stmt },
    receive
	{ Pid, Value } ->
	    Value ;
	{ Pid, throw, Exception } ->
	    { throw, Exception } ;
	{ Pid, error, Error } ->
	    { error, Error }
    end.    

server_fn_test_() ->
    Env1 = [{a, 2}, {x, 42}, {b, 2}, {x, 22}],
     { setup,
       % before tests, create server with Fn eval_stmt_0/2 and State
       % Env1.
       fun () -> spawn(prj5_sol, server_fn, [fun eval_stmt_0/2, Env1]) end,

       % after tests, stop server.
       fun (Pid) -> Pid ! { self(), stop }, ok end,

       % return tests for server at Pid.
       fun (Pid) -> 
         [
	  { "num", ?_assertEqual(42, server_do_fn(Pid, { leaf, 42 })) },
	  { "id_0", ?_assertEqual(0, server_do_fn(Pid, { id, var })) },
	  { "assign", 
	    ?_assertEqual(void, 
			  server_do_fn(Pid, { assign, var, { leaf, 42 }})) },
	  { "id_42", ?_assertEqual(42, server_do_fn(Pid, { id, var })) },
	  { "set_state", 
	    ?_assertEqual(set_state, server_set_state(Pid, Env1)) },
	  { "id_0_again", ?_assertEqual(0, server_do_fn(Pid, { id, var })) },
	  { "set_fn", 
	    ?_assertEqual(set_fn, server_set_fn(Pid, fun eval_stmt_throw/2)) },
	  { "id_throw", 
	    ?_assertMatch({throw, {not_found, _}},
			  server_do_fn(Pid, { id, var })) },
	  { "assign", 
	    ?_assertEqual(void, 
			  server_do_fn(Pid, { assign, var, { leaf, 42 }})) },
	  { "id_42", ?_assertEqual(42, server_do_fn(Pid, { id, var })) },
	  { "complex", 
	    ?_assertEqual(void, 
			  server_do_fn(Pid,
				       {assign, var, 
					{sub, { mul, {id, b}, 
						{add, {uminus, {id, b}}, 
						      {id, x} } },
					 { leaf, 20 } }})) },
	  { "id_60", ?_assertEqual(60, server_do_fn(Pid, { id, var })) },
	  { "expr_error", 
	    ?_assertMatch({error, {bad_expr, _}},
			  server_do_fn(Pid, { x, var })) }
	 ]
       end
     }.
	        
-endif. % test_server_fn			
			    



