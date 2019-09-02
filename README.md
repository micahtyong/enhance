# Enhance # 

<img src = "Demo/EnhanceLogoC.png" width = "300">

Available on [iOS](https://apps.apple.com/us/app/enhanceai/id1477011488?ls=1 "EnhanceAI"). 

Enhance is a fitness training program designed to improve strength, endurance, and core for people who struggle with musculoskeletal disorders as well as people with busy lives who want to stay active. In its first iteration, each person is provided with a set of three essential exercises—push-ups, planks, and timed jogs. Unlike most fitness apps, **Enhance keeps you accountable**. It uses frameworks like OpenPose and CoreMotion to verify that you are performing the exercises correctly and consistently. Users can track their progress over time as they get into the habit of completing these three daily exercises.

The more you train with Enhance, the more you’ll improve crucial physical skills that are proven to boost your well-being, discipline, and self-confidence. 

See a [video demo](https://www.youtube.com/watch?v=mhfjlfFoDBY "Enhance Demo")

## Motivation ##

One of my original teammates, Umang, has been struggling with chronic back, shoulder, and neck pain since he was seven years old. For a few years now, he’s attended weekly physical therapy sessions and one of the things that they do is “prescribe” physical exercises for him to do throughout the week. Exercises like pushups and planks target specific areas in his body that he needs to strengthen on a daily basis. 

The hardest part about physical therapy, however, wasn’t the repetition of those exercises, but rather the fact that there was nobody there for him to check his form outside of physical therapy sessions. Sure, he tried to use a mirror, but even then he wasn’t sure whether or not he was in proper form. 

Even more surprising, Umang isn’t alone. Far from it, actually. An [article](https://www.cdc.gov/mmwr/volumes/67/wr/mm6736a2.htm "Source") by the CDC (Centers for Disease Control and Prevention) in 2018 reported that about 50 million Americans (just over 20% of the adult population) have chronic pain. About 20 million of them have “high-impact chronic pain”, so this is pain that’s severe enough that it frequently limits life or work activities. These are people that definitely attend physical therapy sessions regularly and need to engage in “prescribed” physical exercises. 

So, Enhance began as a potential solution to those with musculoskeletal injuries / chronic pains and needed someone or something to guide them through their prescribed exercises while checking their form. Enhance quickly evolved to an app available for anyone—from those in PT to fitness junkies to students to working professionals and just about anyone who wanted additional incentive to workout while having someone or something to keep them accountable. 

Currently, most fitness apps claim to offer a personalized and guided daily workout routine. However, users don't always have someone to correct their form or perfectly time their sets. Enhance integrates the advantages of existing fitness apps (profile, stats, etc.) with the new solution of using computer vision and machine learning to guide users through their workouts, verfiying their form in the process.

## Build Status ##

The product has just finished its first iteration. All fundamental UI elements and controllers have been implemented and primed. User data is connected to Google's Firebase and the app reads from and writes to it effortlessly. Currently there are only three activities available: pushups, planks, and timed jogs. The CoreML models for pushups and planks are not quite perfect, but they're continually being improved through collection of data and adoption of more advanced technologies.

## Screenshots ##

<img src = "Demo/LandingPage.PNG" width = "180">
<img src = "Demo/OnboardingP1.PNG" width = "180">
<img src = "Demo/Profile.PNG" width = "180">
<img src = "Demo/GoodForm.PNG" width = "180">
<img src = "Demo/BadForm.PNG" width = "180">

## Technology and frameworks used ##

**Built with**
  * Swift 5.0
  * XCode 10.1
  * [Firebase](https://console.firebase.google.com/u/0/ "Google's Firebase")
  * [TensorFlow](https://www.tensorflow.org/, "TF")
  * [OpenPose](https://github.com/CMU-Perceptual-Computing-Lab/openpose "CMU OP")
  * [OpenCV](https://opencv.org/ "OCV")
  * [CocoaPods](https://cocoapods.org/ "CocoaPods") 
    * Hero
    * PopupDialog
    * STopAlert
    * TransitionButton
    * Paper-Onboarding
    * SwipeableTabBarController

  
## Installation ## 

1. Clone the repository.
2. Open in XCode 10.1 or later.
3. Build and run project on an iPhone device.

Enhance is scheduled to be released onto the App Store by the end August 2019. 

## Support ## 

If you find any of my projects helpful/inspiring and would like to support me, please do so [here](https://venmo.com/Micah-Yong "Venmo")

This is a project that I'd like to continue working on in the future. Feel free to raise issues or suggest improvements. My email is micahtyong@berkeley.com!

