-- drop function JDBC_func(in n integer, in email_name character varying)

-- create or replace function JDBC_func(in n integer, in email_name character varying) returns table(users character varying) as
-- $body$
-- begin
-- 	return query
-- 	WITH RECURSIVE followpaths(initialfollower,finalfollowee,depth,path) AS
-- 	(SELECT email, "connectedWith_email",1, email || ', ' || "connectedWith_email" FROM connects where email = email_name
-- 	UNION
-- 	SELECT p.initialfollower, f."connectedWith_email",depth+1, p.path || ', ' || f."connectedWith_email" FROM followpaths as p join connects as f on (p.finalfollowee = f.email)
-- 	WHERE POSITION(f."connectedWith_email" IN p.path)=0 and depth<n)
-- 	SELECT distinct finalfollowee FROM followpaths;
-- end;
-- $body$
-- language plpgsql volatile;

-- select * from JDBC_func(2,'adinozzo@gmail.com')