#!/bin/bash


echo "Please enter DB password:"
read -s mysql_root_password

echo "Please enter DB password:"
read -s mysql_root_password

  dnf module disable nodejs -y &>>$LOGFILE
  VALIDATE $? "Disabling default nodejs"

  dnf module enable nodejs:20 -y &>>$LOGFILE
  VALIDATE $? "Enabling nodejs:20 version"

  dnf install nodejs -y &>>$LOGFILE
  VALIDATE $? "Installing nodejs"

 id expense  &>>$LOGFILE
 if [ $? -ne 0 ]
 then
    useradd  expense &>>$LOGFILE
    VALIDATE $? "creating expense user"
else
    echo -e "Expense user already created...$Y SKIPPING $N"
fi 

mkdir -p /app  &>>$LOGFILE
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Downloading backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip  &>>$LOGFILE
VALIDATE $? "Extracted backend code"

npm install  &>>$LOGFILE
VALIDATE $? "Installing nodejs dependencies"

#check your repo and path
cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service
VALIDATE $? "copied backend service"

systemctl daemon-reload  &>>$LOGFILE
VALIDATE $? "Daemon Reload"

systemctl start backend  &>>$LOGFILE
VALIDATE $? "starting backend"

systemctl enable backend  &>>$LOGFILE
VALIDATE $? "Enabling backend"

dnf install mysql -y  &>>$LOGFILE
VALIDATE $?"Installing MYSQL Client"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -p${mysql_root_password} < /app/schema/backend.sql  &>>$LOGFILE
VALIDATE $? "Schema loading"

systemctl restart backend  &>>$LOGFILE
VALIDATE $? "Restarting Backend