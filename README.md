#  Image Catalyst v2.3 
=======================

>  For latest version link see http://x128.ho.ua/update.ini 
>  See http://rghost.ru/51256939 - for version 2.3 from 28.12.2014   
>  This utils pack distributed AS IS. To see certain licenses or manuals see utilities official sites.

Pack of Windows utils to optimize (lossless compression) graphic files (JPEG and PNG formats). 
Using it is as good practice if you work with web page graphics (sprites and stand alone files).

Author of project - lorents and res2001.
Consulting - x128.
Translating to english and uploading to GitHub - macik.

Special thanks:

 * x128 - for stand alone app – JType;
 * madmasles - for DlgMsgBox util;
 * Andrey Chernomyrdin - for porting jpegrescan.pl for Windows;

Authors not responsible for any thing.
Use it for your own risk. 

Making backup is strongly recommended.

Read this instructions.

Tools for PNG optimizing:
--------------------------

  - AdvDef (from AdvanceComp 1.18 from 17.11.2013);
  - DeflOpt 2.07 from 05.09.2007;
  - Defluff 0.3.2 from 07.04.2011;
  - PNGWolf from 11.03.2011 / 28.05.2013;
  - TruePNG 0.4.1.1 from 27.10.2013.


Tools for JPG optimizing:
-------------------------

  - JHead 2.97 from 30.01.2013;
  - JPEGRescan from 28.12.2013;
  - JPEGTran (from LibJPEG 9 bundle from 13.01.2013);


Addition software:
------------------

  - DlgMsgBox from 29.02.2012;
  - Perl (from XAMPP Lite 1.8.1);

All util files packed with UPX.


Manual:
=======

 - You can add files for optimization queue this ways:
    * start "Image Catalyst.bat" and with «File browser» dialog choose graphic files;
    * drag`n`drop selected files and/or folders on "Image Catalyst.bat" shortcut;
    * run "Image Catalyst.bat" with full path folder with graphic files (by default program process all sub-folders).
 - Then select output folder for optimized files (program retain existing folder structure). 
 You can use «overwrite» mode by pressing Cancel button in «Output folder selection» dialog 
 (in this case all original files will be overwritten with optimized ones).
 - By default for PNG optimization multithreading is used (see `config.ini` to change this).
 - You can change base setting of project by edit `Tools\config.ini` file with any text editor.
 - You can not use special symbols like `&`, `^`, `%` `(`, `)`, `!` in file names or paths.


Types of PNG files:
-------------------

  - Non-interlaced - standard mode.
  - Interlaced - interlacing is a trade-off: it dramatically speeds up early rendering of large 
  files (improves latency), but may increase file size (decrease throughput) for little gain, 
  particularly for small files.


Optimization modes for PNG:
---------------------------

  - Non-interlaced - standard mode. Continuous PNG loading;
  - Interlaced - uses «progressive loading» mode. And better user experience on slow connection or big data;
  - Default - optimized file and leave original mode intact.


Structure of PNG:
-----------------

	http://libpng.org/pub/png/spec/1.2/PNG-Chunks.html
	http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/PNG.html


Types of JPEG files:
--------------------

  - Optimize - better optimized JPEG file. Browsers loading it continuously, while loading.
  - Progressive - format, in which data is compressed in multiple passes of progressively higher
	detail. This is ideal for large images that will be displayed while downloading over a slow 
	connection, allowing a reasonable preview after receiving only a portion of the data.


Optimization modes for JPEG:
----------------------------

  - Optimize - using Optimize mode;
  - Progressive - using Progressive mode;
  - Maximum - both optimize and progressive had made and used smaller one;
  - Default - optimize size but leave intact original image mode.


Structure of JPEG files:
------------------------
	
	http://www.0x99.ru/Pages/jpeg/content/cnt-05.aspx (in Russian)
	http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/JPEG.html
