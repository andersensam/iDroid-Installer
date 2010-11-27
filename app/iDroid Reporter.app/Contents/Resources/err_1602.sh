#!/bin/sh

echo "Welcome to the AndersenTech Error Reporter"


# ATTENTION:
# If you are reading this, you have opened the file in a text editor.
# If you would like to *run* this example rather than *read* it, you
# should open Terminal.app, drag this document's icon onto the terminal
# window, bring Terminal.app to the foreground (if necessary) and hit return.

# Wrapper function for interfacing to Pashua. Written by Carsten
# Bluem <carsten@bluem.net> in 10/2003, modified in 12/2003 (including
# a code snippet contributed by Tor Sigurdsson), 08/2004 and 12/2004.
# As 1st argument, you must pass a configuration string
# As 2nd argument, you may pass the encoding to use (see documentation)
# As 3rd argument, you may pass the path to the Pashua application,
#                  if it's not in one of the standard locations.
pashua_run() {

	# Write config file
	pashua_configfile=`/usr/bin/mktemp /tmp/pashua_XXXXXXXXX`
	echo "$1" > $pashua_configfile

	# Find Pashua binary. We do search both . and dirname "$0"
	# , as in a doubleclickable application, cwd is /
	# BTW, all these quotes below are necessary to handle paths
	# containing spaces.
	bundlepath="Pashua.app/Contents/MacOS/Pashua"
	if [ "$3" = "" ]
	then
		mypath=`dirname "$0"`
		for searchpath in "$mypath/Pashua" "$mypath/$bundlepath" "./$bundlepath" \
						  "/Applications/$bundlepath" "$HOME/Applications/$bundlepath"
		do
			if [ -f "$searchpath" -a -x "$searchpath" ]
			then
				pashuapath=$searchpath
				break
			fi
		done
	else
		# Directory given as argument
		pashuapath="$3/$bundlepath"
	fi

	if [ ! "$pashuapath" ]
	then
		echo "Error: Pashua could not be found"
		exit 1
	fi

	# Manage encoding
	if [ "$2" = "" ]
	then
		encoding=""
	else
		encoding="-e $2"
	fi

	# Get result
	result=`"$pashuapath" $encoding $pashua_configfile | sed 's/ /;;;/g'`

	# Remove config file
	rm $pashua_configfile

	# Parse result
	for line in $result
	do
		key=`echo $line | sed 's/^\([^=]*\)=.*$/\1/'`
		value=`echo $line | sed 's/^[^=]*=\(.*\)$/\1/' | sed 's/;;;/ /g'`		
		varname=$key
		varvalue="$value"
		eval $varname='$varvalue'
	done

} # pashua_run()


# Define what the dialog should be like
# Take a look at Pashua's Readme file for more info on the syntax

conf="
# Set transparency: 0 is transparent, 1 is opaque
*.transparency=0.95

# Set window title
*.title = OpeniBoot (Upgrade) Error

# Introductory text
tb.type = text
tb.default = Please Select and Describe Your Error Below!

# Define radiobuttons
rb.type = radiobutton
rb.label = Errors
rb.option = Port Blocked Error
rb.option = No OpeniBoot Menu
rb.option = Files Not Transferred 
rb.option = Other
rb.default = Port Blocked Error

# Add a text field
tx.type = textfield
tx.label = Please Describe Error
tx.default = 
tx.width = 310

# Add a cancel button with default label
cb.type=cancelbutton

";

# Set the images' paths relative to this file's path / 
# skip images if they can not be found in this file's path
icon=$(dirname "$0")'/.icon.png';
bgimg=$(dirname "$0")'/.demo.png';

if [ -e "$icon" ]
then
	# Display Pashua's icon
	conf="$conf
	     img.type = image
	     img.x = 530
	     img.y = 255
	     img.path = $icon"
fi

if [ -e "$bgimg" ]
then
 	# Display background image
	conf="$conf
	      bg.type = image
	      bg.x = 30
	      bg.y = 2
	      bg.path = $bgimg"
fi

pashua_run "$conf"

echo "Pashua created the following variables:"
echo "  tb  = $tb"
echo "  tx  = $tx"
echo "  ob  = $ob"
echo "  pop = $pop"
echo "  rb  = $rb"
echo "  cb  = $cb"
echo ""

echo $tx > desc.oib
echo $rb > radio.oib

zip -r $RANDOM.zip ./*.oib

mv ./*.zip $HOME

rm ./*.oib

sh finish_action.sh
