begin;
select * from no_plan();

select throws_ok(
  $$
    create function f() returns void language plschemeu as '(report exception-level "Boom!")';
    select f();
  $$,
  'P0001',
  'Boom!'
);

select * from finish();
rollback;

