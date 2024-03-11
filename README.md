Meals Management App
 
Objective
 
To enhance employee well-being and productivity by offering a user-friendly,      efficient, and cost-effective solution for managing their meals within the company.
 
For employees:
Improve nutrition and health:  Encourage healthier eating habits by providing access to balanced meal options.
Increase convenience and time saving:  Offer a seamless way to order, plan, and collect meals, reducing lunch breaks or meal prep time.
Boost satisfaction and morale:  Enhance employee experience and foster a positive company culture.
 
For the company:
Promote employee engagement and retention: Demonstrate care for employee well-being, leading to higher satisfaction and lower turnover.
Optimize meal ordering and costs: Streamline meal selection and delivery, potentially reducing food waste and controlling expenses.
Gain valuable data and insights: Track employee preferences and usage patterns to inform future culinary and service improvements.





Introduction

	Welcome to our Meals Management App for managing meals at Nalsoft Pvt Ltd! This employee-focused app, built with Flutter technology, provides a convenient and efficient way to track your daily meals.

At Nalsoft, we strive to create an environment where our employees not only flourish professionally but also feel valued and cared for. Recognizing the significant role that well-being plays in performance and overall happiness, we're excited to introduce daily free meals for all employees! This isn't just about providing lunch; it's about fostering a culture of community, convenience, and healthy habits. We believe this initiative demonstrates our commitment to employee well-being, extending beyond traditional care models. We're confident it will lead to increased productivity, morale, and a renewed sense of belonging within the Nalsoft family. 

Who is this app for ?
	
	This app is designed for all employees at Nalsoft Pvt Ltd who participate in our meals program. Whether you are busy grabbing lunch on the run or someone planning your meals in advance, this app is here to simplify your experience.

	Each individual user can track his/her past and present meals status whether he had meals or not on certain days, and can update meals status for upcoming days, saying reasons for not opting meals for particular days in future so that food will not be wasted and managed effectively. 

Ready to get started ?

	This documentation will guide you through everything you need to know about using the Meals Management App. Follow the Getting Started Section to set up your account and explore the app’s features. We’ve also included user guides, helpful instructions which will make the application easy to use for the user.

Getting Started


Screens

1. Login Screen

The Login screen serveṣ as the entry point for the users. It provides a secure authentication mechanism to verify user credentials and grant access based on the user type - Employee, Admin, or Vendor.




Key Features:

Email Field: Allows users to input their registered email address. This field only takes the organization account’s credentials (Nalsoft).

Password Field: Securely captures the user's password for authentication with an optional eye shaped toggle icon button to show/hide password.

Login Button: Initiates the authentication process. 

Logo: Positioned at the top of the above fields for brand recognition with an image for visual appeal.

Success Message: Displayed as a snackbar at the bottom of the screen with green color to inform users about the successful login attempt.

Error Message: Displayed as a snackbar at the bottom of the screen with red color to inform users about the failed login attempt.



















2. Home Page

i. Admin home page :


Img : Admin home page

	If the User type is Admin then he will be navigated to the screen shown in the above figure. In this screen the user can view his Name, Lunch Timings.
 
Key Features :

Admin to Employee Switch: Located at the top right corner, this toggle button allows users to switch between admin and employee modes.

Sign Out: Inside the power icon (top right corner), users can find the option to sign out from their account.

Update Upcoming Lunch Status: Below the greeting message, there’s an option labeled “Update upcoming lunch status.” Users can click on this to update their status for upcoming lunches.

Lunch Timings: The app displays lunch timings (1:00 pm to 2:00 pm) for user convenience.

Lunch Calendar: Below the lunch timings, there’s a calendar for February 2024. Users can view and select dates. Dates are color-coded to indicate whether users have opted in or out, if it’s a holiday, or if no status has been updated.

Legend : Below the calendar the legend shows what the color-codes in the calendar  represents.

Generate QR Code: After selecting today’s date from the calendar, users can press the “Ok” button at the bottom right corner to generate a QR code for that specific date. Cancel button will deselect the selected date.

















ii. Employee home page :


Img : Employee home page

If the User type is Employee then he will be navigated to the screen shown in the above figure. Everything is the same as the Admin home page, the only difference is that the employee will not get the toggle button to navigate to admin screens since employees will not have the privilege to access the admin screens.









iii. Vendor home page :


Img : Vendor home page

If the User type is Vendor then he will be navigated to the screen shown in the above figure. Upon accessing the vendor homepage, you’ll see a screen titled “Scan QR Code.” The purpose of this page is to scan employee QR codes for meal management.

Key Features:

Employee Count: Displays the total number of employee QR codes scanned. This helps track the number of employees served.

QR Code Illustration: Positioned on the screen are two large brackets, serving as guides. Place an employee’s QR code within these brackets for scanning.

Scan Button: Located at the bottom center, press this button to activate the QR code scanner.

Sign Out: Tap the power icon to reveal additional options, including the ‘Sign Out’ button for logging out securely.



































3. Update upcoming status screen



	This screen allows users to manage their upcoming lunch status for single and multiple days. Users can easily update their availability for future lunches.






Key Features :

Select Data Range : Allows users to choose between “Single Day” or “Multiple days” to update the status 

Interactive Calendar: Calendar displays the user’s lunch status for the particular month. Days are coloured with the colors form the legend present below the calendar to indicate the lunch status. When the User selects day/days and clicks on “OK”, a pop-up is opened. This pop-up content is based on the user selection.

Dialog box: If the user chooses dates to mark them as "not opting," a dialog box will appear prompting the user to enter the reason for not opting in a text field. Conversely, if the user selects dates that are already marked as "not opted," a dialog box will ask for confirmation from the user to proceed with marking the dates as not opted.

Legend: Legend illustrates the statuses using different colors.




















3. Admin First screen


Img : Admin first screen

	Upon clicking the toggle button on the homepage, the admin is directed to this page. The purpose of this page is to manage employee-related tasks.

Key Features: 

Sign Out Option: Tap on the power icon (top right corner) to reveal additional options. Click the “Sign Out” button to safely log out from your admin account.

Returning to Homepage: Use the toggle button to swiftly navigate back to the homepage.

Searching for Employees: Click the “Search employee” bar at the top of your screen. You’ll be redirected to a dedicated page where you can find and manage employee profiles.

Using Calendar View: Below, there’s a calendar view labeled “Lunch Calendar.” Admins can select any past date or today’s date from this interactive calendar.

Sending Mail with Employee Info: After selecting a date, click “Send Mail.” This action redirects you to your mobile’s mail app. You can send an email containing information about opted and not opted employees of that selected date in Excel sheet format.

Generating Notifications: Below the calendar view, there is a “Notify” button. Clicking this will navigate admins to a page where they can generate and manage notifications.














4. Search Screen


	The Search screen enables admin to search employees within the organization. It displays the employees whose name contains the text entered in the search field.

Key Features :

Search Field: Text field for the admin to enter text based on which employees are retrieved. 

Helper text: When the search field is populated with text, the screen displays content corresponding to the search, presenting relevant information in coordination with the search field. 
If no employee matches the entered text, the screen will display a message indicating "No employees found."
Otherwise, if employee(s) are fetched based on the entered text, the screen will prompt the user to select the desired employee(s).

It also displays “ no internet “ when there is no network connection to the mobile device.

Employee card: List of employees whose name contains the text typed in the search field are displayed with their name and employee Id.
Clicking on any of the employee cards will navigate to the specific employee lunch status screen.



5. Send Notification



	Admins have the capability to broadcast notifications to all users of the mobile app. When a notification is sent, users receive the message, and it is displayed in the notification bar within the mobile app.


Key Features :

Text Fields: Notification has two parts - Title and the Body
Title of the message cannot be empty.

Publish Button: Clicking on the publish button will publish the message to all the users of the application.
If the title is empty, there’s an error during sending, or there’s no internet, a snackbar will appear with the corresponding error message. 


6. Admin Employee Lunch Status Screen 


Img : Admin employee lunch status screen


When the admin clicks on any element in the list view provided in the admin employee search screen he will be navigated to this screen which shows the lunch status of that particular employee.

	Everything in this screen is similar to the home screen but there will be only one interaction the admin can do is that, he can click on Send Mail which redirects admin to mail app in the mobile with an excel file containing all the lunch status details of that particular employee. Remaining everything will be the same as the home page but there will be no other interactive elements. Department info is an addon in this screen.


Conclusion

	Our company will have a large number of employees, thus keeping track of their food status on a daily or specific basis would be a difficult chore for the administrators. To find out the status of a specific employee, they must search through all of the previous days' sheets. If they don't have this app, it might be necessary to generate paper lists of all the employees, mark any leaves, and have each employee sign a sheet indicating that they chose to have lunch today. The chores listed above are not necessary once we begin utilizing the Meals Management App, thanks to it.

	We offer a calendar in our app where users can mark their status regarding meals, such as whether they are choosing to eat lunch or not. We can also determine whether they have disregarded changing their status so we can remind them to do so going forward. We also offer the ability to track each employee separately via the app. The software has a function that lets the administrator create excel data for any given day or for every single employee. With the help of the daily data from the excel sheet, the administrator can determine how many individuals have chosen to have lunch tomorrow. This will allow for accurate and efficient meal management and prevent food waste. There won't be any miscommunications between the company and the vendor since the vendor can find out how many employees ate meals on a specific day and compare the information with excel sheets.
 
