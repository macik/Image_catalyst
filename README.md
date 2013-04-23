Image Catalyst
==============

Pack of Windows utils to optimize (lossless compression) graphic files (JPEG and PNF formats). 
Using it is as good practice if you work with web page graphics (sprites and stand alone files).

Author of project - lorents and res2001.
Consulting - x128.
Translating to english and uploading to GitHub - macik.

Special thanks:

 * x128 - for stans alone app – JType;
 * madmasles - for DlgMsgBox util;
 * Andrey Chernomyrdin - for porting jpegrescan.pl for Windows;

Authors not respinsible for any thing.
Use it for your own risk. 

Making backup is strongly recommended.

Read this instructions.

Tools for PNG optimizing:
--------------------------

  - AdvDef (part of AdvanceComp 1.15 from 01.11.2005);
  - DeflOpt 2.07 from 05.09.2007;
  - Defluff 0.3.2 from 07.04.2011;
  - PNGOut from 02.07.2011;
  - TruePNG 0.4.0.4 from 06.04.2012.


Tools for JPG optimizing:
-------------------------

  - JHead 2.95 from 16.03.2012;
  - JPGCrush from 29.11.2008 / 20.04.2012;
  - JPEGTran (part of LibJPEG 8d from 15.01.2012);


Addition software:
------------------

  - DlgMsgBox from 29.02.2012;
  - JType from 09.02.2012;
  - MiniPerl (as part of Denwer 3 from 07.11.2010);
  - Zlib 1.2.6 from 29.01.2012.

All util files packed with UPX.


Manual:
=======

 - You can add files for optimization queue this ways:
    * start "Image Catalyst.bat" and with «File browser» dialog choose graphic files;
    * drag`n`drop selected files and/or folders on "Image Catalyst.bat" shortcut;
    * run "Image Catalyst.bat" with full path folder with graphic files (by default program process all subfolders).
 - Then select output folder for optimized files (program retain existing folder structure). 
 You can use «overwrite» mode by pressing Cancel button in «Output folder selection» dialog 
 (in this case all original files will be overwrited with optimized ones).
 - By default for PNG optimization multithreading is used (see `config.ini` to change this).
 - You can change base setting of project by edit `Tools\config.ini` file with any text editor.
 - You can not use special symbols like `&`, `^`, `%` `(`, `)`, `!` in filenames or paths.


Types of PNG files:
-------------------

  - Non-interlaced - standard mode.
  - Interlaced - terlacing is a trade-off: it dramatically speeds up early rendering of large 
  files (improves latency), but may increase file size (decrease throughput) for little gain, 
  particularly for small files.


Optimization modes for PNG:
---------------------------

  - Non-interlaced - standard mode. Continuous PNG loading;
  - Interlaced - uses «pregressive loading» mode. And better user experience on slow connection or big data;
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
	
	http://www.0x99.ru/Pages/jpeg/content/cnt-05.aspx (in russian)
	http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/JPEG.html
