source common.sh

print_head "setup Mongodb repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "Install Mongodb"
yum install mongodb-org -y

print_head "Update MongoDB Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

print_head "enabling Mongodb"
systemctl enable mongod

print_head "Start Mongodb Service"
systemctl start mongod

# update /etc/mongod.conf file from 127.0.0.1 with 0.0.0.0