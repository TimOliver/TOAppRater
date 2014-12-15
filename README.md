# TOClassyAppRater

<img src="https://raw.github.com/TimOliver/TOClassyAppRater/master/Screenshots/TOClassyAppRaterScreenshot.jpg" alt="TOClassyAppRater" style="max-width:730px;" />

I've been a huge fan of [Appirater](https://github.com/arashpayan/appirater) for many years, and it's netted many of my apps excellent reviews. But lately, I started agreeing with what [John Gruber wrote on requesting app reviews last year](http://daringfireball.net/linked/2013/12/05/eff-your-review) and more recently how [Marco Arment went about asking for reviews in his own app](http://www.marco.org/2014/12/05/how-overcast-asks-for-reviews). It's not cool to literally halt the app to pester users to rate it, and there really should be a better, more subtle way about doing it.

This library is a small implementation following the same pattern on how Marco asks for reviews in his podcasting app, [Overcast](https://overcast.fm). 

It tries to go about asking app reviews in a more subtle, classy way of 'suggesting' the user rate the app by simply presenting a label, dynamically updated with the current number of ratings the app has, enticing them to help contribute.

## Features
* Asynchronously checks the iTunes Search API every 24 hours for review updates.
* Uses `NSLocale` to determine which App Store region to pull the number of ratings from.
* A single convienience method call to quickly move the user to the App Store page for your app.

## Technical Requirements
iOS 6.0 or above.

## License
TOClassyAppRater is licensed under the MIT License, please see the LICENSE file.