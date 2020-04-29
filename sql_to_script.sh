#!/bin/bash
# Given a list of .sql files, generates bash scripts to run the queries against a database
# S Gardiner
# 2020-04-15

database=world_x
user=awkologist

for snippet in $@; do
	filename=${snippet%.sql}.sh
	echo "#!/bin/bash
echo \"$(cat ${snippet})\"

mysql -p -u $user $database -e \"
$(cat $snippet)\"" > ${filename}
chmod +x ${filename}
done

