#!/bin/bash

SOURCE ./common.sh

check_root()

echo "Please enter DB password:"
read -s mysql_root_password
  
  dnf install mysql-server -y &>>$LOGFILE
  VALIDATE $? "Installing MYSQL Server"

  systemctl enable mysqld &>>$LOGFILE
  VALIDATE $? "Enabling MYSQL Server"

 systemctl start mysqld  &>>$LOGFILE
  VALIDATE $? "Starting MYSQL Server"

#  mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$logfile
#  VALIDATE $? "etting up root password"


#Below code will be useful for idempotent nature
 mysql -h db.daws-78s.online -uroot -pExpenseApp@1 -e 'SHOW  DATABASES
 if [ $? -ne 0 ]
 then
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
    VALIDATE $? "MYSQL Root password Setup"
else
    echo -e "MYSQL Root password is already setup...$Y SKIPPING $N"
fi
