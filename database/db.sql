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
select * from actions;