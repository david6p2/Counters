# Counters

This iOS app will help you count anything you want and persist them in case you lose your internet connection.

## Prerequisites

This App was built with **Xcode 12.4**

Requirements:

- iOS 14.1 or superior
- iPhone Device in portrait mode
- An internet connection is preferred for the App to work as expected

## How to Run the project?

### Server App:

Setting up the server is easy! You will need to download and install [NodeJS](https://nodejs.org/en/download/) if you do not already have it. To run the mock server (it is a separate Repo, if you need it you want ping me @david6p2 in Twitter an I will send you the .zip file) execute the following commands in Terminal while in :

```
$ npm install
$ npm start
```

### iOS App:

Just need to clone the Repo from https://github.com/david6p2/Counters.git using git and then open the `Counters.xcodeproj` and run. There are no 3rd party dependencies, so there's no need to use Cocoapods, Swift Package Manage, Carthage, etc.

If the server is already running, you should be ready to start counting what you want.

## About

### Architecture

The used architecture is MVP+Coordinator

The Coordinator decides the MVP that should be presented, then each Presenter shows the View Controller, and the ViewController configures and presents its inner view that can also have other inner views. These inner views communicate to their parent View or ViewController with delegates and then the view controller sends the user actions to the presenter, who decides what should be done and tells the view back what needs to be done, updating the view as shown in the following diagram:

![MVP_Architecture](https://user-images.githubusercontent.com/1909725/117249151-bd115a80-ae06-11eb-9ac1-f123e30adc73.png)
Image taken from: [^1]

We have the following MVPs:

- Welcome: Is what you will see when you open the App for the first Time. ([10](https://github.com/david6p2/Counters/pull/10), [14](https://github.com/david6p2/Counters/pull/14))
- CounterBoard: This is the main view of the App, here you will be able to see:
  - The Counters list if there is any content already created. This was done using a UITableView with `Diffable Datasource` [11](https://github.com/david6p2/Counters/pull/11). Here you can:
    - Edit the Counters list. [17](#https://github.com/david6p2/Counters/pull/17)
    - Delete multiple Counters. [17](https://github.com/david6p2/Counters/pull/17)
    - Share multiple Counters. [17](https://github.com/david6p2/Counters/pull/17)
    - Select all Counters. [17](https://github.com/david6p2/Counters/pull/17)
    - Pull to refresh the Counters list. [16](https://github.com/david6p2/Counters/pull/16)
    - Add a new counter. [15](https://github.com/david6p2/Counters/pull/15)
    - Search all the counters you have and edit them while you are searching. (`obscuresBackgroundDuringPresentation` was disabled on the searchController so this can be done easier) [21](https://github.com/david6p2/Counters/pull/21)
    - Show a sum of all the counter values. [19](https://github.com/david6p2/Counters/pull/19)
  - The Loading indicator if the App is retrieving the Counters from the backend. [7](https://github.com/david6p2/Counters/pull/7)
  - The No Content View when you haven't created any Counter yet. [5](https://github.com/david6p2/Counters/pull/5)
  - The Error View if there was some problem with the Network Connection. [20](https://github.com/david6p2/Counters/pull/20)
- Add Counter: Here is where you can Add a new Counter by typing it's name and then touching the **Save** button. [15](https://github.com/david6p2/Counters/pull/15)
- Examples: This is accessible through a link under the Add Counter text field. Here you will find some examples of things you can count if your imagination is blocked. This was done using Collection Views with the new `UICollectionViewCompositionalLayout`. [18](https://github.com/david6p2/Counters/pull/18)

All of these MVP Navigation is controlled by a MainCoordinator [1](https://github.com/david6p2/Counters/pull/1) that decides which MPV should be presented next and is the one in charge of assembling each MVP before presenting them.

The Networking [12](https://github.com/david6p2/Counters/pull/12) and Storage (CoreData [22](https://github.com/david6p2/Counters/pull/22)) Layers are decouple from the App with the use of the Repository Pattern and using the `CounterCellViewModel` as the Domain object, so you won’t see any NSManagedObject inside the Domain, making the change of CoreData for any other storage much easier, if needed in the future.

To manage the different States the Strategy Pattern was used [6](https://github.com/david6p2/Counters/pull/6)

The Networking errors and other errors were also handled by creating a custom Error that helps creating Alerts to inform the user about it. [20](https://github.com/david6p2/Counters/pull/20)

[^1]: https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52.