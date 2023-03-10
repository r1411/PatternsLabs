create table student (
     id          int auto_increment,
     last_name   varchar(128) not null,
     first_name  varchar(128) not null,
     father_name varchar(128) not null,
     phone       varchar(20) null,
     telegram    varchar(100) null,
     email       varchar(100) null,
     git         varchar(100) null,
     constraint student_pk
         primary key (id)
);