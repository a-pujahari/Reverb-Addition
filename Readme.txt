This file acts as a guide to the structure of the files within this folder and the subfolders within them. All the code was written and tested on MATLAB R2016b, the Audio System Toolbox is required
for complete functionality. 
All audio was downloaded from http://www.cambridge-mt.com/ms-mtk.htm (The 'Mixing Secrets' Free Multitrack Download Library).
MUSHRA test for MATLAB was obtained from https://sourceforge.net/p/matlabmushra/code/ci/master/tree/MatlabMushra/ and suitably modified for compatibility on MATLAB R2016b.

Folder Structure:
The major folders contain code and audio files for different genres and are named as such i.e Classical, Pop, Heavy Metal etc.
The folder "MatlabMushra" contains the files used for the MUSHRA test, and the folder "Results" contained within contains the results from the 22 participants. 
The audio files contained within each genre folder are the audio excerpts used for the tests. The processing sequence and parameters are as defined in Chapter 6 of the thesis.
The subfolder "Test Files" within each genre folder contains the final parameters obtained for multiple methods and correspondingly prepared final files for input to the listening tests.

Code Structure:
The code "Prelim" reads the audio files and creates matrices Y and b_corr to be used during optimization.
The code "fminconfuncopt" represents the mathematical optimization code and invokes a subfunction "MinConTest_ult". The code "lsqnonlinfuncopt" also performs the same mathematical optimization,
but uses the MATLAB function lsqnonlin rather than fmincon for optimization.

The codes "specmask" and "specmask_alt" refer to the primary and alternate implementations of the spectral masking minimization procedures. 

The loudness meter, long and short reverbs are stored as objects (loudMtr.mat, reverb_long.mat and reverb_short.mat) which the codes use after loading into the workspace within their subroutines. 

The simulink files in each genre subfolder named Reverb_Setup_<genre>.slx is the Reverb Addition Setup created for professional producer input. 

The code "FileCreator" within each "Test Files" subfolder uses the parameters obtained from the reverb addition algorithms to create the final audio files used as input to the listening tests.


