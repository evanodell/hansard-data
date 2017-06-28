# Hansard Speeches and Sentiment


[![GitHub tag](https://img.shields.io/github/tag/evanodell/hansard-data.svg)](https://github.com/evanodell/hansard-data)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.780985.svg)](https://doi.org/10.5281/zenodo.780985)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

Repository for a public dataset of speeches in the Hansard. The dataset provides information on each speech of ten words or longer, made in the House of Commons between 1980 and 2016, with information on the speaking MP, their party, gender and age at the time of the speech. The dataset also includes all speeches of ten words made from 1936 to 1980, for a total of 4,212,134 speeches and 773,585,770 words. More information on the dataset is available [here](https://evanodell.com/projects/datasets/hansard-data/). The dataset itself can be accessed through [Zenodo](http://doi.org/10.5281/zenodo.376839).

The speeches have been classified for sentiment using a total of four libraries from the R package [`lexicon`](https://cran.r-project.org/package=lexicon), one from [`syuzhet`](https://cran.r-project.org/package=syuzhet) and  one from [this paper](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0168843). All six scores used the method from the [`sentimentr`](https://cran.r-project.org/package=sentimentr) package. The libraries are:

1. The [AFINN](http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010) library by Finn Årup Nielsen, labelled `afinn`. The AFINN library was accessed through the [`syuzhet`](https://cran.r-project.org/package=syuzhet) package.

2. The [Opinion Mining, Sentiment Analysis and Opinion Spam Detection](https://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html) dataset by Bing Liu, Minqing Hu and Junsheng Cheng, labelled `bing`. The Bing library was access through the [`syuzhet`](https://cran.r-project.org/package=syuzhet) package.

3. The [NRC Word-Emotion Association Lexicon](http://saifmohammad.com/WebPages/lexicons.html), library by Saif M. Mohammad, labelled `nrc`. The NRC library was access through the [`syuzhet`](https://cran.r-project.org/package=syuzhet) package.

4. The [Sentiwords](http://sentiwordnet.isti.cnr.it/) dataset, created by Stefano Baccianella, Andrea Esuli, and Fabrizio Sebastiani. The Sentiwords library was accessed through the library was accessed through the [`lexicon`](https://cran.r-project.org/package=lexicon) package.

5. The Hu & Liu dataset, by Minqing Hu and Bing Liu, labelled `Hu`. The Hu & Liu library was accessed through the [`sentimentr`](https://cran.r-project.org/package=sentimentr) package.

6. A modified version of the [unnamed lexicon](https://github.com/lrheault/emotion) from the paper [_Measuring Emotion in Parliamentary Debates with Automated Textual Analysis_](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0168843), labelled `rheault`. As the method in `sentimentr` does not use distinguish between the same word that can occupy multiple lexical categories, I used the average polarity score assigned to such words.


## Notes

The data used to create this dataset was taken from the [parlparse](https://github.com/mysociety/parlparse) project operated by [They Work For You](https://www.theyworkforyou.com/) and supported by [mySociety](https://www.mysociety.org/).  

The dataset is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/80x15.png" /></a>

The code included in this repository is licensed under an [MIT license](https://github.com/EvanOdell/hansard-speeches-and-sentiment/blob/master/LICENSE).

 Please contact me if you find any errors in the dataset. The integrity of the public Hansard record is questionable at times, and while I have improved it, the data is presented 'as is'.
