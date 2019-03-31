# Setting up and training the model

1. Clone the code for the example model
	1. ```git clone https://github.com/yuanqing811/ISIC2018```
1. Download and stage the data for the sample model
	1. Execute ```backend/util/download_data.sh <path to /data in ISIC2018 repo>``` from this repo
	1. Example: ```download_data.sh ~/ISIC2018/datasets/ISIC2018/data```
1. Edits to ISIC2018 repo to avoid runtime errors
	1. Edit ```datasets/ISIC2018/__init__.py```
		1. Line 135 set ```anti_aliasing=False```
	1. Edit ```runs/cls_train.py```
		1. Line 130 set ```verbose=0```
		1. If you want to reduce the training time at risk of decreasing accuracy, on line 28 set ```num_folds = 1```
1. Navigate to root of ISIC2018 repo
1. Pre-process the image data
	1. ```pip install -r requirements.txt```
	1. ```export PYTHONPATH="$PYTHONPATH:<root of ISIC2018 repo>"```
	1. ```python datasets/ISIC2018/preprocess_data.py```
		1. This took 1-2hrs on our t2.large size ec2 instance
1. Train the example model
	1. ```python runs/cls_train.py```
		1. This did not complete in 12 hours on our t2.large size ec2 instance
