#!/bin/bash

if [[ $# == [23] ]]; then
   drname="${1/\//}" # strip trailing forward slash
   id="$2"
   t=$3
   mkdir -p fastqced
   dr="fastqced"
   if [[ $# == 3 ]]; then
      n="$((50/$t))" 
      cat $id | sed 's/=/ /g' | awk -v d="$drname" '{print d"/"$1,d"/"$2}' | parallel echo "-t $t {} -o $dr" | xargs -P$n -n6 fastqc
   else
      cat $id | sed 's/=/ /g' | awk -v d="$drname" '{print d"/"$1,d"/"$2}' | parallel echo "-t 1 {} -o $dr" | xargs -P5 -n6 fastqc
   fi
   echo "Done! All results save in '$dr'"
else
   echo -e """
	Usage: runFastqc <dir> <list> <threads>
	
          dir: Path to Fastq files
         list: File containing paired fastq files separated by an equal (=) sign

	e.g. Note the difference in the fastq file names

	ERR1823587_\e[38;5;1m1\e[0m.fastq.gz=ERR1823587_\e[38;5;1m2\e[0m.fastq.gz
	CTRL1_S1_L001_\e[38;5;1mR1\e[0m_001.fastq.gz=CTRL1_S1_L001_\e[38;5;1mR2\e[0m_001.fastq.gz
	ERR1823588_\e[38;5;1m1\e[0m.fastq.gz=ERR1823588_\e[38;5;1m2\e[0m.fastq.gz
    """
fi