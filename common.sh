code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -rf ${log_file}

print_head() {
  echo -e "\e[36m$1\e[0m"
}

status_check()
  {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
    echo "Read the file ${log_file} for more information about the error"
    exit 2
    fi
  }


schema_setup() {
  if [ "$(schema_type)" == "mongo" ]; then
     print_head "copy MongoDB Repo File"
     cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
     status_check $?

     print_head "Installing Mongo Client"
     yum install mongodb-org-shell -y &>>${log_file}
     status_check $?

     print_head "Loading Schema"
     mongo --host mongodb.devopsjob.online </app/schema/${component}.js &>>${log_file}
     status_check $?
  fi
}

nodejs() {
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
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
status_check $?
cd /app

print_head "Extracting App Content"
unzip /tmp/${component}.zip &>>${log_file}
status_check $?

print_head "Installing NodeJs Dependencies"
npm install &>>${log_file}
status_check $?

print_head "copying SystemD Service file"
cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
status_check $?

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable ${component} service"
systemctl enable ${component} &>>${log_file}
status_check $?

print_head "Restart ${component} service"
systemctl restart ${component} &>>${log_file}
status_check $?

schema_setup
}
