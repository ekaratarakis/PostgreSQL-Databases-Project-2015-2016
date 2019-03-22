---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--******************************************************************** QUESTIONS 1 - 8 ******************************************************************************************************************************
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for 1st question --

-- DROP FUNCTION question1(name varchar(255));

create or replace function question1(name varchar(255)) returns Table(email_name varchar) as $$
begin
	return query
	(select email from education where email!= name and school in(select school from education where email=name)
	except
 	select * from question8(name))	-----except from professional network from quest 8 recursion -- select email from connects where "connectedWith_email"=name
	intersect
	select email from education where email!= name and "toYear" in 
		(select "toYear" from education where "fromYear" in (select "fromYear" from education where email=name)
	);
end;
$$ language plpgsql volatile;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for question 2 --

-- DROP FUNCTION question2(varchar(255));
 
create or replace function question2(email_name varchar(255)) returns Table (connected_with_users varchar) as $$
begin 
	return query
	(select "connectedWith_email" from connects where email = email_name and email_name != "connectedWith_email"								-- 1st level connection
	union																
	select a."connectedWith_email" from connects a, connects b where b.email = email_name and a.email = b."connectedWith_email" and email_name != a."connectedWith_email"	-- 2nd level connection
	union
	select a."connectedWith_email" from connects a, connects b, connects c 													-- 3rd level connection
	where c.email = email_name and b.email=c."connectedWith_email" and a.email=b."connectedWith_email" and email_name != a."connectedWith_email");
end;
$$ language plpgsql volatile;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for 3th question --

-- DROP FUNCTION question3();
 
create or replace function question3() returns Table("Author_Email" varchar, "Number_Of_Articles" bigint) as $$
begin
	return query 
	(select email,count(*) as "Author_Email" from article group by email having count(*)>=2);
end;
$$ language plpgsql volatile;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- fuction for 4th question --

-- DROP FUNCTION question4(varchar(255));

create or replace function question4(emailp varchar(255)) returns Table("Email_User" varchar, "Number Of Comments" bigint) as $$
begin
	return query
	select email as "Email_User",count(email) as "Number Of Comments" from 
	(select distinct email , "articleID"  from article_comment  where "articleID" in 
		(select "articleID" from article where email = emailp) group by email,"articleID")src 
		group by email having count(email)=(select count("articleID") from article where email=emailp);
	
end;
$$ language plpgsql volatile;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for 5th question --

-- DROP FUNCTION question5();
 
create or replace function question5() returns Table (title varchar, "articeID" integer, comments bigint) as $$
begin
	return query
	(select article.title, article_comment."articleID",count(*) as Comments from article, article_comment 
	 where article."articleID"= article_comment."articleID" group by article_comment."articleID",article.title order by -count(*));
end;
$$ language plpgsql volatile;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for 6th question --

-- DROP FUNCTION question6();

create or replace function question6() returns Table("EduLevel" varchar, email varchar, number_of_articles bigint) as $$
begin
	return query	
	(select education."EduLevel",article.email,count(*) as Number_Of_Articles from education,article 
	 where education.email=article.email group by education."EduLevel",article.email having count(*)>(select (count("articleID")/(select count(*) from article)) from article_comment)); 
end;
$$ language plpgsql volatile;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for 7th question --

-- DROP FUNCTION question7();

create or replace function question7() returns Table("job_offerID" integer , "jobDescription" varchar, "job_seekID" integer, "personalDescription" varchar) as $$
begin 
	return query(
	select job_offer."advertisementID" as "job_offerID", job_offer."jobDescription", job_seek."advertisementID" as "job_seekID", job_seek."personalDescription"
	from job_offer, job_seek
	where (job_seek."advertisementID",job_offer."advertisementID") in (select ad1."advertisementID", ad2."advertisementID" from advertisement ad1, advertisement ad2 where ad1."advertisementID" < ad2."advertisementID" and
													ad1."jobType" = ad2."jobType" and 
													ad2.industry = ad1.industry and
													ad1.country = ad2.country and
													((ad1.salary < ad2.salary + ad2.salary*0.1 and ad1.salary > ad2.salary - ad2.salary*0.1) or (ad2.salary < ad1.salary + ad1.salary*0.1 and ad2.salary > ad1.salary - ad1.salary*0.1)))
	);
end;
$$ language plpgsql volatile;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for question 8 --

-- DROP FUNCTION question8();

create or replace function question8(email_name varchar(255)) returns Table (network_members_for_specific_user varchar) as $$
begin
	return query
	With Recursive
		Myfunc(first,second) as (
		select email as first, "connectedWith_email" as second from connects where email != email_name 
		union 
		select Myfunc.first, connects."connectedWith_email" as second 
		from Myfunc, connects 
		where Myfunc.second = connects.email)
	select first from Myfunc where second = email_name;
end;
$$ language plpgsql volatile;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- *********************************************************************** CALCULATIONS 1 - 5 ******************************************************************************************************************************
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for calculation 1 --

--DROP FUNCTION calc1();

create or replace function calc1() returns Table(email varchar, "Number_Of_Comments" bigint) as $$
begin
	return query
	(select article_comment.email as email_name,count(*) as number_of_comments from article_comment group by article_comment.email order by -count(*)); 
end;
$$ language plpgsql volatile;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for calculation 2 --

-- DROP FUNCTION calc2(enumadv);

create or replace function calc2 (workcapability enumadv) returns Table (avarege_salary numeric) as $$
begin
	return query
	select avg(salary) as avarege_salary from advertisement,job_seek 
	where advertisement."advertisementID" = job_seek."advertisementID" 
	and advertisement.specialworkcapability = workcapability;
end;
$$ language plpgsql volatile;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for calculation 3 --

-- DROP FUNCTION calc3();

create or replace function calc3() returns Table ("Month_Sent" text,"Year_Sent" float, "Number_Of_Messages_Per_Month" bigint) as $$
begin
	return query
	select to_char("dateSent",'Month') as "Month_Sent", extract(year from "dateSent") as "Year_Sent", count(*) as "Number_Of_Messages_Per_Month"
	from msg
	group by to_char("dateSent",'Month'),extract(year from "dateSent")
	order by count(*) desc;

end;
$$ language plpgsql volatile;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for calculation 4 --

--DROP FUNCTION calc4();

create or replace function calc4() returns Table (average_time_of_days numeric) as $$
begin
	return query
	select avg(recommendation_msg."dateSent"-recommendation_request."dateSent") as average_time_of_days 
	from recommendation_msg, recommendation_request 
	where recommendation_request.thestatus = 'REPLIED';
end;
$$ language plpgsql volatile;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- function for calculation 5 --

-- DROP FUNCTION calc5();

create or replace function calc5() returns Table (for_email varchar, greatest_number_of_recommendation bigint) as $$
begin
	return query
	select "Endorses".recommended_email, count(*) as greatest_number_of_recommendation 
	from "Endorses" group by "Endorses".recommended_email order by -count(*);
end;
$$ language plpgsql volatile;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************CALLS OF FUNCTIONS**************************************************************************************
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- select * from question1('adinozzo@gmail.com');
-- select * from question2('njones@gmail.com');
-- select * from question3();
-- select * from question4('adinozzo@gmail.com');
-- select * from question5();
-- select * from question6();
-- select * from question7();
-- select * from question8('adinozzo@gmail.com');
----------------------------------------------------
-- select * from calc1();
-- select * from calc2('REMOTED_WORK');  -- CALCULATES FOR 'NONE' TOO
-- select * from calc3();
-- select * from calc4();
-- select * from calc5();

