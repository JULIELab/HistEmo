######DIFFERENCE: THRESHOLD 10 instead of 100 for being modelled
#parameters as suggested by Hamilton et al., Diachronic Word Embeddings Reveal Statistical Laws of Semantic Change, ACL 2016
#assumes python 2 and correctly installed hyperwords with my customn extensions
HYPERWORD_PATH="/home/hellrich/hyperwords/omerlevy-hyperwords-688addd64ca2"
CONTEXT_WINDOW=4


function prepare {
	local source_path=$1
	local old_target_path=$2
	local target_path=${old_target_path}_v2
	mkdir -p $target_path
	rm -f $target_path/*
	# lowercase , remove non alphanumeric, replace multi space, remove empty lines	
	cp $old_target_path/clean $target_path/clean 
	python $HYPERWORD_PATH/hyperwords/corpus2pairs.py --win $CONTEXT_WINDOW --thr 10 $target_path/clean > $target_path/pairs
	$HYPERWORD_PATH/scripts/pairs2counts.sh $target_path/pairs > $target_path/counts
	python $HYPERWORD_PATH/hyperwords/counts2vocab.py $target_path/counts
}

function prepare_dta {
	_target="dta/eacl2017/models"
	_source="dta/eacl2017/lemmatized"
	for source_path in $_source/*_*
	do
		echo "$source_path"
		name=$(basename $source_path)
		target_path=$_target/$name/shared
		prepare $source_path $target_path
	done
	echo "finished DTA"
}

function prepare_coha {
	_target="coha/models"
	_source="coha/decades-lemma"
	for source_path in $_source/${x}*0
	do
		echo "$source_path"
		name=$(basename $source_path)
		target_path=$_target/$name/shared
		prepare $source_path $target_path
	done
	echo "finished COHA"
}


prepare_dta &
prepare_coha &
#context = 4, dimension=300, smoothing 0.75 , neg 0 (SVD) or 5 (other), no subsampling, min freq = 100 (default)
