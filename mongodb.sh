source common.sh

print_head "setup Mongodb repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Install Mongodb"
yum install mongodb-org -y &>>${log_file}

print_head "Update MongoDB Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}

print_head "enabling Mongodb"
systemctl enable mongod &>>${log_file}

print_head "Start Mongodb Service"
systemctl start mongod &>>${log_file}

# update /etc/mongod.conf file from 127.0.0.1 with 0.0.0.0