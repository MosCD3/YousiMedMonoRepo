# Module - Onboarding

Onboarding module for iOS apps

## Usage

The module has its own coordinator, you define the coordinator and subscribe to delegate calls then wait for the onboarding to be finished

## Summary

```swift
import FROnboarding

...


//Start the coordinator
let onboarding = OnboardingCoordinator()

//Coordinator delegate will invoke a function when onboarding ends or skipped by user
onboarding.delegate = self

//This will return the onboarding ViewController that you push to the view
let onboardingController = onboarding.start(uiConfig: OnboardingUIConfig(), views: nil,models: dependency.makeOnboardingScreens())

//Push to the view
navController.setViewControllers([onboardingController], animated: true)
navController.setNavigationBarHidden(true, animated: false)
```

## Customizing UI

By default, the onboarding has default UI colors and settings, that happens when you create "OnboardingUIConfig()" instance, default settings are loaded

To customize UI

```swift
let ui = OnboardingUIConfig()
ui.defaultBackgroundColor = .blue
... etc
//Properties that can be modified
/*
    public var defaultBackgroundColor: UIColor = .systemGray6
    public var iconColor: UIColor = .white
    public var textColor: UIColor = .white
    public var indicatorColor: UIColor = .systemGray4
    public var indicatorActiveColor: UIColor = .systemGray
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 28)
    public var descriptionFont: UIFont = UIFont.systemFont(ofSize: 14)
*/
//This will return the onboarding ViewController that you push to the view
let onboardingController = onboarding.start(uiConfig: ui, views: nil,models: dependency.makeOnboardingScreens())
```

## Customizing Views

By default, has a default view with a model to change view parameters, you can pass custom models OR custom ViewControllers

1- Custom data using default View Structure

```swift

 let screens = [
     OnboardingModel(title: "Test frist page", subtitle: "Take advantage of our amazing template to launch your iOS app today.", icon: "classifieds-logo"),
     OnboardingModel(title: "Map View", subtitle: "Visualize listings on the map to make your search easier.", icon: "apple-icon"),
     ]

//This will return the onboarding ViewController that you push to the view
let onboardingController = onboarding.start(uiConfig: ui, views: nil,models: screens)
```

2- Custom ViewControllers

```swift

 let views = [
     ViewController1(),
     ViewController2(),
     ]

//This will return the onboarding ViewController that you push to the view
let onboardingController = onboarding.start(uiConfig: ui, views: views,models: nil)
```

## Onboarding delegates

Assume you have a class "MainCoordinator" managing the app flow

```swift
extension MainCoordinator: OnboardingCoordinatorActionDelegate {
    func onboardingDone() {
        //Do something when onboarding done
    }
}
```
