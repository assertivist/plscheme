begin;
select * from no_plan();

create function select42() returns int language plschemeu as $$
  (let* ((ret    (spi-execute "select 42"))
         (tuples (assoc-ref ret "returned-tuples")))
    (vector-ref (car tuples) 0))
$$;

select is(select42(), 42);


create function add_pet(name text, age int) returns void language plschemeu as $$
  (spi-execute-prepared
    (spi-prepare "insert into pet values ($1, $2)" (vector "text" "int4"))
    (vector name (number->string age)))
$$;

create temp table pet (name text, age int);

select add_pet('oscar', 3);

select set_eq($$ select * from pet $$, $$ values ('oscar', 3) $$);

select * from finish();
rollback;
