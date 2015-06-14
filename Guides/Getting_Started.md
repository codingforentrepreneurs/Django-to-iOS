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



4. Download a RESTful API Django Project:
	In this step, we download and install the "Srvup Rest Framework" project on github as our Django Starting point. 

	This is a large project so if you want to learn how to build all parts visit the following:
		- Srvup Membership: A Django Project ([Tutorial](https://joincfe.com/projects/srvup-membership/) | [Code](https://github.com/codingforentrepreneurs/srvup-membership))
		- Srvup Rest Framework: A Django Rest Framework Course ([Tutorial](https://joincfe.com/projects/django-rest-framework/) | [Code](https://github.com/codingforentrepreneurs/srvup-rest-framework))

	To download, you have 3 options:
	1. Add the Srvup Rest Framework project as a submodule to your project:
	```
	git submodule add https://github.com/codingforentrepreneurs/srvup-rest-framework 
	```	
	2. Clone the Srvup Rest Framework anywhere on your computer:
	```
	git clone https://github.com/codingforentrepreneurs/srvup-rest-framework 
	```	
	3. Download as a zip: [https://github.com/codingforentrepreneurs/srvup-membership/archive/master.zip](https://github.com/codingforentrepreneurs/srvup-membership/archive/master.zip)


5. Create a virtualenv & install requirements within your 'srvup-rest-framework' project:
	Assuming you downloaded/stored it on the desktop, you'd do the following:
	``` 
	$ cd desktop
	$ cd srvup-rest-framework
	$ virtualenv .
	$ source bin/activate
	(srvup-rest-framework)$

	(srvup-rest-framework)$ ls
	LICENSE			lib			srvup.sublime-workspace
	README.md		requirements.txt	static
	bin				src
	include			srvup.sublime-project

	(srvup-rest-framework)$ pip install -r requirements.txt
	```
	
	Don't have virtualenv installed? Choose one of these:
		- CFE [Video Tutorial](http://joincfe.com/projects/#setup)
		- CFE Github [Installation Guide](https://github.com/codingforentrepreneurs/Guides/blob/master/install_django_mac_linux.md)

	Don't have git installed? Install via Heroku Toolbelt - [http://toolbelt.heroku.com](http://toolbelt.heroku.com).

	* Note, if you ever notice the srvup-rest-framework is running poorly, try to update the submodule with: `git submodule update --remote --merge`




6. Create new Superuser & Run Django App:
	```
	(srvup-rest-framework)$ cd src

	(srvup-rest-framework)$ ls
	accounts		db_blank.sqlite3	notifications
	analytics		db_github.sqlite3	srvup
	billing			jquery_test		templates
	comments		manage.py		videos

	(srvup-rest-framework)$ python manage.py createsuperuser
	Username: anythingelse
	Email: anything@gmail.com
	Password: 123
	Password (again): 123
	Customer created with id = XXXXXXXX
	Superuser created successfully.

	(srvup-rest-framework)$ python manage.py makemigrations
	No changes detected

	(srvup-rest-framework)$ python manage.py migrate
	Operations to perform:
  		Synchronize unmigrated apps: staticfiles, corsheaders, messages, crispy_forms, rest_framework
  		Apply all migrations: videos, billing, notifications, admin, sessions, auth, analytics, contenttypes, accounts, comments
	Synchronizing apps without migrations:
  		Creating tables...
    		Running deferred SQL...
  		Installing custom SQL...
	Running migrations:
  		No migrations to apply.


	(srvup-rest-framework)$ python manage.py runserver

	Performing system checks...

	System check identified no issues (0 silenced).
	July 01, 2015 - 10:10:10
	Django version 1.8.2, using settings 'srvup.settings'
	Starting development server at http://127.0.0.1:8000/
	Quit the server with CONTROL-C.

	```

	Did it all work? If so, you're ready to go. If not, you might have to try installing again. Ensure each step is accurate.



