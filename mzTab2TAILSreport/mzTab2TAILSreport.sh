# Script to create duplex report from .consensusXML results

#!/bin/sh

# script directory
SCRIPT_PATH=$(dirname -- "$(readlink -f -- "$0")")

if [[ $1 == "" ]]
then
echo "Please specify a file."
exit
fi

# input file
FILE=$1; shift
FILE_ABSOLUTE=$(readlink -f -- $FILE)
FILE_PATH=$(dirname $FILE_ABSOLUTE)
FILE_BASE=$(basename $FILE_ABSOLUTE)
FILE_NAME=${FILE_BASE%.*}

if ! [[ -f $FILE ]]
then
echo "File does not exist."
exit
fi

echo 'Generating TAILS report from mzTab file '$FILE_ABSOLUTE'.'
cd $SCRIPT_PATH

# copy mzTab
cp $FILE_ABSOLUTE data.mzTab

# Run the R code
R -e "Sweave('mzTab2TAILSreport.Snw')"

pdflatex mzTab2TAILSreport.tex

mv mzTab2TAILSreport.pdf $FILE_PATH/$FILE_NAME.pdf
mv data.tsv $FILE_PATH/$FILE_NAME.tsv

# clean-up
rm data*
rm FcLogIntensity*
rm frequency*
rm *.aux
rm *.ini
rm *.log
rm *.out
rm *.tex

cd $CURRENT_PATH