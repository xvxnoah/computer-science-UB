
# Heart disease prediction using Random Forests
# 
# This code is accompanied with several tips including classes, functions and methods to use. Please note that you do not have to follow these tips, but they might be handy in some cases.
# 
# Author: Polyxeni Gkontra (polyxeni.gkontra@ub.edu)

import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.utils import shuffle
from sklearn.preprocessing import OrdinalEncoder, MinMaxScaler
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import RandomForestClassifier
from sklearn.pipeline import Pipeline
from sklearn.metrics import classification_report, roc_auc_score
from sklearn.metrics import accuracy_score
from matplotlib import pyplot as plt

# Read the .csv file with the patient information (TIP: you can use method [read_csv](https://pandas.pydata.org/docs/reference/api/pandas.read_csv.html) from pandas) 
df = pd.read_csv('hd_data.csv')

# Explore your data. E.g. Print the data or few lines to see how it looks like (TIP: If you want to see just few lines consider method [head()](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.head.html#pandas.DataFrame.head) from pandas. Attribute [dtypes](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.dtypes.html) and function [describe()](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.describe.html#pandas.DataFrame.describe) from the same library are useful to check the type of the data in each column and statistical properties, respectively)
df.head()

# Check statistical details on your data like counts, min, max etc
df.describe()

# Check the type of the features
df.dtypes

# Check how many patients you have from each category
label = 'HeartDisease'
healthy = df[df[label] == 0]
diseased = df[df[label] == 1]
print('Number of individuals from class 0', healthy.shape[0])
print('Number of individuals from class 1', diseased.shape[0])

# Split your dataset into training and testing (TIP: You can use [train_test_split](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html) method from scikit-learn. Please note that good ML practices suggest to always shuffle your data. To this end, for dataframes you can use [sample](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.sample.html) with the parameter frac as 1, but watch out to add reset_index(drop=True) to reset the index)
# Shuffle the data 
df = df.sample(frac=1, random_state=1).reset_index(drop=True)

# Separate features from output & convert to numpy - You can also continue in pandas 
Y = df[label].copy()
X = df.drop(label, axis=1)

# Indices of training subjects and of testing
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=25, stratify = Y)

# Balance the training set (TIP: You can drop patients from the majority class). You can skip this step and use "class_weight" parameter of your classifier to deal with data imbalance

# To make things easier, concatenate X_train and Y_train
temp_train = pd.concat([X_train, Y_train], axis=1)
print(temp_train.head())
# Delete the subjects from the majority class so that the number of subjects in both classes is equal
label = 'HeartDisease'
healthy = temp_train[temp_train[label] == 0]
diseased = temp_train[temp_train[label] == 1]
print('Number of individuals from class 0 in the training set before balancing', healthy.shape[0])
print('Number of individuals from class 1 in the training set before balancing', diseased.shape[0])
# Delete the ones extra so that the number if equal
if healthy.shape[0] > diseased.shape[0]:
  healthy = healthy.iloc[0:diseased.shape[0],:]
elif healthy.shape[0] < diseased.shape[0]:
  diseased = diseased.iloc[0:healthy.shape[0],:]

# Concatenate
df_train = pd.concat([healthy, diseased], axis=0)

# Shuffle again as above
df_train = df_train.sample(frac=1, random_state=1).reset_index(drop=True)

# Split the dataframe into X_train and Y_train again: For Y_train just keep column 'HeartDisease', For X_train just drop this column
Y_train = df_train[label].copy()
X_train = df_train.drop(label, axis=1)

print(df_train.shape)
# Confirm the number of samples you have in each class
healthy = Y_train[Y_train == 0]
diseased = Y_train[Y_train == 1]
print('Number of individuals from class 0 in the training set after balancing', healthy.shape[0])
print('Number of individuals from class 1 in the training set after balancing', diseased.shape[0])

# Data pre-processing 
# 
# 1.   Encode categorical variables  (TIP: Check [OrdinalEncoder](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.OrdinalEncoder.html#sklearn-preprocessing-ordinalencoder) from sklearn.preprocessing. Another popular approaches is OneHotEncoder but not appropriate for tree based classifiers, can you imagine why?)
# 2.   Scale numerical data (TIP: Check [MinMaxScaler](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.MinMaxScaler.html#sklearn.preprocessing.MinMaxScaler))
# 
# TIP: 1. It is very important to treat testing and training data separately to avoid data leakage 2. Methods [fit_transform](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.MinMaxScaler.html#sklearn.preprocessing.MinMaxScaler.fit) (for training data) and [tranfrom](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.MinMaxScaler.html#sklearn.preprocessing.MinMaxScaler.fit) (for the testing data) can be very helpful. Alternatively you can use Pipeline and ColumnTransformer from sklearn but it will be more complicated to retrieve feature names for the most important features
# 


# Indices of categorical and numerical columns
# Categorical features
cat_feat = ['Sex', 'ChestPainType', 'RestingECG', 'ExerciseAngina','ST_Slope']
# Indices of categorical features
categorical_idx = [loc for loc, key in enumerate(X_train.columns) if key in cat_feat]
# Indices of columns with numerical data
numerical_idx = list(set(range(0,X_train.shape[1])) - set(categorical_idx))
# Names of numerical features 
num_feat = X_train.columns[numerical_idx]

# Handle categorical variables
cat_preprocesssor = OrdinalEncoder()
X_train[cat_feat] = cat_preprocesssor.fit_transform(X_train[cat_feat])
X_test[cat_feat] = cat_preprocesssor.transform(X_test[cat_feat])
# Normalize the numerical valyes
num_preprocesssor = MinMaxScaler()
X_train[num_feat] = num_preprocesssor.fit_transform(X_train[num_feat])
X_test[num_feat] = num_preprocesssor.transform(X_test[num_feat])


# Train the model (TIP: Check method [fit](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.MinMaxScaler.html#sklearn.preprocessing.MinMaxScaler.fit))

# Random forest classifier with 100 trees, random_state is set to be able to reproduce your results
estimator = RandomForestClassifier(100, max_depth=10, random_state=42)
estimator.fit(X_train, Y_train)

# Apply the model to the testing data and evaluate its perfromance (TIP: You might use [classification_report](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.classification_report.html#sklearn-metrics-classification-report) or [roc_auc_score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.roc_auc_score.html#sklearn.metrics.roc_auc_score))
# Make the prediction
Y_pred = estimator.predict(X_test)
# Evaluate the performance by comparing the predicted labels with the true ones
print(classification_report(Y_test,Y_pred))
auc = roc_auc_score(Y_test,Y_pred)
print(f"The AUC is {auc}")

# Get the feature importance in the model's estimation and plot the most important features (TIP: To get feature importance and names you can use feature_importances_ and feature_names_in attributes of your model, respectively)

# Sort the features in descending order of importance
sorted_idx = estimator.feature_importances_.argsort()
plt.barh(estimator.feature_names_in_[sorted_idx], estimator.feature_importances_[sorted_idx])
plt.xlabel("Feature Importance for model's decision")



