#mag_1989_329375.txt

rm -rf decades-lemma
mkdir -p decades-lemma
for decade in $(seq 1810 10 2009)
do
	(
	end=$(($decade + 9))
	for year in $(seq $decade 1 $end)
	do
		python combine-decades-lemma.py wlp/*_${year}_*.txt >> decades-lemma/$decade
	done
	echo "finished $decade"
	) &
done
