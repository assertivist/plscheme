begin;
select * from no_plan();

select throws_ok(
  $x$
    create function f(out a int, out b int) language plschemeu as $$
      (list (cons "a" 1) (cons "b" 2) (cons "c" 3))
    $$;
    select * from f();
  $x$,
  '42601',
  'Cannot find an argument with name c!'
);

select throws_ok(
  $x$
    create function f(out a int, out b int, out c int) language plschemeu as $$
      (list (cons "a" 1) (cons "b" 2))
    $$;
    select * from f();
  $x$,
  '42804',
  'Required argument count (3) is not satisfied. (Found 2 attributes.)'
);

select * from finish();
rollback;
