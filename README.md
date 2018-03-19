# sftpserver
Creating and saving sftp user data in the mysql

2018-03-19: editing
I got create the file that missed, createaccount.sh, to system work fine.

Createaccount.sh executing it with 3 variables, will read the instruction to create structure folders and then create the accounts and generate two automatically passwords to insert the new users created, inserting new users to .conf ssftp system file and for finishing, saving all data in database mysql to help BI Team query that information in the future.

The system hadn't this features;
1 - shoot automatically emails
2 - storaging data in local database

This file was my first bash shellscript contact.
