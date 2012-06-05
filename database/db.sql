drop table actions;
CREATE TABLE actions (
    time timestamp NOT NULL,
    gameid integer NOT NULL,
    socketid bigint NOT NULL,
    type character NOT NULL,
    tilex integer,
    tiley integer,
    value smallint
);
insert into actions values (NOW(), 1, 8828871238747812, 'd');
insert into actions values (NOW(), 2, 2772377123761231, 'i', 0, 2, 1);
insert into actions values (NOW(), 0, 1263676767612761, 't', 2, 9, 5);
insert into actions values (NOW(), 4, 2373663617236771, 'p', 3, 1, 2);
select * from actions;