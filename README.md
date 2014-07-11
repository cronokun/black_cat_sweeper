black_cat_sweeper
=================

Script for cleaning duplicating/invalid data for BCD

### Rules

1. **Duplications**

 1.1. title and address are same

 1.2. prefer records with address

2. **Empty**

 2.1. only title and phone persist

 2.2. empty address, email, url, phone

 2.3. empty title, url, address

 2.4. title is number and empty url

3. **Rubbish**

 3.1. is_dead is true

 3.2. same title and url

 3.3. same title and email

4. **Suspicious**

 4.1. contains `test`

 4.2. url doesn't contain numeric title
