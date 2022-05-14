create table oauth_client_token
(
    token_id          varchar(256) null,
    token             text         null,
    authentication_id varchar(256) not null
        primary key,
    user_name         varchar(256) null,
    client_id         varchar(256) null
);

