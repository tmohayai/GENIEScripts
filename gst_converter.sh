# bash script to convert the ghep format to gst
# the script would run in a sub-directory within the same directory as the ghep files 

for ((c=0; c<=100; c++ ))
do
        gntpc -i ../neutrino.$c.ghep.root -f gst
done
