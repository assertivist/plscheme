begin;
select * from no_plan();

create function set_var(x int) returns void language plschemeu as '(set! pl-shared x)';
create function get_var() returns int language plschemeu as 'pl-shared';

select set_var(42);

select is(get_var(), 42);

select * from finish();
rollback;
