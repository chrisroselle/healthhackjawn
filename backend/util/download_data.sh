#!/bin/bash
if [[ -z $1 ]]; then
	echo "USAGE: $0 <path to data directory of ISIC2018 project>" >&2
	echo "See README at https://github.com/yuanqing811/ISIC2018" >&2
	echo "EXAMPLE: $0 ~/ISIC2018/datasets/ISIC2018/data" >&2
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo "FATAL ERROR - $1 is not a directory" >&2
	exit 1
fi

ISIC_DATA_DIR=$1

download(){
        curl -L $1 --output $2
}

# Task 1
[[ ! -f training_data_task1.zip ]] && download https://challenge.kitware.com/api/v1/item/5ac37a9d56357d4ff856e176/download training_data_task1.zip
[[ ! -f ground_truth_task1.zip ]] && download https://challenge.kitware.com/api/v1/item/5ac3695656357d4ff856e16a/download ground_truth_task1.zip
[[ ! -f test_data_task1.zip ]] && download https://challenge.kitware.com/api/v1/item/5b32644c56357d41064dab4b/download test_data_task1.zip
[[ ! -f final_test_data_task1.zip ]] && download https://challenge.kitware.com/api/v1/item/5b32662756357d41064dab51/download final_test_data_task1.zip

# Task 2
[[ ! -f training_data_task2.zip ]] && download https://challenge.kitware.com/api/v1/item/5ac37c6356357d4ff856e179/download training_data_task2.zip
[[ ! -f ground_truth_task2.zip ]] && download https://challenge.kitware.com/api/v1/item/5ae1d97856357d4ff8570ca0/download ground_truth_task2.zip
[[ ! -f test_data_task2.zip ]] && download https://challenge.kitware.com/api/v1/item/5b32645556357d41064dab4e/download test_data_task2.zip
[[ ! -f final_test_data_task2.zip ]] && download https://challenge.kitware.com/api/v1/item/5b32667856357d41064dab54/download final_test_data_task2.zip

# Task 3
[[ ! -f training_data_task3.zip ]] && download https://challenge.kitware.com/api/v1/item/5ac20fc456357d4ff856e139/download training_data_task3.zip
[[ ! -f ground_truth_task3.zip ]] && download https://challenge.kitware.com/api/v1/item/5ac20eeb56357d4ff856e136/download ground_truth_task3.zip
[[ ! -f test_data_task3.zip ]] && download https://challenge.kitware.com/api/v1/item/5b1c1c7256357d41064da302/download test_data_task3.zip
[[ ! -f final_test_data_task3.zip ]] && download https://challenge.kitware.com/api/v1/item/5b1c200656357d41064da305/download final_test_data_task3.zip

[[ ! -f ISIC2018_Task3_Training_LesionGroupings.csv ]] && download https://challenge.kitware.com/api/v1/file/5b0858b456357d4ff8575164/download 

for n in 1 2 3; do
	for file in training_data_task ground_truth_task test_data_task final_test_data_task; do
		unzip ${file}${n}.zip -d ${ISIC_DATA_DIR:?} && rm ${file}${n}.zip
	done
done

# stage extra file
# https://forum.isic-archive.com/t/task-3-supplemental-information/430
mv ISIC2018_Task3_Training_LesionGroupings.csv ${ISIC_DATA_DIR:?}/ISIC2018_Task3_Training_GroundTruth/

echo "Staging of ISIC data complete!"

