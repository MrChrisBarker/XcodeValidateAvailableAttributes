# XcodeValidateAvailableAttributes
XcodeValidateAvailableAttributes is a [Ruby](https://www.ruby-lang.org/en/) script that validates all Swift files within your iOS Xcode project for the @available attributes against your current deployment target.

### Installation & Usage
* Copy the *XcodeValidateAvailableSDK.rb* script to the root of your Xcode project
* Create a *New Run Script Phase* and add the following

```bash
file="XcodeValidateAvailableSDK.rb"
if [ -f "$file" ]
then
echo "$file found."
ruby XcodeValidateAvailableSDK.rb "My Target Name" warn
else
echo "XcodeValidateAvailableSDK.rb doesn't exist"
fi
```

*Required* Pass in your target name 

*Optional* Pass in *warn* as an argument to treat these as warnings only, (*By default the validator will treat all attributes matched as errors, causing your build to fail.*)

Exclusions can be set in an array called *files_exclude* (for example if you want to exclude your Cocoapods directory)

### Contribution
I'm still pretty new to Ruby, so I welcome all feedback/pull requests for improvements or added features

### Roadmap
Next steps are to add support for macOS

### Contact & Licencing  
Feel free to share as you please, Kudos is always welcome and can be found online at:

* Twitter - [MrChrisBarker](http://twitter.com/mrchrisbarker)
* Blog - [Cocoa-Cabana](http://cocoa-cabana.net)


