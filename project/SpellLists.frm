VERSION 5.00
Begin VB.Form SpellLists 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Spell Lists"
   ClientHeight    =   7680
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   8505
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   ScaleHeight     =   7680
   ScaleWidth      =   8505
   Begin VB.ListBox List1 
      Height          =   7275
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   8055
   End
End
Attribute VB_Name = "SpellLists"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub Form_Load()
    Dim Index As Long
    Dim SubIndex As Long
    
    For Index = 0 To 2000
        SubIndex = 0
        
        List1.AddItem Index & " - " & RomDump(&H1EE300 + Index)
        
        Index = Index + 1
        
        Do While SpellCode(SubIndex) <> RomDump(&H1EE300 + Index) _
        And SubIndex < UBound(SpellCode())
            SubIndex = SubIndex + 1
        Loop
        
        If SubIndex <= UBound(SpellName()) Then
            List1.AddItem Index & " - " & SpellName(SubIndex)
        Else
            List1.AddItem Index & " - " & "  "
        End If
    Next Index
End Sub
