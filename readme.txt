Note: CoffeeScript is required to compile the coffeescript files.


To install coffeescript at home, follow the instructions on
http://coffeescript.org/#installation

_____________________________

To install it on lab machines:

1. Open a terminal window, cd to your home directory.

2. Run the following commands:
   > npm install coffee-script
   > gedit ~/.cshrc

3. Paste the line below at the end of the file:
   alias coffee "~/node_modules/coffee-script/bin/coffee"

4. Now, running 
   > sh compile.sh
   in the tradersgame directory should compile the coffee files.

To automatically compile when a file has been modified, run
  > sh watch.sh

This should work, but it seems to not work on all editors.
It does not seem to work when gedit is used to modify the files.

Either way, I recommend you use sublime text to edit coffee files,
which supports syntax highlighting.

1. Download the tar ball here: http://www.sublimetext.com/2
   Lab machines are 64 bit linux.

2. Extract the tar ball to somewhere and run sublime_text.
   You can do an alias for this file if you want.

3. Sublime text takes a while to open for the first time.
   Once it opens, go to Preferences > Browse Packages

4. Download the package below:
   http://sublime.wbond.net/Package%20Control.sublime-package

5. Open the package using the normal ubuntu file extractor
   Extract all the files to the folder that opened when you
   did Preferences > Browse Packages in sublime text.

6. Restart sublime text, then do Preferences -> Package Control

7. Type install package and hit enter.

8. Type coffeescript and hit enter.

9. Restart sublime text.

10. Do Project -> Add folder to project and choose your tradersgame
    folder. Nice! You can nicely edit .coffee files.
