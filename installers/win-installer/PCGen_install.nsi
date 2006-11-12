; Current Ver: $Revision$
; Last Editor: $Author$
; Last Edited: $Date$
;
;	This script is licensed under the following license



; Script Created with Venis IX 2.2.3	http://www.spaceblue.com/venis/info.php (recomended)
; NSIS 2.04				http://nsis.sourceforge.net



; Known issues
; ver fixed		Problem
; 1.5					PCGen install directory is not romoved under full uninstall
; 1.6					Need option to keep character and customsources directory
; 1.24				PCGen 5.9.3 Alpha
;							Reviewed and corrected the data sections
;							The command prompt boxes are now launched minimized from the shortcuts
;							There is no longer any GMGen notion in PCGen. I've renamed the section
;							Optionnal Plugins
; 1.25				Test to see if the commit notification works
; 1.26				Version for release 5.9.4 Alpha

; Outstanding Issues
;		Need file association for .pcg files
;		java -Dpcgen.inputfile=Ilse.pcg -Dpcgen.outputfile=Ilse.pdf -Dpcgen.templatefile=csheet_fantasy_std_blackandwhite.xslt -jar pcgen.jar



; Internal Version history
; 1.0 	First version uploaded to CVS
; 1.1 	Updated PDF Plug-in to only copy PDF output templates if PDF is selected
; 1.2 	Pointed the desktop shortcut to pcgen_high_mem.bat and added start /min to batches
; 1.3 	Changed path to force ${APPDIR} should solve problems with install directory (fail)
; 1.4 	Pointed shortcuts to icons in local, created internal version
; 1.5 	Changed location of uninstaller to fix full uninstall problem
; 1.6 	Added backup feature to save character, customsources, options if user wishes
; 1.7 	Changed to use of constant for simple version ie 5714 now ${SIMPVER}
; 1.8 	Added compilation instructions
; 1.9 	Added variables for OutDir and SrcDir {SpaceMonkey}
;     	Changed OutName to reflect the standard names for PCGen Windows installs
;     	Removed Section "Alderac Entertainment Group" from alpha
;     	Added missing steps in the instructions
;     	Corrected a typo with the pcgen-release-notes-${SIMPVER}
; 1.10	Version used for pcgen580rc1'
;				Alpha data sets are now separated
; 1.11	Updated registry information, so that their is a PCGen\PCGen ver listing
;				Removed Alpha data sources from main install, as per SpaceMonkey
; 1.12	Fixed the build instructions that I broke, testing with pcgen580rc2 to
;				ensure that these really work (glasswalkertheurge)
;				verified seperated alpha install
; 1.13  RC3 Release
;       Added Behemoth3 in d20ogl (SpaceMonkey)
; 1.16  RC4 Release (SpaceMonkey)
;       Added !insertmacro MUI_PAGE_DIRECTORY (I though I had already fixed that...)
; 1.17	Changed the OverVer tp "1.6", this will allow users to use Java 1.5 on their
;				machines, unfortunatly minor rev levels are not tracked, so if some future
;				1.5.x does not work, I will have to revisit this.  (GlassWalkerTheurge)
;	1.18	Working on fixing FREQs for installer
;				1378109 - Normal install, should now remove folders and files only
;					- Full install is still dangerous, but user is double warned
;				1483179 - GMGen info is now saved
;				1453142 - PCGen is removed from start folder under full install
;					- Not in normal install, as this would remove other instances of PCGen
; 1.19  Autogenerate sources list using a perl script to avoid missing any sources.
;				



; Instructions for compilation
;  1.	Download latest version
;  2.	Extract version to ${SrcDir}\PCGen_${SIMPVER}b
;			[where ${SIMPVER} is the simple version number i.e. "5714".]
;			These directorys will now be refered to	as b and c.
;  		a.	If you choose another path, you must change ${SrcDir} to the match
;  3.	create a directory called ${SrcDir}\PCGen_${SIMPVER}c
;  4.	create a directory called ${SrcDir}\Local and put all the icons and the splash screen in it
;  5.	copy the data directory from b to c
;  6.	erase everything in the b data directory except custom sources
;  7.	erase the custom sources directory in the data directory of c
;  8.	create a "plugin" directory in the c directory
;  9.	create the following directorys in the plugin directory on c;
;			gmgen, pdf, skin
; 10.	in the gmgen directory on c, create a directory called plugins
; 11.	in this directory, move everthing from the b plugin directory except
;			CharacterSheet.jar, the Export*.jar, GameMode*.jar and Lst*.jar
; 12.	in the pdf directory, create a lib and an outputsheets directories
; 13.	in the lib directory move the following file from the b lib directory;
;			fop.jar, fop.license.txt, jdom.jar, jdom.license.txt, xml-apis.jar,
;			xml-apis.readme.txt
; 14.	in the outputsheets directory, move all the \pdf\ folder from outputsheets in the b dir
; 15.	in the skin directory, create a lib directory
; 16.	from the b lib directory move everything except the following files;
;			jep.jar
; 17.	go to the b docs acknowledgments directory
; 18.	remove the html tags from the ogl license and the gnu license file
; 19.	save these files as one text file called PCGenLicense.txt
; 20.	the alpha source files should be placed in the data directory
; 21.	you can now build both the primary and the alpha source build.



; Begin Script ----------------------------------------------------------------------------
; Include the externally defined constants
!include includes\constants.nsh

; Define constants
!define APPNAME "PCGen"
!define APPNAMEANDVERSION "${APPNAME} ${LONGVER}"
!define APPDIR "PCGen${SIMPVER}"
!define TargetVer "1.5"
!define OverVer "1.6"
!define OutName "pcgen${SIMPVER}_win_install"


; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\${APPNAME}"
InstallDirRegKey HKLM "Software\${APPNAME}\${APPDIR}" ""
OutFile "${OutDir}\${OutName}.exe"
;This will save a little less than 1mb, it should be left enabled <Ed
SetCompressor lzma
;This will force the installer to do a CRC check prior to install,
;it is safer, so should be left on. <Ed
CRCCheck on

; Install Type Settings
InstType "Full Install"
InstType "Average Install"
InstType "Average All SRD"
InstType "Min - SRD"
InstType "Min - SRD 3.5"
InstType "Min - MSRD"

;	Look and style
ShowInstDetails show
InstallColors FF8080 000030
XPStyle on
Icon "${SrcDir}\Local\PCGen2.ico"


; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${SrcDir}\PCGen_${SIMPVER}b\docs\acknowledgments\PCGenLicense.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

; Set User Variables
Var "JREVer"
Var "JDKVer"

Function .onInit

	;Checks for versions of Java between TargetVer and OverVer
	; this can be changed once PCGen is stable on Java 1.5 and above

	ClearErrors
	ReadRegStr $R0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
	StrCpy $JREVer $R0
	ReadRegStr $R0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$R0" "JavaHome"
	IfErrors 0 FoundVM

	ClearErrors
	ReadRegStr $R0 HKLM "SOFTWARE\JavaSoft\Java Development Kit" "CurrentVersion"
	StrCpy $JDKVer $R0
	ReadRegStr $R0 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$R0" "JavaHome"
	IfErrors 0 FoundVM

	ClearErrors
	ReadEnvStr $R0 "JAVA_HOME"
	IfErrors 0 FoundVM

	DetailPrint "Java not found"
	Sleep 800
	MessageBox MB_ICONEXCLAMATION|MB_YESNO \
		'Could not find a Java Runtime Environment installed on your computer. \
		$\nWithout it you cannot run "${APPNAME}". \
		$\n$\nWould you like to visit the Java website to download it?' \
		IDNO End
	ExecShell open "http://java.com/en/download/windows_automatic.jsp"
	Goto End

	FoundVM:
	DetailPrint "Java was found"
	DetailPrint $JREVer
	DetailPrint $JDKVer
	IntCmp $JREVer ${TargetVer} VMGood VMOld VMOver
	IntCmp $JDKVer ${TargetVer} VMGood VMOld VMOver
	Goto Error

	VMOver:
	IntCmp $JREVer ${OverVer} VMHigh VMGood VMHigh
	IntCmp $JDKVer ${OverVer} VMHigh VMGood VMHigh
	Goto Error

	VMHigh:
	DetailPrint "Java Version Bad"
	Sleep 800
	MessageBox MB_ICONEXCLAMATION|MB_YESNO \
		'Found Java Runtime Environment installed on your computer. \
		$\nVersion was not "${TargetVer}". \
		$\n$\nWould you like to visit the Java website to download newest?' \
		IDNO Error
	ExecShell open "http://java.com/en/download/windows_automatic.jsp"
	Goto Error

	VMGood:
	DetailPrint "Java Version Good"
	Goto End

	VMOld:
	DetailPrint "Java Version Bad"
	Sleep 800
	MessageBox MB_ICONEXCLAMATION|MB_YESNO \
		'Found Java Runtime Environment installed on your computer. \
		$\nVersion was not "${TargetVer}". \
		$\n$\nWould you like to visit the Java website to download newest?' \
		IDNO Error
	ExecShell open "http://java.com/en/download/windows_automatic.jsp"
	Goto Error

	Error:
	MessageBox MB_YESNO|MB_ICONQUESTION "PCGen will most likely not run, do you wish to install it anyway?" IDYES End
	Abort "Error during Java Detection"
	Goto End

	End:

 FunctionEnd

Section "PCGen" Section1

	SectionIn RO

	; Set Section properties
	SetOverwrite ifnewer

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\${APPDIR}\"
	File /r "${SrcDir}\PCGen_${SIMPVER}b\*.*"

SectionEnd

SubSection /e "Data" Section2

# Run the perl script gendatalist.pl to generate the file below.
!include includes\data.nsh

SubSectionEnd

SubSection /e "PlugIns" Section3

	Section "Skins"

	SectionIn 1 2 3
	SetOutPath "$INSTDIR\${APPDIR}\lib"
	File /r "${SrcDir}\PCGen_${SIMPVER}c\plugin\skin\lib\*.*"

	SectionEnd

	Section "PDF"

	SectionIn 1 2 3
	SetOutPath "$INSTDIR\${APPDIR}\lib"
	File /r "${SrcDir}\PCGen_${SIMPVER}c\plugin\pdf\lib\*.*"
	SetOutPath "$INSTDIR\${APPDIR}\outputsheets"
	File /r "${SrcDir}\PCGen_${SIMPVER}c\plugin\pdf\outputsheets\*.*"

	SectionEnd

	Section "Optional Plugins"

	SectionIn 1 2 3
	SetOutPath "$INSTDIR\${APPDIR}\plugins"
	File /r "${SrcDir}\PCGen_${SIMPVER}c\plugin\gmgen\plugins\*.*"

	SectionEnd

SubSectionEnd

Section "-Local" Section4

	; Set Section properties
	SetOverwrite ifnewer

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\${APPDIR}\Local\"
	File /r "${SrcDir}\Local\*.*"

	; Create Shortcuts
	SetOutPath "$INSTDIR\${APPDIR}\"
	CreateDirectory "$SMPROGRAMS\PCGen\${APPDIR}"
	CreateShortCut "$DESKTOP\${APPDIR}.lnk" "$INSTDIR\${APPDIR}\pcgen.bat" "" \
				"$INSTDIR\${APPDIR}\Local\PCGen2.ico" 0 SW_SHOWMINIMIZED
	CreateShortCut "$SMPROGRAMS\PCGEN\${APPDIR}\${APPDIR}-Low.lnk" "$INSTDIR\${APPDIR}\pcgen_low_mem.bat" "" \
				"$INSTDIR\${APPDIR}\Local\PCGen.ico" 0 SW_SHOWMINIMIZED
	CreateShortCut "$SMPROGRAMS\PCGEN\${APPDIR}\${APPDIR}.lnk" "$INSTDIR\${APPDIR}\pcgen.bat" "" \
				"$INSTDIR\${APPDIR}\Local\pcgen2.ico" 0 SW_SHOWMINIMIZED
	CreateShortCut "$SMPROGRAMS\PCGen\${APPDIR}\Release Notes.lnk" "$INSTDIR\${APPDIR}\pcgen-release-notes-${SIMPVER}.html" "" "$INSTDIR\${APPDIR}\Local\knight.ico"
	CreateShortCut "$SMPROGRAMS\PCGen\${APPDIR}\News.lnk" "http://pcgen.sourceforge.net/01_news.php" "" "$INSTDIR\${APPDIR}\Local\queen.ico"
	CreateShortCut "$SMPROGRAMS\PCGen\${APPDIR}\uninstall-${APPDIR}.lnk" "$INSTDIR\uninstall-${APPDIR}.exe"
	CreateShortCut "$SMPROGRAMS\PCGen\${APPDIR}\Manual.lnk" "$INSTDIR\${APPDIR}\docs\index.html" "" "$INSTDIR\${APPDIR}\Local\castle.ico"

SectionEnd

Section -FinishSection

	WriteRegStr HKLM "Software\${APPNAME}\${APPDIR}" "" "$INSTDIR\${APPDIR}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPDIR}" "DisplayName" "${APPDIR}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPDIR}" "UninstallString" "$INSTDIR\uninstall-${APPDIR}.exe"
	WriteUninstaller "$INSTDIR\uninstall-${APPDIR}.exe"

SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} "This is the PCGen Core"
	!insertmacro MUI_DESCRIPTION_TEXT ${Section2} "This section installs the data sets you need"
	!insertmacro MUI_DESCRIPTION_TEXT ${Section3} "This section installs the plug ins you may need"
	!insertmacro MUI_DESCRIPTION_TEXT ${Section4} "This is for icons and such"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section Uninstall

	; Delete self
	Delete "$INSTDIR\uninstall-${APPDIR}.exe"

	; Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPDIR}"
	DeleteRegKey HKLM "Software\${APPNAME}\${APPDIR}"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPDIR}_alpha"

	; Delete Desktop Shortcut
	Delete "$DESKTOP\${APPDIR}.lnk"
	; Delete Shortcut Directory
	RMDir /r "$SMPROGRAMS\PCGen\${APPDIR}"

	MessageBox MB_YESNO|MB_ICONEXCLAMATION "Do you wish a full uninstall? $\nThis will remove all versions of pcgen from your computer." IDYES Full IDNO Partial

	Full:
	MessageBox MB_YESNO "This option could be dangerous, if you have other versions of ${APPNAME}, or if ${APPNAMEANDVERSION} was installed to a directory other than the default.  Do you wish to proceed?" IDYES Proceed IDNO Save
	
	Proceed:
	; Clean up PCGen program directorys
	; This is a safer mode
	RMDir /r "$INSTDIR"
	; Delete Shortcut Directory
	RMDir /r "$SMPROGRAMS\PCGen"
	;Remove registry entry
	DeleteRegKey HKLM "Software\${APPNAME}"

	Goto End
	
	Partial:
	MessageBox MB_YESNO "Do you wish to save, your characters, custom sources etc? $\nAnswering no will delete ${APPDIR}." IDYES Save IDNO NoSave

	Save:
	CreateDirectory "$INSTDIR\${APPDIR}_Save"
	CreateDirectory "$INSTDIR\${APPDIR}_Save\characters"
	CreateDirectory "$INSTDIR\${APPDIR}_Save\customsources"
	CreateDirectory "$INSTDIR\${APPDIR}_Save\options"
	CreateDirectory "$INSTDIR\${APPDIR}_Save\GMGen"
	CopyFiles /SILENT "$INSTDIR\${APPDIR}\characters\*.*" 					"$INSTDIR\${APPDIR}_Save\characters\"
	CopyFiles /SILENT "$INSTDIR\${APPDIR}\data\customsources\*.*" 	"$INSTDIR\${APPDIR}_Save\customsources\"
	CopyFiles /SILENT "$INSTDIR\${APPDIR}\*.ini" 										"$INSTDIR\${APPDIR}_Save\options\"
	;Ed> This has not been tested, Please test.
	CopyFiles /SILENT "$INSTDIR\${APPDIR}\plugins\Notes\*.*" 				"$INSTDIR\${APPDIR}_Save\GMGen\"
	MessageBox MB_ICONINFORMATION|MB_OK "A shortcut will be created on your desktop to the saved files."
	CreateShortCut "$DESKTOP\${APPDIR}_Save.lnk" "$INSTDIR\${APPDIR}_Save"

	NoSave:
	; Clean up PCGen program directory by deleting folders.
	;Ed>This method is used, as a safer alternative
	RMDir /r "$INSTDIR\${APPDIR}\characters"
	RMDir /r "$INSTDIR\${APPDIR}\data"
	RMDir /r "$INSTDIR\${APPDIR}\docs"
	RMDir /r "$INSTDIR\${APPDIR}\lib"
	RMDir /r "$INSTDIR\${APPDIR}\Local"
	RMDir /r "$INSTDIR\${APPDIR}\outputsheets"
	RMDir /r "$INSTDIR\${APPDIR}\plugins"
	RMDir /r "$INSTDIR\${APPDIR}\system"
	;Ed>below would be the removal of all files in the PCGen root directory, on a file by file basis.
	;Delete /REBOOTOK "pcgen.jar"
	Delete /REBOOTOK "pcgen.jar"
	Delete /REBOOTOK "pcgen-release-notes-${SIMPVER}.html"
	Delete /REBOOTOK "pcgen.bat"
	Delete /REBOOTOK "pcgen.sh"
	Delete /REBOOTOK "pcgen_low_mem.bat"

	End:

SectionEnd

; eof