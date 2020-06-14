VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.MDIForm Main 
   BackColor       =   &H8000000C&
   Caption         =   "SF2 Editor"
   ClientHeight    =   6450
   ClientLeft      =   60
   ClientTop       =   750
   ClientWidth     =   8385
   Icon            =   "Main.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   2  'CenterScreen
   WindowState     =   2  'Maximized
   Begin MSComDlg.CommonDialog cdlg 
      Left            =   7800
      Top             =   120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuOpen 
         Caption         =   "&Open..."
         Shortcut        =   ^O
      End
      Begin VB.Menu Sep0 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSave 
         Caption         =   "&Save"
         Enabled         =   0   'False
         Shortcut        =   ^S
      End
      Begin VB.Menu mnuSaveAs 
         Caption         =   "Save &As..."
         Enabled         =   0   'False
      End
      Begin VB.Menu Sep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "&Edit"
      Enabled         =   0   'False
      Begin VB.Menu mnuCharacterData 
         Caption         =   "&Character Start Data"
      End
      Begin VB.Menu mnuCharacterStats 
         Caption         =   "Character S&tats"
      End
      Begin VB.Menu mnuExpandStat 
         Caption         =   "Expand Stat Table"
      End
      Begin VB.Menu Sep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuClass 
         Caption         =   "&Class"
      End
      Begin VB.Menu mnuLevels 
         Caption         =   "&Levels"
      End
      Begin VB.Menu mnuPromotions 
         Caption         =   "&Promotions"
      End
      Begin VB.Menu Sep3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuMonsters 
         Caption         =   "&Monsters"
      End
      Begin VB.Menu Sep5 
         Caption         =   "-"
      End
      Begin VB.Menu mnuItems 
         Caption         =   "&Items"
      End
      Begin VB.Menu mnuShops 
         Caption         =   "&Shops"
      End
      Begin VB.Menu Sep4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSpells 
         Caption         =   "Sp&ells"
      End
      Begin VB.Menu mnuSpecial 
         Caption         =   "M&isc"
      End
   End
   Begin VB.Menu mnuEditNames 
      Caption         =   "Edit Names"
      Enabled         =   0   'False
      Begin VB.Menu mnuItemClass 
         Caption         =   "Items && Class"
      End
      Begin VB.Menu mnuSpellHeroMonster 
         Caption         =   "Spells, Heroes && Monsters"
      End
   End
   Begin VB.Menu mnuMisc 
      Caption         =   "Misc"
      Enabled         =   0   'False
      Begin VB.Menu mnuStatCalculator 
         Caption         =   "Stat Calculator"
      End
      Begin VB.Menu mnuDamageCalculator 
         Caption         =   "Damage Calculator"
      End
      Begin VB.Menu mnuFixCharPointTable 
         Caption         =   "Fix Pointers"
         Visible         =   0   'False
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Begin VB.Menu mnuUsers 
         Caption         =   "Users"
      End
      Begin VB.Menu Sep6 
         Caption         =   "-"
      End
      Begin VB.Menu mnuAbout 
         Caption         =   "About"
      End
   End
End
Attribute VB_Name = "Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub MDIForm_Load()
    Load_Codes
    Load_Shops
    Load_Path
    
    Randomize
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
    If RomPath <> "" Then
        If MsgBox("You've loaded a file, would you like to save any changes you may have made to it?", vbYesNo) = vbYes Then
            Call mnuSave_Click
        End If
    End If
End Sub

Private Sub mnuAbout_Click()
    Dim Form As New Reader
    Form.Caption = "About"
    Form.Show
End Sub

Private Sub mnuCharacterData_Click()
    Dim Form As New CharacterData
    Form.Show
End Sub

Private Sub mnuCharacterStats_Click()
    If CharacterStats.Tag = 1 Then
        CharacterStats.Tag = 0
    Else
        Dim Form As New CharacterStats
        Form.Show
    End If
End Sub

Private Sub mnuDamageCalculator_Click()
    Dim Form As New DamageCalculator
    Form.Show
End Sub

Private Sub mnuClass_Click()
    Dim Form As New Class
    Form.Show
End Sub

Private Sub mnuDevs_Click()
    Dim Form As New Reader
    Form.Caption = "Developers"
    Form.Show
End Sub

Private Sub mnuSaveAs_Click()
    SaveAs
End Sub

Private Sub mnuStatCalculator_Click()
    Dim Form As New StatCalculator
    Form.Show
End Sub

Private Sub mnuExit_Click()
    End
End Sub

Private Sub mnuExpandStat_Click()
    InsertStats.Show
End Sub

Private Sub mnuFixCharPointTable_Click()
    Dim Index As Long
    Dim Counter As Integer
    Dim MetaCounter As Integer
    
    Counter = 0
    MetaCounter = 1
    
    Index = &H1EE2F0
    
    Do While Counter < 29
        Do While MetaCounter <> 3 And MetaCounter <> 6 _
        And MetaCounter <> 9 And MetaCounter <> 12 _
        And MetaCounter <> 15 And MetaCounter <> 17 _
        And MetaCounter <> 19 And MetaCounter <> 21 _
        And MetaCounter <> 23 And MetaCounter <> 25 _
        And MetaCounter <> 27 And MetaCounter <> 28 _
        And MetaCounter <> 31 And MetaCounter <> 34 _
        And MetaCounter <> 37 And MetaCounter <> 40 _
        And MetaCounter <> 43 And MetaCounter <> 46 And MetaCounter < 49
            Do While RomDump(Index) < 254
                Index = Index + 1
            Loop
            
            MetaCounter = MetaCounter + 1
            
            Index = Index + 1
        Loop
    
        Counter = Counter + 1
        
        RomDump(&H1EE271 + 4 * Counter) = CByte(Fix(Index / 65536#))
        RomDump(&H1EE271 + 4 * Counter + 1) = Fix((Index - Fix(Index / 65536#) * 65536#) / 256#)
        RomDump(&H1EE271 + 4 * Counter + 2) = CByte(Index - Fix(Fix(Index / 256#) * 256#))
        
        Do While RomDump(Index) < 254
            Index = Index + 1
        Loop
        
        MetaCounter = MetaCounter + 1
        Index = Index + 1
    Loop
    
    ' Update joining guy data pointers
    Index = Index + 1
    
    RomDump(&H1EE009) = CByte(Fix(Index / 65536#))
    RomDump(&H1EE009 + 1) = Fix((Index - Fix(Index / 65536#) * 65536#) / 256#)
    RomDump(&H1EE009 + 2) = CByte(Index - Fix(Fix(Index / 256#) * 256#))
    
    'Update Class Pointer
    
    Index = Index + 192
    
    RomDump(&H1EE00D) = CByte(Fix(Index / 65536#))
    RomDump(&H1EE00D + 1) = Fix((Index - Fix(Index / 65536#) * 65536#) / 256#)
    RomDump(&H1EE00D + 2) = CByte(Index - Fix(Fix(Index / 256#) * 256#))
    
    'Update 01010101 Pointer
    
    Index = Index + 155
    
    RomDump(&H1EE015) = CByte(Fix(Index / 65536#))
    RomDump(&H1EE015 + 1) = Fix((Index - Fix(Index / 65536#) * 65536#) / 256#)
    RomDump(&H1EE015 + 2) = CByte(Index - Fix(Fix(Index / 256#) * 256#))
    
    MsgBox "Pointer table adjusted.", vbOKOnly
End Sub

Private Sub mnuItemClass_Click()
    Dim Form As New NameItemClass
    Form.Show
End Sub

Private Sub mnuItems_Click()
    Dim Form As New Item
    Form.Show
End Sub

Private Sub mnuLevels_Click()
    Dim Form As New Levels
    Form.Show
End Sub

Private Sub mnuMonsters_Click()
    Dim Form As New Monsters
    Form.Show
End Sub

Private Sub mnuOpen_Click()
    OpenDialog
End Sub

Private Sub mnuPromotions_Click()
    Dim Form As New Promotions
    Form.Show
End Sub

Private Sub mnuSave_Click()
    Dim Freedfile As Long
    Dim Index As Long
    Dim SubIndex As Long
    Dim RomPosition As Long
    Dim NamesPointerCount As Long
    
    If RomPath = "" Then
        Exit Sub
    End If
    
    Freedfile = FreeFile()
    
    'RomDump(&H17321) = 60
    
    'Save them spell names
    
    NamesPointerCount = pSpellNames ' 63940
 
    If SpellNamesInBounds = True Then
        RomPosition = pSpellNames '63940
        
        For Index = 0 To UBound(mSpellName())
            RomDump(RomPosition) = CByte(mSpellNameLength(Index))
            RomPosition = RomPosition + 1
 
            For SubIndex = 1 To mSpellNameLength(Index)
                RomDump(RomPosition) = AscB(Mid(mSpellName(Index), SubIndex, 1))
                RomPosition = RomPosition + 1
            Next SubIndex
            
            ' Calculate the offset for the new pointers
            NamesPointerCount = NamesPointerCount + mSpellNameLength(Index) + 1
            
            If Index = 43 Then
                RomDump(33481) = CByte(Fix(NamesPointerCount / 65536#))
                RomDump(33482) = Fix((NamesPointerCount - Fix(NamesPointerCount / 65536#) * 65536#) / 256#)
                RomDump(33483) = CByte(NamesPointerCount - Fix(Fix(NamesPointerCount / 256#) * 256#))
            End If
            
            If Index = 73 Then
                RomDump(33485) = CByte(Fix(NamesPointerCount / 65536#))
                RomDump(33486) = Fix((NamesPointerCount - Fix(NamesPointerCount / 65536#) * 65536#) / 256#)
                RomDump(33487) = CByte(NamesPointerCount - Fix(Fix(NamesPointerCount / 256#) * 256#))
            End If
        Next Index
    End If
    
    'Save the ITEM names
    NamesPointerCount = pItemNames ' 96622
    
    If ItemNamesInBounds = True Then
        RomPosition = pItemNames ' 96622
        
        For Index = 0 To UBound(mItemName())
            RomDump(RomPosition) = CByte(mItemNameLength(Index))
            RomPosition = RomPosition + 1
            
            For SubIndex = 1 To mItemNameLength(Index)
                RomDump(RomPosition) = AscB(Mid(mItemName(Index), SubIndex, 1))
                RomPosition = RomPosition + 1
            Next SubIndex
        
            ' Calculate the offset for the new pointers
            NamesPointerCount = NamesPointerCount + mItemNameLength(Index) + 1
            
            If Index = 127 Then
                RomDump(RomPosition) = 255
                RomPosition = RomPosition + 1
                
                NamesPointerCount = NamesPointerCount + 1
                
                RomDump(65673) = CByte(Fix(NamesPointerCount / 65536#))
                RomDump(65674) = Fix((NamesPointerCount - Fix(NamesPointerCount / 65536#) * 65536#) / 256#)
                RomDump(65675) = CByte(NamesPointerCount - Fix(Fix(NamesPointerCount / 256#) * 256#))
            End If
        Next Index
    End If
    
    Open RomPath For Binary As #Freedfile
    Put #1, , RomDump
    
    Close #Freedfile
    MsgBox "Saved~!", vbOKOnly
End Sub


Private Sub mnuShops_Click()
    Dim Form As New Shops
    Form.Show
End Sub

Private Sub mnuSpellLists_Click()
    Dim Form As New SpellLists
    Form.Show
End Sub

Private Sub mnuSpecial_Click()
    Dim Form As New Special
    Form.Show
End Sub

Private Sub mnuSpellHeroMonster_Click()
    Dim Form As New NameSpellHeroMonster
    Form.Show
End Sub

Private Sub mnuSpells_Click()
    Dim Form As New Spells
    Form.Show
End Sub

Private Sub mnuUsers_Click()
    Dim Form As New Reader
    Form.Caption = "Users"
    Form.Show
End Sub

Private Sub OpenFile(Path As String)
    Dim Freedfile As Long
    
    On Error GoTo READ_ERROR
    
    Freedfile = FreeFile()
    
    Open Path For Binary As #Freedfile
        ReDim RomDump(LOF(Freedfile) - 1)
        Get #Freedfile, , RomDump
    Close #Freedfile
    
    RomPath = Path
    
    Dim Status As Boolean: Status = True
    
    ' Determines binary format
    If RomDump(&H1) = &H3 _
    And RomDump(&H8) = &HAA _
    And RomDump(&H9) = &HBB _
    And RomDump(&HA) = &H6 Then
        MsgBox "The selected ROM file is in SMD format and must be converted.", vbInformation
        RomDump = DeInterleave(RomDump)
        Status = SaveAs
    End If
    
    If Not Status Then
        GoTo CANCEL_ERROR
    End If
    
    Call InitializeAddresses
    
    ' Do stuff we couldn't before load
    CalculateStoreSpots
    
    mnuSave.Enabled = True
    mnuSaveAs.Enabled = True
    mnuEdit.Enabled = True
    mnuMisc.Enabled = True
    mnuEditNames.Enabled = True
    
    Dim Index As Long
    Dim Count As Long
    Dim SubIndex As Long
    
    Index = pItemNames ' &H1796E
    Count = 0
    
    Do While Count <= UBound(mItemName())
        mItemNameLength(Count) = RomDump(Index)
        Index = Index + 1
        mItemName(Count) = ""
        
        For SubIndex = 0 To mItemNameLength(Count) - 1
            mItemName(Count) = mItemName(Count) & Chr(RomDump(Index + SubIndex))
        Next SubIndex
        
        Index = Index + mItemNameLength(Count)
        
        If Count = 127 Then
            Index = Index + 1
        End If
        
        Count = Count + 1
    Loop
    
    ' The next name set
    Index = pSpellNames '63940
    Count = 0
    
    Do While Count <= UBound(mSpellName())
        mSpellNameLength(Count) = RomDump(Index)
        Index = Index + 1
        mSpellName(Count) = ""
        
        For SubIndex = 0 To mSpellNameLength(Count) - 1
            mSpellName(Count) = mSpellName(Count) & Chr(RomDump(Index + SubIndex))
        Next SubIndex
        
        Index = Index + mSpellNameLength(Count)
        Count = Count + 1
    Loop
    
    Call LoadRomNames
    
    Exit Sub
    
READ_ERROR:
    Close Freedfile
    MsgBox "The file you selected is incompatible with this program.", vbOKOnly
    Exit Sub
    
CANCEL_ERROR:
    MsgBox "Operation canceled.", vbOKOnly
    Exit Sub
End Sub

Private Sub OpenDialog()
    On Error GoTo CANCEL_ERROR
    
    With cdlg
        .Filter = "Shining Force II ROM files (*.bin;*.smd)|*.bin;*.smd|All files (*.*)|*.*"
        .DefaultExt = "bin"
        .CancelError = True
        .Flags = cdlOFNHideReadOnly
        .ShowOpen
    End With
    
    OpenFile cdlg.FileName
    
    Exit Sub
    
CANCEL_ERROR:
    Exit Sub
End Sub

Private Function SaveAs()
    On Error GoTo CANCEL_ERROR
    
    Dim FileName As String
    FileName = Right(RomPath, Len(RomPath) - InStrRev(RomPath, "\"))
    FileName = Left(FileName, InStrRev(FileName, ".") - 1)
    
    With cdlg
        .Filter = "Shining Force II ROM files (*.bin)|*.bin|All files (*.*)|*.*"
        .DefaultExt = "bin"
        .FileName = FileName
        .CancelError = True
        .Flags = cdlOFNOverwritePrompt
        .ShowSave
    End With
    
    RomPath = cdlg.FileName
    mnuSave_Click
    
    SaveAs = True
    Exit Function
    
CANCEL_ERROR:
    SaveAs = False
    Exit Function
End Function
