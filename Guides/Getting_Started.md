#Django to iOS || Getting Started Guide

1. System requirements
	- [Mac OS X](http://www.apple.com/osx/)
	- [Xcode](https://developer.apple.com/xcode/) version 6+
	- Carthage Installed. [Installation Guide](https://github.com/codingforentrepreneurs/Guides/blob/master/install_carthage.md)
	- Django & Virtualenv Installed.
		- CFE [Video Tutorial](http://joincfe.com/projects/#setup)
		- CFE Github [Installation Guide](https://github.com/codingforentrepreneurs/Guides/blob/master/install_django_mac_linux.md)




2. Create a new iOS Project:
	1. Open `Xcode` > `File` > `New Project`
	2. Select iOS Project template `Single View Application`, click `Next`
	3. Fill in the following:
		```
		Product Name: CFE
		Organization Name: Coding For Entrepreneurs
		Organization Identifier: com.codingforentrepreneurs
		```

	4. Select `Swift` as the Language
	5. Deselect `Core Data` (unless you know how to use it of course)
	6. Create in a location of your choice. For example:
		`Desktop`
	7. This will create a new folder on your desktop based on the name of your project. In this example, it will read as `CFE`



3. Install `Alamofire`, `KeychainAccess`, and `SwiftyJSON`: 
	
	Using Carthage, we're going to install these frameworks for our project. This is not the only way to install these frameworks but Carthage makes our life easy. Let's get started:
		
	1. Create a new file called `Cartfile` with no extension in your project's directory. This is the same place you'll see your `.xcodeproj` file. In our example above, it will be `CFE.xcodeproj`.

	2. In the cartfile, you'll add:

	```
	github "Alamofire/Alamofire" >= 1.2
	github "SwiftyJSON/SwiftyJSON" >= 2.2
	github "kishikawakatsumi/KeychainAccess" >= 1.2.1
	```
	*Note*: This github repositories have been tested by Carthage as working packages. If you use Carthage, there's a chance that other non-tested packages will fail to install properly.

	3. Open the Terminal Application (Applications > Utilities > Terminal)
	4. Navigate to our XCode Project folder (where `CFE.xcodeproj` is located): 
	      
	      ```
	cd Desktop
	cd CFE
	# If you list out the directly you should see:
	$ ls
	Cartfile
	CFE
	CFE.xcodeproj
	CFETESTS
	      ```
	5. Run Carthage Update

		```
		carthage update
		```

	6. Link Frameworks:
		1. "Srvup" > "General" -> "Linked Frameworks and Libraries"
		2. Add "Alamofire", "KeychainAccess", and "SwiftyJSON"

	7. Add Compiling Scripts:
		1. "Srvup" > "Build Phases" -> "+"
		2. Enter the following:
			Shell: `/bin/sh`
			1: `/usr/local/bin/carthage copy-frameworks`
		3. Input Files:
			`$(SRCROOT)/Carthage/Build/iOS/Alamofire.framework`
			`$(SRCROOT)/Carthage/Build/iOS/KeychainAccess.framework`
			`$(SRCROOT)/Carthage/Build/iOS/SwiftyJSON.framework`



4. Download a pre-created RESTful API Django Project:
	In this step, we download and install the "Srvup Rest Framework" project on github as our Django Starting point. This is a rather large project so if you want to learn how to build (1) the Django project or (2) The Django Rest Framework portion of the Django Project, please visit:

	1. Clone the Srvup Rest Framework project: https://github.com/codingforentrepreneurs/srvup-rest-framework 

		Note: Don't know how to use git? You can just "Download Zip" instead.
	2. Coming Soon.








