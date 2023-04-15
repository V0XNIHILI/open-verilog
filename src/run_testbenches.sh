# Make a list of all (nested) files that end in _tb.v
# and run them through the testbench generator

TB_LIST=`find . -name "*_tb.v" | sort`

for tb in $TB_LIST
do
    FILE_NAME=`basename $tb`
    echo "\nRunning testbench for $FILE_NAME:"
    
    # cd into the directory of the testbench
    cd `dirname $tb`/../

    iverilog -o "$FILE_NAME.iv" ./tb/$FILE_NAME && vvp -N "$FILE_NAME.iv"
    
    EXIT_CODE=$?

    if [ $EXIT_CODE -ne 0 ]; then
        echo "Testbench failed with exit code $EXIT_CODE"
        exit $EXIT_CODE
    fi

    echo "Testbench $FILE_NAME passed!"
    
    cd ../
done

echo "\nAll testbenches passed!"
