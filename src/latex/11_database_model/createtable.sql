drop database movie_db;
create database movie_db;
use movie_db;

-- 用户使用微信号作为主键，不需要记录登录口令，用户头像图片
-- movie_prefer为用户喜欢的电影类型，一个数据位为一种类型的电影，
-- 1表示感兴趣，0表示不感兴趣
create table User (
	-- use weinxin account for user_id
	user_id varchar(16) not null primary key, 
	name nvarchar(16) not null,
	cellphone varchar(16) not null,
	movie_prefer numeric
);

-- 购买记录，transaction_id为交易流水号，接入微信支付
-- 若未发起支付，transaction_id为null
create table ParchaseItem (
	order_id varchar(64) not null primary key,
	cinema_id numeric not null,
	session_id numeric not null,
	user_id varchar(16) not null,
	transaction_id varchar(64)
	-- -- when user comments, insert comment_id
	-- comment_id numeric
);

-- 评论信息使用user_id和order_id作为主键
-- move_id是冗余项，可以在order_id中查到，
-- 考虑打开某电影介绍界面可能需要查找评价信息，
-- 这里加上是为了便于查表，可以考虑删除
create table Comment (
	-- comment_id numeric not null primary key,
	user_id varchar(16) not null,
	order_id varchar(64) not null,
	movie_id numeric not null,
	comment_date datetime not null,
	rating numeric not null,
	content nvarchar(512),
	primary	key (user_id, order_id)
);

create table Session (
	cinema_id numeric not null,
	session_id numeric not null,
	movie_id numeric not null,
	hall_type numeric not null,
	seat_id numeric not null,
	show_date datetime not null,
	last_minute numeric,
	price numeric not null,
	primary key (cinema_id, session_id)
);

create table Cinema (
	cinema_id numeric not null primary key,
	name nvarchar(16) not null,
	citycode numeric not null,
	address nvarchar(64)
);

create table City (
	citycode numeric not null primary key,
	name nvarchar(8)
);

create table Seat (
	cinema_id numeric not null,
	hall_type numeric not null,
	seat_id numeric not null,
	session_id numeric not null,
	available boolean not null,
	primary	key (cinema_id, hall_type, seat_id)
);

-- 之前在Comment的表中加入了movie_id，这里本可以不用存放rating
-- 存rating只是为了缓存评分
create table Movie (
	movie_id numeric not null primary key,
	-- one type per bit 
	movie_type numeric,
	movie_name nvarchar(16),
	on_date date,
	off_date date,
	country varchar(16),
	director nvarchar(16),
	rating numeric
);

alter table ParchaseItem
	add constraint FK_PI_REF_USER foreign key (user_id)
	references User(user_id);
alter table ParchaseItem
	add constraint FK_PI_REF_SESS foreign key (cinema_id, session_id)
	references Session(cinema_id, session_id);
-- alter table ParchaseItem
-- 	add constraint FK_PI_REF_CMNT foreign key (comment_id)
-- 	references Comment(comment_id);

alter table Comment
	add constraint FK_CMNT_REF_USER foreign key (user_id)
	references User(user_id);
alter table Comment
	add constraint FK_CMNT_REF_PI foreign key (order_id)
	references ParchaseItem(order_id);
alter table Comment
	add constraint FK_CMNT_REF_MOVIE foreign key (movie_id)
	references Movie(movie_id);

alter table Session
	add constraint FK_SESS_REF_MOVIE foreign key (movie_id)
	references Movie(movie_id);
alter table Session
	add constraint FK_SESS_REF_CINE foreign key (cinema_id)
	references Cinema(cinema_id);

alter table Cinema
	add constraint FK_CINE_REF_CITY foreign key (citycode)
	references City(citycode);

alter table Seat
	add constraint FK_SEAT_REF_CINE foreign key (cinema_id)
	references Cinema(cinema_id);
alter table Seat
	add constraint FK_SEAT_REF_SESS foreign key (cinema_id, session_id)
	references Session(cinema_id, session_id);
