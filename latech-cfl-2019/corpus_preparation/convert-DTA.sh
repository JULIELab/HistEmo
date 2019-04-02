#for x in eacl2017/*
#do
#	python train_word2vec.py $x
#done

function subcorpus {
	local from=$1
	local step=$2
	local to=$3
	local target=$4
	mkdir -p $target
	for x in $(seq $from $step $to)
	do
		y=$(($x+$step-1))
		rm -f $target/${x}_$y
		for year in $(seq $x $y)
		do
			for f in dta_kernkorpus_2016-05-11_lemma/*_$year
			do
				tr '\n' ' ' < $f >> $target/${x}_$y
				echo "" >> $target/${x}_$y
			done
		done
	done
	wc -w $target/*_* > $target/log
	cat $target/log
}

subcorpus 1660 30 1899 eacl2017/lemmatized