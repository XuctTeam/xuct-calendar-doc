create table oauth_client_details
(
    client_id               varchar(256)  not null
        primary key,
    resource_ids            varchar(256)  null,
    client_secret           varchar(256)  null,
    scope                   varchar(256)  null comment '权限范围(read,write,trust)',
    authorized_grant_types  varchar(256)  null comment '客户端支持的grant_type (authorization_code,password,refresh_token,implicit,client_credentials)',
    web_server_redirect_uri varchar(256)  null,
    authorities             varchar(256)  null comment '客户端所拥有的Spring Security的权限值',
    access_token_validity   int           null comment '客户端的access_token的有效时间值',
    refresh_token_validity  int           null comment '客户端的refresh_token的有效时间值',
    additional_information  varchar(4096) null comment '预留的字段',
    autoapprove             varchar(256)  null comment ' ''true'',''false'', ''read'',''write'''
);

INSERT INTO oauth.oauth_client_details (client_id, resource_ids, client_secret, scope, authorized_grant_types, web_server_redirect_uri, authorities, access_token_validity, refresh_token_validity, additional_information, autoapprove) VALUES ('app_id', null, '$2a$10$XzynJiuIo6FIpUIRxGvmSu.AV4Pjq4lrtdPd3MXx.wNT12QA8SxEq', 'all', 'phone,password,wechat,refresh_token', null, null, null, null, null, null);
