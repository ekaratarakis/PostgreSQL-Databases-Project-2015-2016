-------------------------------------------------------------------------------------------
--************************************** INDEXES ******************************************
-------------------------------------------------------------------------------------------

-- explain analyze select * from question1('adinozzo@gmail.com');
-- create index edu_email_idx on education using btree (email)
-- cluster education using edu_email_idx

-- drop index idx1
-- cluster education using education_pkey;

-------------------------------------------------------------------------

-- explain analyze select * from question4('adinozzo@gmail.com');
-- create index article_email_index on article using btree (email)
-- cluster article using article_email_index;

-- drop index article_email_index;
-- cluster article using article_pkey;

-------------------------------------------------------------------------






