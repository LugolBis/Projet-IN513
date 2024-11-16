-- Test de Feed
insert into Users values('lulu',null,null,'lulu@gmail.com','password','IP de lulu',null, null, null);
insert into Users values('soso',null,null,'soso@gmail.com','password','IP de soso',null, null, null);
insert into Follow values('soso','lulu');
insert into Post values(0,'JP est à la cantine!',date '2012-10-10',null,null,'soso');
insert into Post values(1,'JP est encore à la cantine!',date '2013-10-10',null,null,'soso');
@feed.sql;
select * from Feed;
drop view Feed;
delete from Users where pseudo='lulu';
delete from Users where pseudo='soso';
delete from Follow where pseudo='soso';
delete from Post where pseudo='soso';
delete from Post where pseudo='soso';