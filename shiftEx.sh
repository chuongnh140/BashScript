#!/bin/bash


#SHIFT dùng để dịch vị trí $1, vị trí bên trái sẽ bị bỏ đi
#SHIFT 2 là bỏ đi 2 vị trí, bắt đầu từ $3 sẽ là $1
# total number of command-line arguments
echo "Total arguments passed are: $#"

# $* is used to show the command line arguments
echo "The arguments are: $*"

echo "The First Argument is: $1"
shift 3

echo "The First Argument After Shift 2 is: $1"
shift

echo "The First Argument After Shift is: $1"