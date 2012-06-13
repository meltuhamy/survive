drop table actions;
CREATE TABLE actions (
    time timestamp NOT NULL,
    gameid integer NOT NULL,
    socketid text NOT NULL,
    type character NOT NULL,
    tilex integer,
    tiley integer,
    value smallint
);
select * from actions;