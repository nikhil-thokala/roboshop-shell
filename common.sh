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