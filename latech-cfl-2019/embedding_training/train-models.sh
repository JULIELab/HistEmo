#parameters as suggested by Hamilton et al., Diachronic Word Embeddings Reveal Statistical Laws of Semantic Change, ACL 2016
#assumes python 2 and correctly installed hyperwords with my customn extensions
HYPERWORD_PATH="/home/hellrich/hyperwords/omerlevy-hyperwords-688addd64ca2"
CONTEXT_WINDOW=4
SMOOTHING="0.75"
DIM="300"

function copy {
	#wieso nicht immer von base?
	local target_path=$1
	local from_name=$2
	local to_name=$3

	cp $target_path/${from_name}.words.vocab $target_path/${to_name}.words.vocab
	cp $target_path/${from_name}.contexts.vocab $target_path/${to_name}.contexts.vocab
}

function do_pmi {
	local source_path=$1
	local target_path=$2
	
	#PMI
	python $HYPERWORD_PATH/hyperwords/counts2pmi.py --cds $SMOOTHING $source_path/counts $target_path/pmi
	#PMI SVD
	python $HYPERWORD_PATH/hyperwords/pmi2svd.py --dim $DIM $target_path/pmi $target_path/svd_pmi
	copy $target_path pmi svd_pmi

	echo "finished $target_path pmi"
}

function do_sgns {
	local source_path=$1
	local target_path=$2
	#SGNS
	$HYPERWORD_PATH/word2vecf/word2vecf -train $source_path/pairs -pow $SMOOTHING -cvocab $source_path/counts.contexts.vocab -wvocab $source_path/counts.words.vocab -dumpcv $target_path/sgns.contexts -output $target_path/sgns.words -threads 10 -negative 5 -size $DIM
	python $HYPERWORD_PATH/hyperwords/text2numpy.py $target_path/sgns.words
	rm $target_path/sgns.words
	python $HYPERWORD_PATH/hyperwords/text2numpy.py $target_path/sgns.contexts
	rm $target_path/sgns.contexts

	echo "finished $target_path sgns"
}

function train {
	local source_path=$1
	local target_path=$2
	
	do_sgns $source_path $target_path
	do_pmi $source_path $target_path
}

function train_dta {
	models="dta/eacl2017/models"
	for decade in $models/*_*
	do
		echo "$decade"
		source_path=$decade/shared_v2
		target_path=$decade/v2
		mkdir -p $target_path
		train $source_path $target_path
	done
	echo "finished dta"
}

function train_coha {
	models="coha/models"
	for decade in $models/*0
	do
		echo "$decade"
		source_path=$decade/shared_v2
		target_path=$decade/v2
		mkdir -p $target_path
		train $source_path $target_path
	done
	echo "finished coha"
}

train_dta
train_coha
