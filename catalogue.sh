source common.sh

print_head "configure NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Install NodeJS"
yum install nodejs -y &>>${log_file}

print_head "Create Roboshop User"
useradd roboshop &>>${log_file}

print_head "Create application Directory"
mkdir /app &>>${log_file}

print_head "Removing Old Files"
rm -rf /app/* &>>${log_file}

print_head "Downloading App Content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app

print_head "Extracting App Content"
unzip /tmp/catalogue.zip &>>${log_file}

print_head "Installing NodeJs Dependencies"
npm install &>>${log_file}

print_head "copying SystemD Service file"
cp configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}

print_head "enable SystemD"
systemctl enable catalogue &>>${log_file}

print_head "Restart SystemD"
systemctl restart catalogue &>>${log_file}

print_head "copy MongoDB Repo File"
cp configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

print_head "Installing Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}

print_head "Loading Schema"
mongo --host mongodb.devopsjob.online </app/schema/catalogue.js &>>${log_file}