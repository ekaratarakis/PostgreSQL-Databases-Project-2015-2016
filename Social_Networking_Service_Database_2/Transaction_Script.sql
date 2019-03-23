-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--*********************************************************************************************************** Transaction ***********************************************************************************************************************************
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Transaction for question 1

-- drop function transaction_1(from_date date, to_date date);

create or replace function transaction_1(from_date date, to_date date) returns void as 
$body$
	declare
		commentator record;
		author varchar;
		res record;
		req_cnt_cm bigint := 0;
		msg_cnt_cm bigint := 0;
		msg_cnt_au bigint := 0;
		inv_cnt_cm bigint := 0;
		init_req_cnt bigint := (select count("requestID") from recommendation_request where "dateSent" = current_date);
		init_msg_cnt bigint := (select count("msgID") from msg where "dateSent" = current_date);
		req_cnt bigint := 0;
		msg_cnt bigint := 0;
	begin
		begin	----------------------- 1st Transaction
			begin	------------------------ 2nd Transaction
				
				for commentator in (select email from article_comment where "datePosted" > from_date and "datePosted" < to_date)
				loop
					begin	------------------------ 3rd Transaction
						author := (select email from article where "articleID" in (select "articleID" from article_comment where "datePosted" > from_date  and "datePosted" < to_date));
						if((select count(*) from (select trim((commentator::text), '()') intersect select "connectedWith_email" from connects where email in (author))src) = 1) then  ------------- 1st Level Connection

							if(((select company from experience where email = (author)) = ANY (select company from experience where email = (select trim((commentator::text), '()')))) and
							   ((select "fromYear" from experience where email = (author)) = ANY (select "fromYear" from experience where email = (select trim((commentator::text), '()')))) and
							   ((select "toYear" from experience where email = (author)) = ANY (select "toYear" from experience where email = (select trim((commentator::text), '()')))) and
							   ((select workstatus from experience where email = (author)) = 'PAST') and ((select workstatus from experience where email = (select trim((commentator::text), '()')))='PAST')) then
							   							
								insert into recommendation_request("requestID", "dateSent", for_email, sender_email, receiver_email, thestatus)
								values((select max("requestID" + 1) from recommendation_request),current_date,'kblye@gmail.com',(author),(select trim((commentator::text), '()')),'PENDING');
								req_cnt := req_cnt + 1;
							end if;

							insert into "Endorses"(email, recommended_email, skills, "datePosted")
							values((author),(select trim((commentator::text), '()')),(select name from category where "categoryID" in 
											(select "interestID" from member_interests where "memberID" = 'kblye@gmail.com' and "interestID" in 
											(select "interestID" from member_interests where "memberID" = 'lhunter@gmail.com'))), current_date);
																		
							insert into msg("msgID", "theSubject", "theText", sender_email, receiver_email, "dateSent")
							values((select max("msgID" + 1) from msg),'THANK YOU FOR YOUR COMMENT','YOUR COMMENT WAS VERY INTERESTING',(author),(select trim((commentator::text), '()')),current_date);
							msg_cnt := msg_cnt + 1;
							
						elsif(((select * from foo(author)) intersect (select trim((commentator::text), '()'))) = (select trim((commentator::text), '()'))) then  ---------------------------------- 2nd Level Connection
							insert into msg("msgID", "theSubject", "theText", sender_email, receiver_email, "dateSent")
							values((select max("msgID" + 1) from msg), 'A NEW MESSAGE FOR YOU', 
							(select((select title from experience where email = 'adinozzo@gmail.com' and "toYear" in (select max("toYear") from experience)) || ', '  || (select summary from summary where email='adinozzo@gmail.com')) as me ),
							(author), (select trim((commentator::text), '()')), current_date);
							insert into msg("msgID", "theSubject", "theText", sender_email, receiver_email, "dateSent")
							values((select max("msgID" + 1) from msg), 'THANK YOU', 'THANK YOU FOR YOUR COMMENT', (author), (select trim((commentator::text), '()')), current_date);
							msg_cnt := msg_cnt + 2;
						
						elsif(((select email from member where email <> (author)) except (select * from question8(author))) = (select trim((commentator::text), '()'))) then  --------------------- Not in Professional Network
							res := (select((select email::text || ', ' || "firstName"::text || ' ' || "secondName"::text || ', ' || "dateOfBirth"::text || ', ' || country::text from member where email = (select trim((commentator::text), '()'))) || ' count=' ||
							(select count(*) from article where email = (select trim((commentator::text), '()')) and "categoryID" in 
							(select "categoryID" from article where email = (author) and "articleID" in 
							(select "articleID" from article_comment where email = (select trim((commentator::text), '()')))))));

							insert into msg("msgID", "theSubject", "theText", sender_email, receiver_email, "dateSent")
							values((select max("msgID" + 1) from msg), 'MEMBER THAT COMMENT', res, (select trim((commentator::text), '()')), (author), current_date);
		  
							insert into msg("msgID", "theSubject", "theText", sender_email, receiver_email, "dateSent")
							values((select max("msgID" + 1) from msg), 'THANK YOU', 'THANK YOU FOR YOUR COMMENT', (author), (select trim((commentator::text), '()')), current_date);

							msg_cnt := msg_cnt + 2;
						end if;

						msg_cnt_cm := (select count("msgID") from msg where receiver_email in (select trim((commentator::text), '()')) and sender_email in (author) and "dateSent" = current_date);
						msg_cnt_au := (select count("msgID") from msg where receiver_email in (author) and sender_email in (select trim((commentator::text), '()')) and "dateSent" = current_date);
						inv_cnt_cm := (select count("invitationID") from invitation where receiver_email in (select trim((commentator::text), '()')) and sender_email in (author) and "dateSent" = current_date);
						req_cnt_cm := (select count("requestID") from recommendation_request where receiver_email in (select trim((commentator::text), '()')) and sender_email in (author) and "dateSent" = current_date);

						
						if(msg_cnt_cm > 10 or msg_cnt_au > 10) then
							raise notice 'ROLLBACK';
							rollback;	-- RAISE EXCEPTION 'ROLLBACK'
						elsif(inv_cnt_cm > 5) then
							raise notice 'ROLLBACK';
							rollback;	-- RAISE EXCEPTION 'ROLLBACK'
						elsif(req_cnt_cm > 5) then
							raise notice 'ROLLBACK';
							rollback;	-- RAISE EXCEPTION 'ROLLBACK'
						end if;

						exception when others then 

					end;  ------------------------ End of 3rd Transaction
				end loop;

				if((msg_cnt = init_msg_cnt or req_cnt >= 2*init_req_cnt) and (init_msg_cnt <> 0 and init_req_cnt <> 0)) then
					raise notice 'ROLLBACK ALL';
					rollback;	-- RAISE EXCEPTION 'ROLLBACK' ALL
				end if;

				exception when others then
				
			end;  ------------------------ End of 2nd Transaction
		end;  ------------------------ End of 1st Transaction
	end;
$body$
language plpgsql volatile;


-- select * from transaction_1('2015-1-1',current_date);