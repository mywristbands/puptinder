# Milestone 1
Group 10

Alannah Woodward

Tammy Lee

Elias Heffan

Hajra Mobashar

### Github Classroom
https://github.com/ECS189E/project-f19-puptinder
### App Flow Mockup
- (New User) Login -> Sign Up User -> Create profile -> Add profile photo -> Create Profile -> User profile -> Home -> Messages
- (Old User) Login -> Home -> Messages

### View Controller Wireframes Flow
https://drive.google.com/open?id=14Jl4QUFf4HCzplrTsMw0kmbq-UGNcwXa

### View Controllers
For errors: just have error labels hidden on the screen
- LoginView
- SignupView
- ProfileSetupView
- HomeView
- ProfileView
- ProfileEditView
- MatchesView 
- ConversationView (Likely to be taken care of by MessageKit)
- OtherUserProfileView

### Protocols and Delegates
- MessageKit provides the `MessagesDisplayDelegate`, `MessagesLayoutDelegate`, and `MessagesDataSource` protocols which we will override the default implementations of 

Note: Will consider more protocols and delegates later
### Third Party Libraries
- Firebase, MessageKit (used for messaging UI)
### Server Support
- Firebase
### Our API (in progress)
```
Class Api {
    login()
    logout()
    signup()
    createProfile(profile: Profile)
    getProfile(): Profile
    updateProfile(profile: Profile)
    getPotentialMatch(): Profile
    acceptPotentialMatch()
    rejectPotentialMatch()
}
```
### Models
```
class Profile {
    picture: UIImage
    name: String
    breed: String
    size: String
    bio: String
    traits: [String]
    characteristics: [String]
}
```
### Itinerary
Note: The  number of people assigned to each task is a rough estimate; we’ll change the number of people as we see how fast each task takes.

#### Week 1 (Ends Wednesday, November 20)
- Elias will finish planning prototypes for API functions, including DogAPI stubs.
- Alannah and Hajra will work on building the views, both the aesthetic part and the ViewController logic. Priority on Login, Signup, ProfileSetup View, and HomeView.
  - As they need information from the database or need to store information in the database, they can call the API function prototypes, even though they won’t do anything yet.
  - It should basically be exactly how the finished product will be, except it won’t yet be functional because the API calls won’t work yet.
- Elias and Tammy will work on starting the Firebase setup
  - Research how databases and rules work in Firebase.
  - Have a meeting to figure out how we’ll structure the database, and the high-level rules.
  - Implement the rules and structure of the database.
  - Divide up who will work on each of the API functions, and begin implementing some of them, prioritizing the profile-related functions.
#### Week 2 (Ends Wednesday, November 27)
- 2 people will finish working on aesthetics and View Controller logic.
Specifically Messages View set up, and any finishing touches we need.
- 2 people will work on implementing API functions related to matches and messages.
- For anyone who finishes early:
  - 1 person can write the DogAPI functions implementation
  - 1 person can write survey for testing our app (in addition to another responsibility above) 
  - 1 person can figure out how to use TestFlight
  - 1 person can discuss space storage with mentor/Sam/Gary since it might become a problem.
#### Week 3 (Ends Wednesday, November 4) 
- Finishing touches and fine-tuning flows in the app.
- Get user feedback on app through survey and testing
### Testing Plan
- Google form survey. Some possible questions we could ask:
  - How easy was it to sign up?
  - How responsive was the app? Was it fast enough?
  - How easy was it to navigate around our app?
  - How responsive/smooth is swiping?
  - How well did the app predict your dog breed?
  - Would you recommend this app to a friend?
  - General rating out of 5 stars
- Each team member try to get at least 5 responses for acquaintances
  - Time how long it takes for someone to get from the login screen to the HomeView as a new user.
