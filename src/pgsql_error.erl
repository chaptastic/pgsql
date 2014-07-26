%% -*- coding: utf-8 -*-
-module(pgsql_error).
-vsn("1").

-export([
         is_integrity_constraint_violation/1,
         is_in_failed_sql_transaction/1
        ]).

-export_type([
    pgsql_error/0,
    pgsql_error_and_mention_field/0,
    pgsql_error_and_mention_field_type/0
    ]).

-type pgsql_error_and_mention_field_type() ::
    severity | code | message | detail | hint | position | internal_position
    | internal_query | where | file | line | routine | {unknown, byte()}.
-type pgsql_error_and_mention_field() ::
    {pgsql_error_and_mention_field_type(), binary()}.
-type pgsql_error() :: map().

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-spec is_integrity_constraint_violation(pgsql_error()) -> boolean().
is_integrity_constraint_violation(#{code := <<"23", _SubClass:3/binary>>}) -> true; %% iso 9075-2 §22.1
is_integrity_constraint_violation(_) -> false.

-spec is_in_failed_sql_transaction(pgsql_error()) -> boolean().
is_in_failed_sql_transaction(#{code := <<"25P02">>}) -> true; %% PostgreSQL extension
is_in_failed_sql_transaction(_) -> false.
