# Github User Search

This project is based on Github API for searching user based on a keyword and displaying the results in a list.

## Purpose

The purpose of this project is to implement the Github API, which is provided by Github. This API is free to use but is limited. You can use this project as an example of an API implementation, especially to load a series of data.

## Structure

This project is a Flutter application. We can see all of the operations happen in the lib folder. So these are things that happen in the code:
1. All the models are inside the model folder. These models are made to catch the response data that comes from the API.
2. The API itself will be implemented inside the repository. This project doesn't use the data source because it only used one data source which is the API, and it also doesn't use any local storage.
3. In case of providing data all around the app, this project used the provider library as you can see in the folder.

## To-do

There are some works needed to improve this project. Some of these things are what I think is needed to be done in future time:
- Implement SOLID principles
- Implement testable codes
