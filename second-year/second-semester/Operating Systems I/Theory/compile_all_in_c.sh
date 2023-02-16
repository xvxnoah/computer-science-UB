files=$(ls *.c)

for i in $files;
do
    gcc $i -o ${i%\.c}
done
