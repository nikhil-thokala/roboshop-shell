source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing MySQL Root Password argument\e[0m"
  exit 1
fi

print_head"Disabling MySQL 8 Version"
dnf module disable mysql -y
status_check$?

print_head"Installing MySQL Server"
yum install mysql-community-server -y
status_check$?

print_head"Enabling MySQL Service"
systemctl enable mysqld
status_check$?

print_head"Start MySQL Service"
systemctl start mysqld
status_check$?

print_head"Set Root Password"
mysql_secure_installation --set-root-pass $(mysql_root_password)
status_check$?