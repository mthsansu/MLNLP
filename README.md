# Parlementarian Sentiment Analysis - Machine Learning for Natural Language Processing
## Mathis SANSU and Yasmine HOURI - ENSAE 2022
### Instructor and Lecturer: Benjamin Muller
### Lab supervisor: Roman Castagne

Visit https://nlp-ensae.github.io/

Detailed project instructions can be found here: https://docs.google.com/document/d/1ijqISks5L_ioZwJi-VIRx5JLxk01Ao8wLYkN7L-R4RE/edit

This project is a natural language processing analysis of the emotions expressed by the French members of parliament on Twitter.

## Data
**Tweets by the French members of parliament (MPs) of the 15th legislature in the Vth Republic (2017-2022)**

We create a list of the Twitter handles of MPs thanks to several data sources: database from previous academic research, scraping from website Nosdeputes.fr, and manual updates. This list is saved in a csv file.

We use the Academic Research Product Track V2 API Endpoint of Twitter (https://developer.twitter.com/en/portal/dashboard). We use the R-package ‘academictwitteR’ (https://cran.r-project.org/web/packages/academictwitteR/index.html) to extract all tweets of MPs of the current legislature (2017-2022), using the function ‘get_all_tweets’. We can provide the R code on demand. After merging the database on all MPs, we obtain a complete RDS dataframe, where each line corresponds to a single tweet. From another academic database, we also joined sociodemographic and political variables about MPs. We attached the first 100 lines of this database to this email.

The final database is then composed of around 50 variables (tweets content, metrics on tweets, tweets and authors identifiers, sociodemographic and political variables, etc.), one row corresponding to a unique tweet. For now, with a database ranging from May 2017 to December 2021, it counts almost 2M tweets.

## Key questions
**Which emotions do MPs express in their tweets? Which words are more frequently linked to which emotions? Are there key periods in time when MPs instrumentalize emotions more than usual (election campaigns, …)? What other elements does CamemBERT shed light on (syntax, …)?**

## Tasks
1. First and foremost, we exclude retweets from our database, and work only with tweets and answers to other tweets, all in French.
2. From this refined database, we extract the three following datasets: {'Tweets_sample_benalla.csv': from April 2018 to August 2018, 'Tweets_sample_CDM.csv': from June 2018 to August 2018, 'Tweets_sample_confinement.csv': from March 2020 to May 2020}. 
4. Then, we define the emotion labels we intend to use as follows: {0: neutral, 1: negative, 2: positive}, and we manually annotate a sample of our data of size 1000, in order to fine-tune CamemBERT and adapt it to our corpus.
6. At this point, we build a task-specific model to perform a sentiment analysis on French textual data, which uses FastText and CamemBERT as word_embedding techniques. We then train it on our manually annotated dataset. In order to do so, we adopt the usual training procedure: we randomly split our data into three sets (train, test and validation), and then train, test and validate on each set respectively.
7. We evaluate the performances of our model with quantitative and qualitative tools.
8. In order to further evaluate the performance of our model, we compare it to a baseline model, which is one of the simplest models that can be built to solve this task.

The conclusions of our analyis can be found in the report.
