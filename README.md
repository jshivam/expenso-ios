# expenso-ios
![alt tag](https://github.com/jshivam/expenso-ios/blob/master/expenso.gif)

It Records expenses in your app locally. 


Create an expense tracking app. The app has 2 tabs. Transaction and Overview. Total number of screens possible in Transaction tab is 2. In Overview tab, total number of screens possible is 

You are free to make unmentioned design assumptions on any of the screens. 
Its compulsory to use Swift and MVVM design patten. 

Transactions tab:
1.  The user is allowed to add an expense on a previous date or on a future date

2.  All the values are in Rupees. so we can just mention the amounts. No need to include currency anywhere.

3.  The app is only for tracking expenses. We can not add our income.

4.  If the user moves to a month where no transaction has been added then show the label - “No transactions added yet.”

5.  The user can navigate backward and forward for upto one year. Similarly, the transactions can be added for last 1 year or next 1 year. In no way the user will go outside this time range. If the date changes, i.e., 

6.  if the system date of phone changes, then the initial data on transactions tab should be shown accordingly. For ex, if my date is 12th Feb, 2018 then the data of Feb, 2018 should be shown in transactions tab.

7.  The user can click on the plus button to add a new transaction; it will lead to a different view controller (2nd screen) where the user can add the details of transaction. When submit button is pressed a new row will be added on the first screen.

8.  For an already added transaction on the 1st screen, the user can click on it which will again lead her to the 2nd screen. There she can make changes to any of the fields and press submit. 
    This action should modify the already existing data and should NOT create a new row. If the user decides to modify the date of the transaction then the position of the row should change accordingly on the 1st screen.

9.  If the user goes back from the Screen 2 without pressing the submit button then the recently made changes will be discarded.

10. Possible category names : Travel, Family, Entertainment, Home, Food, Drink, Bills, Car, Utility, Shopping, Healthcare, Clothing, Vegetables, Accommodation, Other, Transport, Hobbies, Education, Pets, Kids, Vacation, Gifts.

11. The user can uniquely select an image for each transaction. When clicked on the circular image icon on screen 2, give the user options to 
        take a photo
        choose from gallery
        delete the photo 

 Overview Tab:
1. For the month in transactions header field, show the overview of expenses according to each category. The data is user is interested in is - the total expense of that month for a particular category. E.g., total amount spent on vegetables that month, and similarly for other categories. You can use a pie chart, or any other graph to display this data. Please design the screen as you wish.

    
