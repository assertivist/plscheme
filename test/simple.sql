begin;
select * from no_plan();

create function scm_pow(u int, v int) returns int language plschemeu as $$
  (let loop ((v v))
    (if (< v 1) 1
        (* u (loop (- v 1)))))
$$;

select is(scm_pow(2, 5), 32);


create function return_string() returns text as '"foo"' language plschemeu;

select is(return_string(), 'foo');


create function return_int() returns int language plschemeu as '42';

select is(42, return_int());

select * from finish();
rollback;



