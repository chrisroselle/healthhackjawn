

## Setting up and training the model
**Unfortunately, our model did not finish training before the end of the event. As a result, this code has instead mocked the response**
1. Clone the code for the example model
	1. `git clone https://github.com/yuanqing811/ISIC2018`
1. Download and stage the data for the sample model
	1. Execute `backend/util/download_data.sh <path to /data in ISIC2018 repo>` from this repo
	1. Example: `download_data.sh ~/ISIC2018/datasets/ISIC2018/data`
1. Edits to ISIC2018 repo to avoid runtime errors
	1. Edit `datasets/ISIC2018/__init__.py`
		1. Line 135 set `anti_aliasing=False`
	1. Edit `runs/cls_train.py`
		1. Line 130 set `verbose=0`
		1. If you want to reduce the training time at risk of decreasing accuracy, on line 28 set `num_folds = 1`
1. Navigate to root of ISIC2018 repo
1. Pre-process the image data
	1. `pip install -r requirements.txt`
	1. `export PYTHONPATH="$PYTHONPATH:<root of ISIC2018 repo>"`
	1. `python datasets/ISIC2018/preprocess_data.py`
		1. This took 1-2hrs on our t2.large size ec2 instance
1. Train the example model
	1. `python runs/cls_train.py`
		1. This did not complete in 12 hours on our t2.large size ec2 instance



## Running the python backend service

```
cd backend
python service.py
```



## Running the ShinyApp frontend

### Running ShinyApp Locally
1. Install R and RStudio
1. Install all the packages given in `HKJWebApp/global.R`
1. Set up YELP API key and include it in a config.yml file as shown format shown below
1. Change your working directory to `HKJWebApp/` and run the application with `shiny::runApp(launch.browser = TRUE)`

### Sample config.yml file
**note the additional new line after the last line is important**  
The api_endpoint should point to the python backend.

```yaml
default:
    yelp_key: <Your YELP API KEY>
    api_endpoint: 'http://ec2-52-14-190-7.us-east-2.compute.amazonaws.com:8080/api/result'

```

### To Access the Running Web Application
The application is deployed to https://shinyapps.io - a free to use hosting service by RStudio with preconfigered Shiny servers. A sample instance is deployed at this URL: https://sakash.shinyapps.io/hkjwebapp/




## Potential issues:
We had trouble running the app locally because access to port 8080 was blocked on the wifi network in the event venue. Once deployed to shinyapps.io (which is inturn hosted on AWS), everything worked fine.

