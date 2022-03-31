begin;
select * from no_plan();

create function f(out a int) returns setof int language plschemeu as $$
  (list
    (list (cons "a" 1))
    (list (cons "a" 2)))
$$;

select set_eq(
  $$ select * from f() $$,
  $$ values (1), (2) $$
);


create function g(out a int, out b text) returns setof record language plschemeu as $$
  (list
    (list (cons "a" 1) (cons "b" "one"))
    (list (cons "a" 2) (cons "b" "two")))
$$;

select set_eq(
  $$ select * from g() $$,
  $$ values (1, 'one'), (2, 'two') $$
);

select * from finish();
rollback;
