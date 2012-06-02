_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
           New: Node.js server with socket.io and express engine
_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

There's quite a lot involved here.
-> Node.js: Server side javascript - http://nodejs.org/api/
-> Socket.io: Websocket server for node - http://socket.io/
-> Express: Node web framework, used to serve html pages and other stuff - 
   http://expressjs.com/

Note, none of the steps below have been tested in lab machines but hopefully
it should still work since the node server is installed locally on lab machines.



                ---[Installation of server dependencies]---
                   
I did all the hard work for you.
You need to run:
	> sh install_node_modules.sh
In the tradersgame directory. This will install all required modules for node.



                        ---[Running the server]---
                        
All you do is
	> sh runserver.sh
This both compiles the coffee code for the server AND runs it in node.



                        ---[Running the client]---
                        
*client code is now in the tradersgame/public directory*
Ensure that coffee code is compiled. This can be done by
	> cd public
	> sh compile.sh

Or, in tradersgame:
	> sh compile-all.sh
which compiles both server and client coffee files.

Once coffee compiles succesfully, open a web browser and go to:
	http://localhost:8080/

Of course, if the server is NOT running, you'll get an error.
See above for how to run the server.



                   ---[Browsing local (client-only)]---
                   
You can open public/index.html in your browser as before and everything
should still work. This only runs client code. Any server interaction will 
cause errors.

_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
                  Installing CoffeeScript and Sublime Text
_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

Note: CoffeeScript is required to compile the coffeescript files.


To install coffeescript at home, follow the instructions on
http://coffeescript.org/#installation

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
   Once it opens, go to Preferences > Browse Packages. 
   Create a folder called 'Package Control'

4. Download the package below:
   http://sublime.wbond.net/Package%20Control.sublime-package

5. Open the package using the normal ubuntu file extractor
   Extract all the files to the 'Package Control' folder.

6. Restart sublime text, then do Preferences -> Package Control

7. Type install package and hit enter.

8. Type coffeescript and hit enter.

9. Restart sublime text.

10. Do Project -> Add folder to project and choose your tradersgame
    folder. Nice! You can nicely edit .coffee files.
