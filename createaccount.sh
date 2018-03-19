# Creating enviromments with folders and creating accounts

if [ -z "$3" ]; then
	echo "To create: name_company country email_address_to_receive_data"
	exit 1;
fi

cd /home/rcvaultadmin/

company=$1
country=$2
email_address=$3

# creating users
useradd $company\_admin 
useradd $company\_out 

# creating company's groups
groupadd $company\_admin
groupadd $company\_out

# creating company's "home" dir
mkdir /home/rcvault/$company
mkdir /home/bucket2/rcvault/$company/


# Creating automatically passwords to new users
pass_admin=`date +%s%N | sha256sum | base64 | head -c 10 ; echo`
echo $pass_admin
echo $pass_admin | passwd $company\_admin --stdin
pass_out=`date +%s%N | sha256sum | base64 | head -c 10 ; echo`
echo $pass_out
echo $pass_out | passwd $company\_out --stdin


# creating template config files
touch  $company.user.conf
cat sshd_config.template > /etc/ssh/sshd_config
cat *.user.conf >> /etc/ssh/sshd_config
service sshd restart


# Command to send the email
echo -e "To: ${mail_address}\nSubject:EC2 - User created in sftp from billing\nHello there! The user was created from rcvault server. \n\n\nUser: $company_in with Password: $passwords_in and $company_out with Password: $passwords_out\n HAVE NICE DAY" > mail.txt
ssmtp ${mail_address} < mail.txt

echo "Email sent with success to $mail_address"

# Inserting data, users and passwords in database
mysql -u root -pYOURPASSWORDS -e "use sftpdb;

Insert INTO rcvault (user,password,country,email) VALUES ($company_in,$pass_admin,$country,$email_address);
Insert INTO rcvault (user,password,email) VALUES ($company_out,$pass_out,$country,$email_address);

+echo -e "User $company_in and $company_out created with success"
