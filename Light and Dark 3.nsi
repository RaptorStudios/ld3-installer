#-------------------Setup di Installazione per Light and Dark 3-------------------#
  !include MUI2.nsh     #Include Modern UI
  !include FontName.nsh   #FontName
  !include FontRegAdv.nsh #http://nsis.sourceforge.net/Register_Fonts
						  # https://stackoverflow.com/questions/21741192/error-installing-a-font-with-nsis
  
  !define VERSIONE "v1.7"   #versione di Light and Dark 3
  !define NOMEXE "Game.exe"   #nome dell'eseguibile del gioco   
  

#-------------------GENERAL
  Name "Light and Dark 3"   #nome dell'installer
  Caption "Light and Dark 3 - Setup"   #scritta visualizzata nella barra in alto
  #Icon "${NSISDIR}\Light and Dark\modern-install-blue.ico"   #icona dell'installer
  OutFile "L&D3_installer_${VERSIONE}.exe"   #nome del file di installazione (di default viene creato nella directory del file .nsi)

  InstallDir "$PROGRAMFILES\Light and Dark 3"   #directory di installazione di default 
  InstallDirRegKey HKCU "Software\Light and Dark 3" ""   ;Get installation folder from registry if available
  
  SetCompressor /SOLID lzma   #comprime tutto in un unico blocco con l'algoritmo LZMA
  CRCCheck on   #l'installer fa un CRC su se stesso prima di installarsi
  RequestExecutionLevel highest   #privilegi richiesti in Windows  

#----------------------------Interface Settings

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Light and Dark\nsis2.bmp"
   
  !define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Light and Dark\nsis1.bmp"
  !define MUI_WELCOMEPAGE_TITLE "Benvenuti nel setup di Light and Dark 3 ${VERSIONE}"
  !define MUI_WELCOMEPAGE_TEXT "Questo programma vi guiderà nell'installazione di Light and Dark 3 ${VERSIONE}.$\r$\n$\r$\nSiete pronti?$\r$\n$\r$\n$\r$\n$_CLICK" 

  #!define MUI_LICENSEPAGE_TEXT_TOP "È necessario accettare i termini della licenza d'uso per procedere con l'installazione."
								  
  !define MUI_COMPONENTSPAGE_CHECKBITMAP "${NSISDIR}\Light and Dark\simple.bmp"
  !define MUI_COMPONENTSPAGE_TEXT_DESCRIPTION_INFO "Passa il mouse sulle componenti per ulteriori informazioni."
  
  #!define MUI_ABORTWARNING_TEXT "Sicuro di voler uscire?"
  
  
  !define MUI_UNCONFIRMPAGE_TEXT_TOP "Disinstallazione completa di Light and Dark 3"
  #!define MUI_UNCONFIRMPAGE_TEXT_LOCATION "bye bye" #Text to display next to the uninstall location text box.

  !insertmacro MUI_DEFAULT MUI_ICON "${NSISDIR}\Light and Dark\modern-install-blue-full.ico"   #icona dell'installer
  !insertmacro MUI_DEFAULT MUI_UNICON "${NSISDIR}\Light and Dark\modern-uninstall-blue-full.ico"   #icona dell'uninstaller
  
  
  
  
XPStyle on
InstallColors /windows   #usa come colori della finestra di installazione quelli di default di windows
InstProgressFlags smooth   #stile della barra del progresso

BrandingText "Setup creato dai Raptor Studios con Nullsoft Scriptable Install System v3.03"


LicenseForceSelection radiobuttons "Accetto" "WTF?"   #l'utente deve per forza accettare la licenza

# ComponentText "Oltre all'installazione automatica puoi scegliere quella manuale; riceverai le istruzioni per installare il gioco $\"manualmente$\", \
#                salvando i file indicati nelle cartelle del sistema."
DirText "Il setup installerà le componenti selezionate nella seguente destinazione.$\r$\nPer scegliere un'altra destinazione, \
         cliccare su $\"Sfoglia$\" e selezionare la cartella.$\r$\nCliccare su $\"Installa!$\" per procedere con l'installazione." \
		 "Cartella di destinazione" Sfoglia... "Seleziona la cartella dove installare Light and Dark 3:"

MiscButtonText <Indietro Avanti> Annulla Chiudi   #di default sono < Back, Next >, Cancel, Close
InstallButtonText Installa!   #il testo di default è "Install"
SpaceTexts "Spazio necessario: " "Spazio disponibile: "   #il testo di default è Space required:, Space available:
DetailsButtonText "Mostra dettagli"

CompletedText "Completato!"   #di default è "Completed"
FileErrorText "Impossibile scrivere il file $\r$\n$0$\r$\nNel caso dei fonts (*.ttf), potrebbe essere già installato."

AutoCloseWindow false
ShowInstDetails hide #show

#----------------------Tipi di Installazione
InstType "Completa"
# InstType "Manuale"
InstType "Minima"
InstType /NOCUSTOM
#InstType /CUSTOMSTRING=Personalizzata   #cambia il nome dell'installazione "custom"

#-------------------PAGINE

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Light and Dark\Licenza.rtf"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
  !insertmacro MUI_LANGUAGE "Italian"

#------------------ROBA DA INSTALLARE

Section "Light and Dark 3" Game
  SectionIn 1 RO 2 RO

  SetOutPath $INSTDIR   #directory di installazione  
  File /r Gioco\   #il contenuto della cartella "Gioco" viene salvato nella directory di installazione 
  
  WriteRegStr HKCU "Software\Light and Dark 3" "" $INSTDIR    #salva la directory di installazione
  WriteUninstaller "$INSTDIR\Disinstalla L&D3.exe"     #crea l'unistaller
 
  ###########SetOutPath $WINDIR\Fonts
  ###########File "Fonts\Bangle.ttf"   #installa i fonts
  StrCpy $FONT_DIR $FONTS
  
  !insertmacro InstallTTF 'Bangle.ttf'
  
  SendMessage ${HWND_BROADCAST} ${WM_FONTCHANGE} 0 0 /TIMEOUT=5000

  #SetOutPath $WINDIR\system32
  #File "Files\RGSS103J.dll"   #dll per Vista o precedenti
  
  MessageBox MB_YESNO|MB_ICONQUESTION "Vuoi creare un collegamento al gioco sul desktop?" IDYES true IDNO false
	
  true:
  CreateShortCut "$DESKTOP\Light and Dark 3.lnk" "$INSTDIR\${NOMEXE}"
  false:  
  SetOutPath $INSTDIR   #della serie: cose a caso! 
  
SectionEnd

# Section /o "(just for nerds)" Nerd
#  SectionIn 2 RO
# 
#   SetOutPath $INSTDIR   #directory di installazione  
#   File /r Gioco\   #il contenuto della cartella "Gioco" viene salvato nella directory di installazione    
#   File Files\   #dll e txt che spiega cosa fare
#   
#   MessageBox MB_OK "Leggi il file $\"installazione.txt$\" per sapere cosa devi fare."
#   
# SectionEnd

Section "File extra" Extra
 SectionIn 1

  SetOutPath $INSTDIR\Extra   #directory di installazione
  
  File /r Extra\   #il contenuto della cartella "Extra" viene salvato nella directory di installazione 
  
SectionEnd

#--------------------------DESCRIZIONI DELLE SECTIONS

  LangString DESC_Game ${LANG_ITALIAN} "Installa il gioco."
  LangString DESC_Extra ${LANG_ITALIAN} "Comprende i file extra di Light and Dark 3, un archivio .zip la cui password si scoprirà \
										finendo il gioco, e il gioco di carte $\"Lo Re$\"."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${Game} $(DESC_Game)
	!insertmacro MUI_DESCRIPTION_TEXT ${Extra} $(DESC_Extra)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

#------------------------UNISTALLER
Section "Uninstall"

  Delete "$INSTDIR\Disinstalla L&D3.exe"   #prima operazione: cancella il programma di disinstallazione
  
  Delete "$WINDIR\system32\RGSS103J.dll"   #cancella il dll

  RMDir /r "$INSTDIR"   #cancella tutta la cartella del gioco

  DeleteRegKey /ifempty HKCU "Software\Light and Dark 3"   #cancella la chiave nel registro del sistema

SectionEnd

#-------------------------------FUNCTIONS
Function .onInstFailed
    MessageBox MB_OK "Ritenta e sarai più fortunato."
	MessageBox MB_OK "A parte gli scherzi, per favore segnalami l'errore: rpt@altervista.org"
FunctionEnd

Function un.onInit
    MessageBox MB_OK "Disinstallando Light and Dark, ogni file all'interno della cartella del gioco sarà cancellato."
FunctionEnd
