#Goodnotes XCUI Tech Test - Ellie Clifford

##Overview 

This project contains UI Tests for the To-Do list app as part of the take home XCUI exercise for Goodnotes. A total of 3 automated XCUI tests, written in swift, are included focusing on the app's core user journeys.

##Test Structure/Overview

1. UITestBase :
   - Centralises test setup, tear down and app launch logic
2. Helpers :    
   - Centralised timeouts  
   - Clearer error messages in logs  
   - Combined actions 
3. Locators : 
   - Stores element identifiers in one place making easier to maintain when locator changes/breaks.
4. Steps : 
   - Groups actions and assertions into readable, reusable and maintainable functions.
5. Tests : 
   - The above allows us to keep test cases short, clear, and easy to understand
   
   ##How to run tests: 
1. Open the Xcode project
2. Select a device target
3. Open Test navigator (cmd+6)
4. Use play button to run all tests
5. If you experience issues running all tests at once (simulators can overload depending on machine performance), please run test cases individually


##Tested on:

- Iphone 17 pro 26.1 simulator
- iPad mini 26.1 simulator
- macOS Tahoe 26.2, Xcode 26.2, MacBook Pro M1 2020

##Potential bugs or issues discovered:

- When creating a reminder, leaving the due date and time empty causes them to populate with the apparent current date and time.  Looking at the code, it suggests it's adding 100 years if no date is selected, however, because the date is formatted as `YY`, it is unclear to the user whether the displayed year is 2026 or 2126.
- Date picker doesnt dismiss after selecting date - may be design preference instead of bug 
- 'Flagged' filter is ambiguous. Only shows High priority tasks yet all priorities are shown as a 'flag'. No other way to explicitly mark an item as flagged
- On iPad and Mac if you edit a task but don't close edit view and select another tasks, the title and details will still be for the task you were editing but other values such as flag, completed etc will be from the selected task.
