source common.sh

print_head "configure NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install NodeJS"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Create Roboshop User"
id roboshop &>>${log_file}
 if [ $? -ne 0 ]; then
useradd roboshop &>>${log_file}
 fi
status_check $?

print_head "Create application Directory"
 if [ ! -d /app ]; then
mkdir /app &>>${log_file}
 fi
status_check $?

print_head "Removing Old Files"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Downloading App Content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?
cd /app

print_head "Extracting App Content"
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head "Installing NodeJs Dependencies"
npm install &>>${log_file}
status_check $?

print_head "copying SystemD Service file"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable SystemD"
systemctl enable catalogue &>>${log_file}
status_check $?

print_head "Restart SystemD"
systemctl restart catalogue &>>${log_file}
status_check $?

print_head "copy MongoDB Repo File"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

print_head "Installing Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Loading Schema"
mongo --host mongodb.devopsjob.online </app/schema/catalogue.js &>>${log_file}
status_check $?