CREATE SCHEMA eljugador;

CREATE TABLE IF NOT EXISTS eljugador.users (
    username varchar(255) PRIMARY KEY,
    pword varchar(255) NOT NULL
);
    

CREATE TABLE IF NOT EXISTS eljugador.verbs (
    username varchar(255), 
    verb varchar(255),
    CONSTRAINT pk_verbs PRIMARY KEY (username, verb),
    CONSTRAINT fk_user FOREIGN KEY (username) REFERENCES eljugador.users(username)
);