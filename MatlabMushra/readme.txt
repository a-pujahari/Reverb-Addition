...............//\\......//\\................................||........................................
..............//..\\....//..\\...............................||........................................
.............//....\\..//....\\..............................||........,,..............,,..............
............//......\\//......\\.......||.......||.//=======.||........//======...//===\\..............
...........//..................\\......||.......||.||........||=====\\.||........//.....\\.............
..........//....................\\.....||.......||.||........||.....||.||.......//.......\\............
.........//......................\\....||.......||.\\=====\\.||.....||.||......||.........||...........
........//........................\\...\\.......//........||.||.....||.||.......\\.......//\\..........
.......//..........................\\...\\.....//.........||.||.....||.||........\\.....//..\\.........
......//............................\\...\\===//...=======//.||.....||.||.........\\===//....\\=.......

Mushra Version 0.4

Good day! and welcome to Mushra. This package contains a small collection of functions for undertaking 
Mushra listening tests in Matlab.

-------------------------------------------- RELEASE NOTES --------------------------------------------
Version 0.5
* Results analysis function improved.
* Distribution function added.

Version 0.4
* Some Mac specific bugs fixed (calls to sound() replaced with audioplayer objects).
* Ability to continue from old save files reimplemented.
* Command line interface improved (flag type arguments).
* Lots of fancy new error messages added.
* Level matching function added. The functionality of this suffers due to Matlab's naff audio placback.

Version 0.3
* Fixed some bugs.
* Added a simple function for the analysis of results.
* Added different colour for the currently playing sample.
* Added the ability to accept test subjects comments.
* Removed ability to continue a test from a half completed save file (to be reimplemented one day).

Version 0.2
* Save file bugs fixed.
* Improved efficiency.
* Button colours!!

Version 0.1
* The inception.
* Buggy as all hell.
* Doesn't exist except in a distant memory.

------------------------------------------- FOLDER CONTENTS -------------------------------------------
Inside the .zip file you should have the following:
	* readme.txt (This read me file, if you don't have this I am unsure how you are reading it.)
	* example_config.txt (An example configuration file.)
	* Mushra.m (The main function for starting a Mushra test.)
	* MushraTraining.m (A function which builds a GUI for the training phase of the test.)
	* MushraTrainingCallbacks.m (All the callback functions for the training phase GUI.)
	* MushraEvaluation.m (A function which builds a GUI for the evaluation phase of the test.)
	* MushraEvaluationCallbacks.m (All the callback functions for the evaluation phase GUI.)
    * MushraComments.m (A function which builds a GUI for accepting user comments on each experiment.)
    * MushraCommmentsCallbacks.m (All the callback functions for the comments GUI.)
	* MushraResult.m (A class definition for storing the results of a test.)
    * LevelMatch.m (A small GUI for matching the levels of audio samples.)
    * LevelMatchCallbacks.m (The callback functions for the level match GUI.)
    * CreateMushraDistributable.m (Generates a folder with all the resources needed for a test.)
    * analyseMushraResults.m (A function to read in and analyse results files.)
If all of these file are present you are ready and hopefully everything should work.


-------------------------------------------- INSTALLATION ---------------------------------------------
To install the package simply extract the folder from the .zip and put it wherever you deem sensible.
You may wish to add this folder to the search path of Matlab so you can run it whenever. If not you 
will need to have your working directory set to the folder containing Mushra.m and all its buddies to
run a test. 


------------------------------------------- MUSHRA TESTS ----------------------------------------------
The Mushra listening test methodology is described fully in ITU recommendation ITU-R BS.1534-1. This
can easily be found using a quick Google search.

In brief the test is comprised of two phases. The training phase and the evaluation phase.

In the training phase the test subject is able to listen to all of the audio sample that will be 
encountered during the test.

In the evaluation phase the test subject is asked to rate a given selection of sample against a
reference sample. The evaluation phase is broken down into separate experiments. Each experiment will
have a reference sample and then several other samples which are the reference sample processed in 
different ways. The amount of samples in each experiment should be the same (all the same processes 
but applied to a different reference sample).


------------------------------------------- CONFIGURATION ---------------------------------------------
To run a Mushra test first you will first need to create a configuration file. This configuration file
will give the location of each audio sample for the test. The structure of the configuration file will
also describe the structure of the Mushra test (which samples are in which experiment and the number 
of experiments). The text should be divided into paragraphs, each paragraph will contain the locations 
of each audio file in an experiment. Paragraphs should be separated by one or more empty lines. The 
first line of a paragraph will give the location of the reference sample for that experiment. Each 
subsequent line will give the location of a single test sample for that experiment. 

The file 'example_config.txt' is an example of a configuration file with 3 experiments and 3 samples
per experiment. 

Please be aware that this package will not automatically generate anchor signals for you so you will 
have to include them as file locations in the configuration file. 

The file locations should be given with their path and file name. For example if I had an audio file
called 'sound.wav' saved in 'C:\Users\Me\Documents'. The line giving its location in my configuration
file would read:

                                C:\Users\Me\Documents\sound.wav

I would suggest it is wise to use absolute paths to file in your configuration file but if you are 
brave (and get it right) relative paths would work just fine.								

It is probably worth noting at this point that this package will only support .wav files at the moment.
Once you have created your configuration file you may save it where you please and name it anything you
wish.


------------------------------------------ RUNNING A TEST ---------------------------------------------
Once you have created your configuration file you are ready to run a test. If you have added the Mushra 
folder to your Matlab search path you are one step ahead. If you haven't you will now need to change
Matlab's working directory to the Mushra folder.

A test is started by running the Mushra function. The first argument passed to this function should be
a string containing the location of the configuration file you wish to use. There are other optional
arguments that we shall cover later. As an example, say I had created a configuration file called 
'Test1Config.txt' and saved it in 'C:\Users\Me\Listening Tests\Test1'. To start the test I would type:

                     Mushra('C:\Users\Me\Listening Tests\Test1\Test1Config.txt')

In the Matlab command window (don't forget the single quotes around the file location). This will
run the test described in 'Test1Config.txt'.
					
Notice that the use of absolute paths to my configuration files in these examples but it is probably
simpler to use relative paths when you can.

There are currently two optional arguments which can used to change the settings of the test. These are
passed to the Mushra function as strings. The order in which they are passed does not matter, so long
and the first argument passed is always the configuration file location. The optional arguments are:

	* 'comments' (this enables the test subjects to provide comments after each experiment)
	* 'continue' (this will allow tests to be continued from partly finished save files)
	
To run the test from before with comments and continuation enabled I would type:

           Mushra('C:\Users\Me\Listening Tests\Test1\Test1Config.txt', 'comments', 'continue')
			
In the Matlab command window.

After running the Mushra command with the desired arguments the test should run from start to finish 
automatically. Firstly the program will ask the user for a location to save the results (or a save file
to load if the continue option is enabled). After that the training phase will launch, followed by the
evaluation phase.

In each phase all the samples must be played at least once before the subject is allowed to continue 
to the next phase. 
	* Samples which have not been played yet have red buttons.
	* Samples which have been played have green buttons.
	* The button for the sample which is currently being played will be blue.
	
In the evaluation phases the subject is presented with buttons to play each sample and a slider to rate
each sample. Only the slider for the most recently played sample will be enabled at any one time. The
subjects should be asked to rate the quality of each sample in relation to the reference sample. At
least one of the samples should be given a score of 100 (hopefully the hidden reference). 

Once these requirements have been met the proceed button will be enabled and the subject can continue 
to the next experiment.


--------------------------------------------- RESULTS -------------------------------------------------
The results are saved in files with the extension '.mush'. The analyseMushraResults function will read 
in all the files in a given directory with this extension and plot some graphs. This function is in the 
early stages of development and still requires a lot of functionality to be added. 

The function takes one argument which is the path to the directory in which you results files reside.
At the moment it will only work if the directory only contains results for one given set of tests 
(those created by running Mushra with the same configuration file). 

The graphs plotted show the mean grading for each audio sample with a confidence interval shown by the
error bars.

If you have any questions about the analysis of results it is probably easier to ask me at this point.


------------------------------------------- KNOWN BUGS ------------------------------------------------
Unix compatibility could cause issues.


-------------------------------------- FUTURE DEVELOPMENTS --------------------------------------------
* Perhaps an option to automatically create low pass filtered anchor samples.
* UNIX support?
* Come up with a really cool name!


------------------------------------------- LICENCING -------------------------------------------------
Do what you please it's just letters, numbers and punctuation written in a particular order after all.