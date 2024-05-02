#!/bin/bash

source ./common.sh

check_root

echo "please enter DB password:"
read -s mysql_root_password
  
  dnf install mysql-serddver -y &>>$LOGFILE
  

  systemctl enable mysqld &>>$LOGFILE
 

 systemctl start mysqld  &>>$LOGFILE
 

#Below code will be useful for idempotent nature
 mysql -h db.daws78s.online -uroot -pExpenseApp@1 -e 'SHOW  DATABASES
 if [ $? -ne 0 ]
 then
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
    VALIDATE $? "MYSQL Root password Setup"
else
    echo -e "MYSQL Root password is already setup...$Y SKIPPING $N"
fi
