begin;
select * from no_plan();

create function ta() returns text[] language plschemeu as '(vector "one" "two" "three")';

select is(ta(), '{one, two, three}'::text[]);

create function inc_all(numbers int[]) returns int[] language plschemeu as $$
  (use-modules (rnrs))
  (vector-map (lambda (n) (+ n 1)) numbers)
$$;

select is(inc_all('{1, 2, 3}'), '{2, 3, 4}');

select * from finish();
rollback;
