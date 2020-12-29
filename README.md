Hey: A Launcher/Proof of Concept
================================

One of the things that I miss the most from MacOS is AppleScript.  Yes, Linux has Bash and a myriad of
other scripting languages but AppleScript integrates really well with GUI applications; most applications
expose functionality to scripts via libraries (called "Dictionaries" in AppleScript parlance) and these
functions can be called upon relatively easily via external scripts.  

While looking for something to satiate my scripting urge, I found out that DBus has much of the same functionality
as AppleScript and AppleEvents.  I also found out that BeOS/HaikuOS has a program called `hey` which allows for 
much of the same level of interprocess scripting as AppleScript (albeit used as a command and not as a whole
language).  

What resulted is my very limited implementation of `hey` using DBus calls (and `.desktop` files).  

Dependencies
------------
+ A modern version of perl
+ `File::DesktopEntry`
+ `Net::Dbus`
+ `Net::Dbus::Binding::Value`

Limitations
-----------

Right now, since hey is using a library to open FreeDesktop `.desktop` files for intial launch (and since
that library is somewhat buggy), `.desktop` files with reverse domain names (e.g. `org.gnome.Epiphany`) are
not able to open up.  If I continue developing `hey` past the proof of concept stage, I will probably either
find a better library or implement my own launch functionality.

Also, the number of applications supported for DBus use and the number of functions supported is fairly limited
as well.

Finally, the way I am determining which library to load and the manner in which I am actually loading them is
quite crude; for the purposes of a proof of concept this is all right but if I were to develop `hey` further,
I would implement that part in a better manner.
