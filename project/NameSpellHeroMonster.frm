VERSION 5.00
Begin VB.Form NameSpellHeroMonster 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Naming Spells, Heroes, Monsters"
   ClientHeight    =   4455
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4590
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   ScaleHeight     =   4455
   ScaleWidth      =   4590
   Begin VB.Frame Frame1 
      Height          =   3375
      Left            =   120
      TabIndex        =   2
      Top             =   960
      Width           =   4335
      Begin VB.TextBox txtNameData 
         Enabled         =   0   'False
         Height          =   2565
         Left            =   2640
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   4
         Top             =   600
         Width           =   1575
      End
      Begin VB.TextBox txtName 
         Enabled         =   0   'False
         Height          =   285
         Left            =   360
         TabIndex        =   3
         Top             =   600
         Width           =   1935
      End
      Begin VB.Label Label7 
         Caption         =   "Names will not be saved if Size exceeds the max."
         Height          =   375
         Left            =   240
         TabIndex        =   11
         Top             =   2640
         Width           =   2055
      End
      Begin VB.Label lblMax 
         Alignment       =   1  'Right Justify
         Caption         =   "0"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   1320
         TabIndex        =   10
         Top             =   1920
         Width           =   975
      End
      Begin VB.Label lblSize 
         Alignment       =   1  'Right Justify
         Caption         =   "0"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   1200
         TabIndex        =   9
         Top             =   1440
         Width           =   1095
      End
      Begin VB.Label Label3 
         Caption         =   "Max Size:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   240
         TabIndex        =   8
         Top             =   1920
         Width           =   1095
      End
      Begin VB.Label Label2 
         Caption         =   "Size:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   240
         TabIndex        =   7
         Top             =   1440
         Width           =   855
      End
      Begin VB.Label Label5 
         Caption         =   "Numeric Code"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   2520
         TabIndex        =   6
         Top             =   240
         Width           =   1455
      End
      Begin VB.Label Label1 
         Caption         =   "Name"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   240
         Width           =   1455
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Select"
      Height          =   735
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4335
      Begin VB.ComboBox cboName 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         ItemData        =   "NameSpellHeroMonster.frx":0000
         Left            =   360
         List            =   "NameSpellHeroMonster.frx":0002
         Style           =   2  'Dropdown List
         TabIndex        =   1
         Top             =   240
         Width           =   3735
      End
   End
End
Attribute VB_Name = "NameSpellHeroMonster"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Changing As Boolean
Private Loading As Boolean

Private Sub cboName_Click()
    Dim Index As Long
    Dim ValueName As String
    Dim Simplify As Long
    
    Loading = True
    Changing = True
    
    'Me.Caption = cboName.ListIndex
    
    txtName.Enabled = True
    txtNameData.Enabled = True
    
    txtName.Text = mSpellName(cboName.ListIndex)
    
    Simplify = mSpellNameLength(cboName.ListIndex)
    
    For Index = 0 To mSpellNameLength(cboName.ListIndex) - 1
        ValueName = ValueName & AscB(Right(mSpellName(cboName.ListIndex), Simplify - Index)) & vbNewLine
    Next Index
    
    ValueName = Left(ValueName, Len(ValueName) - 2)
    
    txtNameData.Text = ValueName
    
    Changing = False
End Sub

Private Sub Form_Load()
    Dim Index As Long
    
    lblSize.Caption = GetSpellNameSize()
    lblMax.Caption = 65534 - 63940
    
    For Index = 0 To UBound(mSpellName())
        cboName.AddItem mSpellName(Index)
    Next Index
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call LoadRomNames
End Sub

Private Sub txtName_Change()
    Dim Index As Long
    Dim ValueName As String
    Dim Simplify As Long
    
    If Changing = True And Loading = True Then
        Exit Sub
    ElseIf Changing = True Then
        'Call SaveName
        Exit Sub
    End If
    
    Simplify = Len(txtName.Text)
    
    For Index = 0 To Len(txtName.Text) - 1
        ValueName = ValueName & AscB(Right(txtName.Text, Simplify - Index)) & vbNewLine
    Next Index
    
    If Index > 0 Then
        ValueName = Left(ValueName, Len(ValueName) - 2)
    End If
    
    Changing = True
    
    txtNameData.Text = ValueName
    
    Call SaveName
    
    Changing = False
End Sub

Private Sub txtNameData_Change()
    Dim NameArray() As String
    Dim RealName As String
    Dim Index As Integer
    
    If Changing = True Then
        Exit Sub
    End If
    
    On Error GoTo CHANGE_ERROR
    
    NameArray() = Split(txtNameData.Text, vbNewLine)
    
    For Index = 0 To UBound(NameArray())
     RealName = RealName & Chr(NameArray(Index))
    Next Index
    
    Changing = True
      
    txtName.Text = RealName
    
    Call SaveName
    
    Changing = False
    
    Exit Sub
    
CHANGE_ERROR:
    Exit Sub
End Sub


Private Sub SaveName()
    mSpellName(cboName.ListIndex) = txtName.Text
    mSpellNameLength(cboName.ListIndex) = Len(txtName.Text)
    
    lblSize.Caption = GetSpellNameSize()
End Sub
