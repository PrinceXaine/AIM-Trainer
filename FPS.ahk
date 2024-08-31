#NoEnv
#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetWinDelay, -1
SetControlDelay, -1
SetKeyDelay, -1
SetMouseDelay, -1
SetBatchLines, -1

msgbox, This is a simple AIM Trainer game, or a program that can be used to test your mouse.`n`nStats:`nRemaining Time: Each round lasts 60 seconds. Click as many targets as possible.`nHits: How many targets were hit. Higher is better.`nMiss: how many times the user did not click on a target. Lower is better.`nDeaths: How many times the targets were able to despawn. This simulates you getting hit in an FPS title.`nAccuracy: Your accuracy hitting the targets.`nDifficulty Level: In milliseconds: 500ms (Very Hard), 1000ms (Hard), 1500ms (Normal), 2000ms (Easy), 2500ms (Very Easy).`nScore: Will be given after the round is complete. Contains all of your stats. Your score is impacted by window size, difficulty, accuracy, hits and deaths.

OnMessage(0x200, "WM_MOUSEMOVE")

;====//STATS VALUE//====;
Accuracy := 100.000000
Hits := 0
Miss := 0
Deaths := 0
TimeLeft := 60

;====//Window MIN Values//====;
MinWidth := 600
MinHeight := 600
;▣
;====//GUI Creation//====;
Gui, New, +HwndMyGuiHwnd
Gui, Color, 0
gui, font, s14 cFFFFFF
Gui, Add, Groupbox, x0 y0 w310 h185, Stats
Gui, Add, Text, x5 y30 vRemainingTime w200, Remaining: 60 seconds
Gui, Add, Text, x5 y60 vHits w100, Hits: 0
Gui, Add, Text, x5 y90 vMiss w100, Miss: 0
Gui, Add, Text, x5 y120 vDeaths w100, Deaths: 0
Gui, Add, Text, x5 y150 vAccuracy w300, Accuracy: 100.000000`%
gui, font, s10 cFFFFFF
Gui, Add, Text, vDiffText, Very Hard  --  Hard  --  Difficulty  --  Easy  --  Very Easy
gui, font, s14 c0
Gui, Add, Slider, w310 gDiffToolTip vDifficulty range1-5
Guicontrol,, Difficulty, 3
gui, font, s35 cFFFFFF
Gui, Add, button, h40 w40 x240 y75 vButton1 gButtonMove, 🞖
Gui, show, Maximize
Gui, +Resize
SetTimer, CheckGUISize, 100
return

WM_MOUSEMOVE(wParam, lParam, msg, hwnd)
{
    hCursor := DllCall("LoadCursor", "UInt", 0, "Int", 32515, "UPtr", hCursor)
    DllCall("SetCursor", "UPtr", hCursor)
}

ButtonMove:
    if (start != 1)
    {
        gui, submit, nohide
        Difficulty := Difficulty * 500
        Guicontrol, hide, Difficulty
        Guicontrol, hide, DiffText
        SetTimer, UpdateTime, 1000
        SetTimer, AccuracyCheck, 100

        SetTimer, ButtonAutoMove, %Difficulty%
        Miss := 0
        start = 1
            TryAgain2:
                Gui +LastFound
                WinGetPos, X, Y, Width, Height, ahk_id %MyGuiHwnd%
                random, XPos, 0, % Width - 80
                Random, YPos, 0, % Height - 80
                if (YPos < 185 && XPos < 310)
                        {
                            gosub TryAgain2
                        }
                Guicontrol, move, Button1, x%XPos% y%YPos%
        Return
    }
    SetTimer, ButtonAutoMove, off
    Hits++
    Guicontrol,, Hits, Hits: %Hits%
    TryAgain:
    Gui +LastFound
    WinGetPos, X, Y, Width, Height, ahk_id %MyGuiHwnd%
    random, XPos, 0, % Width - 80
    Random, YPos, 0, % Height - 80
    if (YPos < 185 && XPos < 310)
            {
                gosub TryAgain
            }
    Guicontrol, move, Button1, x%XPos% y%YPos%
    SetTimer, ButtonAutoMove, %Difficulty%
Return

ButtonAutoMove:
            Deaths++
            TryAgain3:
            SetTimer, ButtonAutoMove, off
            WinGetPos, X, Y, Width, Height, ahk_id %MyGuiHwnd%
            random, XPos, 0, % Width - 80
            Random, YPos, 0, % Height - 80
            if (YPos < 216 && XPos < 318)
            {
                gosub TryAgain3
            }
            if (YPos < 40 || XPos < 40)
            {
                gosub TryAgain3
            }
            ControlSetText, Deaths, Deaths: %Deaths%, FPS.ahk
            ControlMove, Button2, %XPos%, %YPos%,,, FPS.ahk
            SetTimer, ButtonAutoMove, %Difficulty%
            return

AccuracyCheck:
if (Miss > 0)
        {
            Accuracy := round((Hits / (Hits + Miss)) * 100, 6)
            ControlSetText, Accuracy, Accuracy: %Accuracy%`%, FPS.ahk
        }
        else
        {
            ControlSetText , Miss, Miss: %Miss%, FPS.ahk
        }
Return

CheckGUISize:
    Gui +LastFound
    WinGetPos, X, Y, Width, Height, ahk_id %MyGuiHwnd%
    if (Width < MinWidth or Height < MinHeight)
        {
            Width := MinWidth
            Height := MinHeight
            WinMove, ahk_id %MyGuiHwnd%, , , , %Width%, %Height%
        }
        if (Hits > 150 && Accuracy = 100)
                {
                    SetTimer, UpdateTime, off
                    SetTimer, AccuracyCheck, off
                    SetTimer, ButtonAutoMove, off
                    SetTimer, CloseApp, 2000
                    Msgbox, 4112, Application Error, The application has experienced an issue and needs to shut down.
                    Exitapp 
                }
Return

UpdateTime:
If (TimeLeft <= 0)
        {

            SetTimer, UpdateTime, off
            SetTimer, AccuracyCheck, off
            SetTimer, ButtonAutoMove, off
            ControlMove, Button2, 248, 106,,, FPS.ahk
            Score := round((Height + Width) / 10 * (Hits * Accuracy) / Difficulty, 0)

            if (Deaths > 0)
                {
                    DeathModifier := Deaths * 3
                    DeathModifier := DeathModifier / 100
                    ScoreModifier := round(Score * DeathModifier, 0)
                    Score := round(Score - ScoreModifier, 0)
                }
            If (Score < 0)
                {
                    Score := 0
                }

            TPS := Hits/60

            DiffArray := ["Very Hard", "Hard", "Normal", "Easy", "Very Easy"]
            DiffMod := round(Difficulty/500, 0)
            Difficulty := DiffArray[DiffMod]
            Msgbox, 4164, Time Up!, Results:`nScore: %Score%`nTargets/s: %TPS%`nDifficulty: %Difficulty%`n`nHits: %Hits%`nMisses: %Miss%`nDeaths: %Deaths%`nAccuracy: %Accuracy%`n`n`nPlay Again?
            ifmsgbox yes
            {
            TimeLeft := 60
            Hits := 0
            Miss := 0
            Deaths := 0
            Accuracy := 100.000000
            ControlSetText, Static1, Remaining: %TimeLeft% seconds, FPS.ahk
            ControlSetText, Static2, Hits: %Hits%, FPS.ahk
            ControlSetText, Static3, Miss: %Miss%, FPS.ahk
            ControlSetText, Static4, Deaths: %Deaths%, FPS.ahk
            ControlSetText, Static5, Accuracy: %Accuracy%`%, FPS.ahk
            Control, Show,, Static6, FPS.ahk
            Control, Show,, msctls_trackbar321, FPS.ahk
            gui submit
            gui show
            Start = 0
            Return
            }
            else
            {
            exitapp
            }
            
        }
    TimeLeft--
    ControlSetText, Static1, Remaining: %TimeLeft% seconds, FPS.ahk
Return

~LButton::
if (start = 1)
{
    MouseGetPos, , , , ButtonPressed
    if (ButtonPressed = "")
        {
        Miss++
        ControlSetText , Miss, Miss: %Miss%, FPS.ahk
        }
}
return

DiffToolTip:
Gui, submit, nohide
Difficulty := Difficulty * 500
Tooltip, Buttons will move automatically in %Difficulty% milliseconds.`n`nThis tooltip is an example of the speed of button movement.
SetTimer, ToolTipTimer, %Difficulty%
return

ToolTipTimer:
Tooltip
Return

Guiclose:
Exitapp

CloseApp:
WinClose, FPS.ahk