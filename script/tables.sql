
drop table if exists user_alert;
drop table if exists alert;

drop table if exists user_role;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS role;






CREATE TABLE role
(
	id		tinyint	unsigned		not null	auto_increment,
	role		varchar(50)	not null,

	primary key (id)
) ENGINE=InnoDB default charset=utf8;

INSERT INTO role values (null, 'user');
INSERT INTO role values (null, 'admin');


CREATE TABLE user
(
	id		int	unsigned		not null	auto_increment,
	email		varchar(255) 	not null,
	password	varchar(255)	not null,
	name		varchar(255),
	active   tinyint(1)   unsigned   not null   default 1,

primary key (id),

unique index email_idx (email)
) ENGINE=InnoDB default charset=utf8;

insert into user (email) values ('rob@intelcompute.com');




CREATE TABLE user_role
( 
	user    int   unsigned   not null,
	role    tinyint   unsigned   not null,
	
	primary key (user, role ),
	
  foreign key (user) references user(id) on delete cascade on update cascade,	
  foreign key (role) references role(id) on delete cascade on update cascade
) ENGINE=InnoDB default charset=utf8;

insert into user_role (user, role) values (1, 1);
insert into user_role (user, role) values (1, 2);








create table alert
(
    id   int   unsigned    not null   auto_increment,
    distribution   varchar(255)   not null,
    abstract   varchar(255)   not null,
    author   varchar(255)  not null,
    version   varchar(255)   not null,
     checked   datetime   not null,    
    updated    datetime    not null,

   primary key (id)
   
) ENGINE=InnoDB default charset=utf8;


create table user_alert
(
	user    int   unsigned   not null,
   alert  int   unsigned   not null,
   development   tinyint(1)   unsigned not null,
   email    varchar(255)   not null,
   added    datetime   not null,
   
primary key (user, alert ),

  foreign key (user) references user(id) on delete cascade on update cascade,	
  foreign key (alert) references alert(id) on delete cascade on update cascade   

) ENGINE=InnoDB default charset=utf8;
















