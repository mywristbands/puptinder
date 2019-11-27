## Sprint Planning 4    11/21/19

Project summary: Find the perfect play-date for your pet. Swipe left or right, enter your ideal pet date preferences, share pictures, share personality traits, find suggested locations to set up the play date. Bob and Milo can find a third wheel.

Link to trello board: https://trello.com/invite/b/rubewu9h/19e96c4ef1baaef9118aab923b503bee/ecs-189e-final-project

### Elias Heffan

What I have done:
 - Implemented all profile API functions: [createProfile()](https://github.com/ECS189E/project-f19-puptinder/commit/f928fe438eba425719dbd3604e7652b963deb74a), [uploadProfile()](https://github.com/ECS189E/project-f19-puptinder/commit/b945ef8562596b65db0eef890138a3912300246a), [getProfile()](https://github.com/ECS189E/project-f19-puptinder/commit/8f9b43736fc781b5bd91db307d6cb37214326f09), [getProfileOf()](https://github.com/ECS189E/project-f19-puptinder/commit/563a7564ebec9ae0a4732f43f7ae185b01aa5e3a).
 - Refactored API for maintainibility [here](https://github.com/ECS189E/project-f19-puptinder/commit/2b819f1c6f1e76527f7c2022fb81e9ee5d0f4fb8).
 - Added new podfile for firebase storage and removed obselete podfiles [here](https://github.com/ECS189E/project-f19-puptinder/commit/b16958b3d4e8b335ccab8205dc736bc33b9e56e8).
 - Improved authentication error checking [here](https://github.com/ECS189E/project-f19-puptinder/commit/b945ef8562596b65db0eef890138a3912300246a), and improved login and signup [here](https://github.com/ECS189E/project-f19-puptinder/commit/f52b1f96dac0de25c2e3aa3fa81e059c8e5fa308)
 - Made app compatible back to iOS 11, and started making View controllers compatible with SE/5s screen size [here](https://github.com/ECS189E/project-f19-puptinder/commit/0e222095785e72c82cd047a79ad6bb77907dfc0c).
 
Any roadblocks: None.

What I plan to do: Implement the rest of the Api functions along with Tammy, as well as the SDK Admin function for finding matches. Add rules to firebase storage for security.

### Tammy Lee

What I have done: 
- Implement and test matches API functions, [`getMatches()`](https://github.com/ECS189E/project-f19-puptinder/commit/9019e0988714d002a4cbe174e2f24f9e0415e328) and [`getPotentialMatch()`](https://github.com/ECS189E/project-f19-puptinder/commit/21720706dffcdfb05476e2ca66568389bfa5e944) and [here](https://github.com/ECS189E/project-f19-puptinder/commit/be047a2591b088eff62e3944bc298018be94f9d8)
- Small modification to [Login UI](https://github.com/ECS189E/project-f19-puptinder/commit/897f5f7180bac8070e898f967490c4395d371e96) to make user experience more secure

Any roadblocks: None. 

What I plan to do: 
- Work on implementing functions in ApiMessages.swift and modify any data structures/security rules in current database as needed to work with MessageKit. 
- Set up Matches and Conversation View.

### Hajra Mobashar

What I have done: Completed front end for Home Screen, and mostly for the user profile screen.

Any roadblocks: None at the moment.

What I plan to do: Use API calls to implement functionality for the home screen. User profile screen needs adjustment for characteristics list and personality list. Adjust the front end for the create profile screens 3 and 4 for better UX.

### Alannah Woodward

What I have done: Transferred all data between screens to be able to upload profile to the database,[here](https://github.com/ECS189E/project-f19-puptinder/commit/d372dfc142d972782563e5c561d7e39b29145a7a); Added error checking for the first profile view, [here](https://github.com/ECS189E/project-f19-puptinder/commit/b556830f40d64c00ad8371dca039d9367b0ae5d1). Have done some work for profile set up from database, but not currently functional.

Any roadblocks: None so far. 

What I plan to do: Finish the UI and get the API functions integrated. 
