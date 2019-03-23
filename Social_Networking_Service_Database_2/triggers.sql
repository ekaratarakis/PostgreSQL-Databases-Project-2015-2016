------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--****************************************************************************************** TRIGGERS 6 - 11 *****************************************************************************************************************************************
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Trigger for constraint 6

-- drop function trigger6();
 
-- create or replace function trigger6() returns trigger as
-- $body$
--     begin
-- 	raise notice 'new id %',new."questionID";
-- 	if ((select count(*) from (select email from answer where "answerID"=new."answerID" intersect select * from question8((select email from question where "questionID" = new."questionID")))src) = 0) then
-- 		raise notice 'new %',new.email;
-- 		delete from answer where new."answerID"="answerID";
-- 	end if;
-- 	return null;
--     end;
-- $body$
-- language plpgsql volatile;


-- drop trigger tr6 on answer;

-- create trigger tr6
-- after insert
-- on public.answer
-- for each row
-- execute procedure public.trigger6();


-- insert into answer ("answerID", answer, "datePosted", "questionID", email) VALUES (16, 'Cheese','2013-1-1',1,'shanna@gmail.com');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Trigger for constraint 7

-- drop function trigger7();

-- create or replace function trigger7() returns trigger as
-- $body$
--     begin
-- 	insert into connects (email,"connectedWith_email",type,"theComment","dateOfJoin") values ((select sender_email from invitation where new."invitationID" = "invitationID"),(select receiver_email from invitation where new."invitationID" = "invitationID"),'BUSINESS','AAADSFA',(select "dateSent" from invitation where new."invitationID" = "invitationID"));
-- 	insert into connects (email,"connectedWith_email",type,"theComment","dateOfJoin") values ((select receiver_email from invitation where new."invitationID" = "invitationID"),(select sender_email from invitation where new."invitationID" = "invitationID"),'BUSINESS','AAADSFA',(select "dateSent" from invitation where new."invitationID" = "invitationID"));
-- 	return new;
--     end;
-- $body$
-- language plpgsql volatile;


-- drop trigger tr7 on public.invitation;

-- create trigger tr7
-- after update or insert on invitation
-- for each row
-- when(new."theStatus" = 'ACCEPTED')
-- execute procedure trigger7();


-- insert into invitation ("invitationID", sender_email, receiver_email, "theStatus", "dateSent") values (19,'gcallen@gmail.com',lhunter@gmail.com','ACCEPTED','2013-01-25');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Trigger for constraint 8

-- drop function trigger8();

-- create or replace function trigger8() returns trigger as
-- $body$
-- 	begin
-- 		delete from article_comment using article where article."articleID"=article_comment."articleID" and article_comment."datePosted"-article."datePosted">30;
-- 		return old;
-- 	end;
-- $body$
-- language plpgsql volatile;


-- drop trigger tr8 on public.article;

-- create trigger tr8
-- after insert on article 
-- for each row 
-- execute procedure trigger8();


-- insert into article("articleID", title, "categoryID", "theText", "datePosted", email) values (16, 'THIS IS A NEW ARTICLE', 15, 'Read the new article', '2016-04-13', 'kblye@gmail.com');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Trigger for constraint 9

-- drop function trigger9();
 
-- create or replace function trigger9() returns trigger as 
-- $body$
-- 	declare
-- 		counter record;
-- 	begin
-- 		for counter in select email from advertisement, job_seek where job_seek."advertisementID" = advertisement."advertisementID" and advertisement."EduLevel" in 
-- 			  (select "EduLevel" from advertisement where "advertisementID" = new."advertisementID")
-- 		loop
-- 			insert into msg("msgID", "theSubject", "theText", sender_email, receiver_email, "dateSent")
-- 			values(
-- 			(select max("msgID" + 1) from msg),
-- 			'NEW JOB OFFER',
-- 			'THERE IS A JOB YOU LIKE',
-- 			(select email from advertisement where advertisement."advertisementID" = new."advertisementID"),
-- 			(select trim ((SELECT CAST (counter AS varchar)), '()')),
-- 			(select advertisement."datePosted" from advertisement where advertisement."advertisementID" = new."advertisementID"));
-- 		end loop;
-- 	return new; 
-- 	end;
-- $body$
-- language plpgsql volatile;


-- drop trigger tr9 on job_offer;

-- create trigger tr9
-- after insert or update on job_offer
-- for each row 
-- execute procedure trigger9();


-- insert into job_offer ("advertisementID", "jobDescription", "fromAge", "toAge", company, "companyURL") values (17, 'NEW JOB DESCRIPTION', 34, 44, 'SAMSUNG', 'samsung.com');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Trigger for constraint 10

-- drop function trigger10();

-- create or replace function trigger10() returns trigger as 
-- $body$
-- 	declare 
-- 		row_counter record;
-- 	begin
-- 		for row_counter in select email from advertisement, job_offer where job_offer."advertisementID" = advertisement."advertisementID" and advertisement."EduLevel" in
-- 			(select "EduLevel" from advertisement where "advertisementID"=new."advertisementID")
-- 		loop
-- 			insert into msg("msgID", "theSubject", "theText", sender_email, receiver_email, "dateSent")
-- 			values(
-- 			(select max("msgID" + 1) from msg),
-- 			'LOOKING FOR A JOB',
-- 			'HELLO I AM INTERESTED IN YOUR JOB OFFER AD',
-- 			(select email from advertisement where advertisement."advertisementID" = new."advertisementID"),
-- 			(select trim ((select cast (row_counter as varchar)), '()')),
-- 			(select advertisement."datePosted" from advertisement where advertisement."advertisementID" = new."advertisementID"));
-- 		end loop;
-- 	return new;
-- 	end;
-- $body$
-- language plpgsql volatile;


-- drop trigger tr10 on job_seek;

-- create trigger tr10
-- after insert or update on job_seek
-- for each row 
-- execute procedure trigger10();

-- insert into job_seek("advertisementID", "personalDescription") values (31, 'BACHELOR');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Trigger for constraint 11

-- drop trigger tr11 on member;
-- create trigger tr11 after update on member for each row when(new."lastLoginDate" >= new."subscriptionExpiry") execute procedure trigger11();


-- drop function trigger11();

-- create or replace function trigger11() returns trigger as 
-- $body$
-- 	declare 
-- 		counter integer;
-- 	begin
-- 		for counter in select distinct advertisement."advertisementID" from advertisement, job_offer, job_seek 
-- 			       where (job_offer."advertisementID" = advertisement."advertisementID" or job_seek."advertisementID" = advertisement."advertisementID") 
--                                and email in (select email from member where "lastLoginDate" = new."lastLoginDate")
-- 		loop
-- 			insert into log("advertisementID", "jobType", industry, "EduLevel", title, location, "postalCode", country, "datePosted", email, specialworkcapability, salary)
-- 			values (
-- 			(counter),
-- 			(select "jobType" from advertisement where advertisement."advertisementID" in (counter)),
-- 			(select industry from advertisement where advertisement."advertisementID" in (counter)),
-- 			(select "EduLevel" from advertisement where advertisement."advertisementID" in (counter)),
-- 			(select title from advertisement where advertisement."advertisementID" in (counter)), 
-- 			(select location from advertisement where advertisement."advertisementID" in (counter)), 
-- 			(select "postalCode" from advertisement where advertisement."advertisementID" in (counter)), 
-- 			(select country from advertisement where advertisement."advertisementID" in (counter)), 
-- 			(select "datePosted" from advertisement where advertisement."advertisementID" in (counter)), 
-- 			(select email from advertisement where advertisement."advertisementID" in (counter)), 
-- 			(select specialworkcapability from advertisement where advertisement."advertisementID" in (counter)),
-- 			(select salary from advertisement where advertisement."advertisementID" in (counter))  
-- 			);
-- 		end loop;
-- 
-- 		delete from advertisement using job_offer, job_seek where (job_offer."advertisementID" = advertisement."advertisementID" or job_seek."advertisementID" = advertisement."advertisementID") 
--                                and email in (select email from member where "lastLoginDate" = new."lastLoginDate");
--              return old;
-- 	--return new;
-- 	end;
-- $body$
-- language plpgsql volatile;

-- update member set "lastLoginDate" = '2029-03-29' where member.email = 'kblye@gmail.com';