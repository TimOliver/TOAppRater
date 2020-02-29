# TOAppRater

<p align="center"><img src="https://raw.github.com/TimOliver/TOAppRater/master/screenshot.jpg" alt="TOAppRater" width="800" style="margin:0 auto" /></p>

I've been a huge fan of [Appirater](https://github.com/arashpayan/appirater) for many years, and it's netted many of my apps excellent reviews. But like [John Gruber wrote in 2013 on requesting reviews](http://daringfireball.net/linked/2013/12/05/eff-your-review), harassing users for reviews can be incredibly annoying. While I don't agree that users should reply with a 1-star review (that's a bit much), I definitely agree developers need to be much more diplomatic when it comes to asking for reviews.

[Marco Arment also discussed this in 2014 on how he decided to do it in Overcast](http://www.marco.org/2014/12/05/how-overcast-asks-for-reviews). I definitely think Marco has done it in the best way possible. It's a simple, non-obtrusive button in the settings page, and even has contextual information on how much that review would help.

Following on from that, this library is my own implementation following the same pattern on how Marco asks for reviews. It tries to go about asking app reviews in a more subtle, classy way of 'suggesting' the user rate the app by simply presenting a label, dynamically updated with the current number of ratings the app has, enticing them to help contribute.

## Features
* Asynchronously checks the iTunes Search API every 24 hours for review updates.
* Uses `NSLocale` to determine which App Store region to pull the number of ratings from.
* A single convenience method call to quickly move the user to the App Store page for your app.
* Optionally, also provides the iOS 10.3 store API for prompting users for reviews the official way.

## Technical Requirements
iOS 9.0 or above.

## License
TOAppRater is licensed under the MIT License, please see the LICENSE file.
