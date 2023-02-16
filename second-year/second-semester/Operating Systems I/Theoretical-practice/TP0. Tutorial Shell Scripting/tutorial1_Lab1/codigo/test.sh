if [ $1 == suma ]
then
	echo "$2 + $3 = $(expr $2 + $3)";
elif [ $1 == resta ]
then
	echo "$2 - $3 = $(expr $2 - $3)";
else
	echo "No entiendo arg1 = $1"
	exit 1
fi
exit 0
