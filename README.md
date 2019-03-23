# PostgreSQL-Databases-Project-2015-2016
At firts the goal of this project is to create and design a database which wil handle all the information of an information system to provide a social networking service. Also, given the relationan model the database was created together with the matrices and the necessary elements. This social networking service offers the capability to create virtual communities of people having the same interests and activities or people who are interested in make good use of the interest and activities of other people living far away from them where they need some specific sofware for communication. Another goal for this system is to help professionals in many areas (such as software engineering, medical science, economics, etc) to create professional networks based on trust and cooperation. The final goal is the support of better and possible collaboration through the search and offer work supported by online resumes and trust relationships.
## System Requirements
This database can support the needs for skills promotions, professional networking, communication, and finding new partners of the system's users. The basic entities and functionalities supported by the database are 
- Create and manage new members (Matrix Member).
- Create and manage personal profile (Matrices Experience, Additional Info, Education, Summary).
- Create and manage professional network (Matrices Connects, Endorses, Invitation).
- Submit request for reccomendation letter (Matrices Recommendation_msg, Recommendation_request).
- Search for professionals.
- Pesonal communication with other professionals (Matrix Msg).
- Publish and manage advertisement for job seeking (Matrices Advertisement, Job_seek).
- Publish and manage advertisement for job offering (Matrices Advertisement, Job_offer).
- Search for Advertisements.
- Publish Articles (Matrices Article, Article_comment).
- Submit QnA (Matrices Question, Answer).
## Section 1 : Data, Restrictions and Functionality
- The social networking service must contain at least 15 users. 
- For every user we must enter all the registration data together with their profiles.
- Insert enough number of data in all the other matrices.
- The entry "email" in matrix Member must be if form of <username@domain_name>.
- During thw insertion of data in the matrix RECOMMENDATION_REQUEST it must be true the condition that the user for whom the recommendation letter has been writen belongs to the network of the user who writes it.
- Answers in questions are allowed to send only the users that belong to the network of the questioner.
- During the update of an invitation state and if that is accepted it must be created automatically the 2 professional network connections that correspond in a new interactive relationship.
- During the insertion of a new article there must be erased all the comments in articles that have been submitted one month ago.
- During the insertion or update advertisements for job offering there must be created messages to all the users who are interested in that job (according to the education level or the experience title).
- During the insertion or update of new advertisements for job seeking there must be created messages to all the users who offer that kind of job.
- If a user performs an insertion to the system and his subscription ha expired there must be erased all the advertisements for job seeking and for job offering that he has submit. Additionally, the deletion of an advertisement must triger the insertion of all the information for that advertisement in a matrix **log** that we have to create.
## Section 2 : Data Recovery
- Find users that where classmates with a specific user and they are not in his professional network yet. Classmates are consider all the people that stydied in the same college at the same time with the specific user.
- Find the users that are connected with a connection degree n (n=1, n=2, n=3) with a specific user.
- Find users that have submitted at least 2 articles.
- Find users that heve commented all the articles submitted by a specific user.
- Print articles and the number of comments per article.
- Find the educational level of all users who have submitted articles that have number of comments greater from the median number of comments per article.
- Find pairs <advertisement for job seeking, advertisement for job offering>, where the entries job type, industry, are the same and the entries salary are different up to (+/-) 10%.
- Find the professional network of a specific user.
## Calculations
- Number of comments for every user.
- Find the median of salary in advertisements for job seeking from users who have declare capability for working from far away.
- Total number of messages per month.
- Median number of days of response in recommendation requests that have been answered.
- Print users with the largest number of recommendation letters.
## Transactions
Now what happens if the social networking service database increases in users and we are asked to implement some restrictions in usage for every user which define that every user can accept only 10 messages, 5 connection applications and 5 recommendation requests per day. Additionally, the system is designed to enreach a new service which will be available for all the users of the social networking service database. We must create that new service as a transaction which will provide to an authorised administrator the capability to define a new time period (start and end date) when there will take place the operations below in the context of the trasnaction.
* Begin transaction.
* Find all members that have made comments on articles on that specific time period.
* For such a member and for every article that he has made a comment there must be performed the following operations
  - If the author of the article is connected to the specific user with connection degree 1 then,
    - If the user and the author have worked at the same time in the same company in the past a request will be created from the author to the user for a recommendation letter.
    - Endorsements will be inserted automatically from the author to the user for their common interests.
    - A thank you message will be sent automatically from the author to the commenter for the comments.
  - If the author of the article is connected to the specific user with connection degree 2 then,
    - A message will be sent automatically from the author containing the title of the last paper (matrix experience) with pasted (concatenation ||) the short resume which will accompany a connection request. 
    - A thank you message will be sent automatically from the author to the commenter for the comments.
  - If the user is not a member of the professional network of the author then,
    - A message will be sent automatically to the author having all the personal data of the user and the number of articles he has published in the same category.
    - A thank you message will be sent automatically from the author to the commenter for the comments.
  - In case of an error occurs during these actions due to the applicable space-per-user limitations, all actions for that particular user must be recalled.
* During the execution of the transaction information must be stored about the number of messages and recommendation requests that have been created. If this numbers leads to double the total number of messages or recommendation requests for that day then all actions will be canseled. In case of no messages or recommendation requests for a day, the transaction will be executed.
* Confirm the transaction.
## Indices and Clustering
**Indexing** and **clustering** ara two very important and useful techniques for optimizing the execution time of the querries in a database and consecuently in the section 2 of data recovery. Both of these techniques were implemented in this social networking service database in order to optimize the performance of the querries.
## External application using JDBC protocol
Now the goal is to build an external application in Java in order to export information about the functionality of the database and communicate with the database using the JDBC protocol. The external application was built in the **eclipse** environment which was connected to the PostgreSQL and the database. Also, the external application performs all kind of tasks since it can begin a transaction, cansel or confirm a transaction, find the professional network of the user with connection degree n, insert comment for a specific article and send message to another user. 





