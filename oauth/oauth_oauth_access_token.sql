create table oauth_access_token
(
    token_id          varchar(256) null,
    token             text         null,
    authentication_id varchar(256) not null
        primary key,
    user_name         varchar(256) null,
    client_id         varchar(256) null,
    authentication    text         null,
    refresh_token     varchar(256) null
);

