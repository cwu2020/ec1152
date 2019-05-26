# ec1152
using google datacommons feature selection to predict census tract-level social mobility

EC1152 Empirical Project 4: Using Google DataCommons to Predict Social Mobility
Carra Wu
Part 1
5. Summary Statistics
Variable Name	Label	Mean	Std Dev.
personagey~g	Language Spoken At Home— Asian And Pacific Island	0.0023283	0.0045491
personagey~u	Educational Attainment— Doctorate Degree	0.0061354	0.006269
v4	Language Spoken At Home— Other Languages	0.0028614	0.0210205
personagey~m	Veteran Status	0.0692684	0.021975
v6	Educational Attainment— Regular High School Diploma	0.1948594	0.0450406
personagey~i	Foreign Born Status	0.050153	0.0596825
v8	US Native, Spanish Spoken at Home	0.0583751	0.1466602
persongend~e	Female	0.5051076	0.0269536
v13	Foreign Born, Only English Spoken at Home	0.0096834	0.009656
v14	Only English Spoken at Home	-0.000033	0.0000261
v15	Educational Attainment: Master’s Degree	0.0396131	0.0212971
v16	Educational Attainment: Bachelor’s Degree	0.0967177	0.0414841
housinguni~s	Owner Occupied Housing	0.5994186	0.919306
housinguni~w	Renter Occupied Housing With Cash Rent	0.2233599	0.0860562

6. There is a strong positive relationship between the rate of doctorate degree attainment and social mobility as well as between the rate of bachelor’s degree attainment and social mobility, with regression coefficients of 0.959231 and 0.8773028, respectively. Somewhat surprisingly, there’s a strong negative relationship between rate of master’s degree attainment and social mobility, with a regression coefficient of -0.9051331. All other predictors show weak positive and negative correlations with social mobility, with the exception of the “Only English Spoken at Home” variable, which we discuss in question 8.

7. The slope of the scatter plot looks like it generally follows the 45-degree line, which indicates that my linear regression model predicts the variation in median income for children growing up in the 25th percentile pretty well. There is constant dispersion throughout. The R2 value is 0.3907, which means about 40% of the variation in social mobility is explained by my 14-predictor regression model.
 

Part 2

8. For the full predictor set, the linear regression predicts the variation in median income for children growing up in the 25th percentile even better than the 14 variable predictor set does, since the scatter plot displays a tighter fit to the 40-degree line. However, there is some dispersion around the 30th percentile, which indicates our regression is not a good predictor for kids who end up at the 30th percentile in adulthood. The R2 value is 0.87, which means that 87% of the variation in social mobility is explained by the full predictor linear regression model.

One interesting regression result is that there is a strong negative relationship between social mobility and the rate at which “only English” is spoken at home. The regression coefficient is a whopping -123.2935 with a standard error of 38.84754.
 

9. The first split is P_57>=14.75, which is the “Percent of Adults That Report Fair or Poor Health (Persons 18 Years and Over).” The first split in a decision tree is often the most important predictor of outcomes because it is the very best binary split out of all the predictor variables—that is, it divides the data into two subsets that minimizes the in-sample MSE. 

10. Using as many splits as possible may lead to overfitting of the model to the in-sample data (for example, splitting by name in the Titanic dataset from section) Cross validation allows us to choose an optimal tree depth, so that our decision tree will perform well on data that isn’t used to construct the tree.

11. The random forest predicts a mean of 0.4130, which is to say that the predicted average outcome for children whose parents were at the 25th percentile of the national income distribution in each county was to end up at the 41st percentile.

Min.	1st Quartile	Median	Mean	3rd Quartile	Max.
0.2831	0.3861	0.4120	0.4130	0.4369	0.5400

12. In-Sample Mean Squared Errors:
Random Forest Prediction MSE (Question 11)	0.004271803
OLS Prediction MSE (Question 8)	0.0003477129
Decision Tree Prediction MSE (Question 9)	0.0007511369

13. Because the OLS regression from question 8 performed the best (had the smallest mean squared error) in-sample, I expect it to similarly outperform the forest and decision tree models out-of-sample.

Part 3

14. Out-of-Sample Mean Squared Errors:
Random Forest Prediction MSE (Question 11)	0.003974762
OLS Prediction MSE (Question 8)	0.0005073468
Decision Tree Prediction MSE (Question 9)	0.001005525

15. Summary
In this project, we leveraged data from Google DataCommons in order to predict intergenerational mobility, measured as the mean rank of a child whose parents were at the 25th percentile of the national income distribution in each county. Generating this type of prediction from other variables enables us to build valuable forecasts of upward mobility before data on each generation becomes available. This information allows us to pursue data-driven interventions and civic planning initiatives sooner.

In an effort to construct the best predictions of this outcome using other variables, we implemented three different types of machine learning methods: linear regression, decision trees, and random forests. From the Google DataCommons, I selected 14 county level variables and merged them with the other 121 predictors given in the Opportunity Atlas dataset (Language Spoken At Home— Asian And Pacific Island, Educational Attainment— Doctorate Degree, Language Spoken At Home— Other Languages, Veteran Status, Educational Attainment— Regular High School Diploma, Foreign Born Status, US Native with Spanish Spoken at Home, Female, Foreign Born with Only English Spoken at Home, Only English Spoken at Home, Educational Attainment: Master’s Degree, Educational Attainment: Bachelor’s Degree, Owner Occupied Housing, and Renter Occupied Housing With Cash Rent)

The mean squared errors of each prediction method against the actual measure of intergenerational mobility in the sample and test datasets are listed in the table below.

In the out-of-sample test data, the linear regression (OLS) model did best, which is consistent with the results from the in-sample training data. 

One thing to note is that it is surprising that in both the in-sample and out-of-sample datasets, the decision tree performed better than randomized forest. Because the randomized forest gives the average across many different trees, one would expect that it would outperform the decision tree, which might be overfitted to the training data. In this case, the decision tree vastly outperforms the random forest, which might indicate that the training and test data have very similar qualities.

Regression Model	In-Sample MSE	Out-of-Sample MSE
Random Forest Prediction (Question 11)	0.004271803	0.003974762
OLS Prediction MSE (Question 8)	0.0003477129	0.0005073468
Decision Tree Prediction MSE (Question 9)	0.0007511369	0.001005525
