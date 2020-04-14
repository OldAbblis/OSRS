;==============================================================;
;===========                   Box                  ===========;
;===                   Coordinate Finder v2                 ===;
;==============================================================;
;===  - You must be holding Alt to use the script.          ===;
;===  - Click for x, y coordinates of a single point.       ===;
;===  - Click and drag for the coordinates of a box.        ===;
;===  - Right click for colour selection mode, right click  ===;
;===  - again to select the current colour.                 ===;
;===  - Whatever method you use, the correct result is      ===;
;===  - saved into the clipboard.                           ===;
;===  - F1 to reset the script, F2 to exit.                 ===;
;=======================================================  oa. =;


!LButton::
    Gui, gColour: Destroy
    WinGetPos xN, yN,,, A
    MouseGetPos x1, y1
    ToolTip, % x1 ", " y1,,, 2
    xT := x1, yT := y1
    x1 += xN, y1 += yN
    While GetKeyState("LButton", "P") {
        MouseGetPos x2, y2
        x2 += xN, y2 += yN
        x := (x1 < x2) ? (x1):(x2)
        y := (y1 < y2) ? (y1):(y2)
        w := (x2 - x1), h := (y2 - y1)
        if (Abs(w) <= 3 && Abs(h) <= 5)  {
            ToolTip,,,, 1
            Clipboard := % x - xN ", " y - yN
        } else {
            ToolTip % xT + w ", " yT + h,,, 1
            Clipboard := % x - xN ", " y - yN ", " x - xN + Abs(w) ", " y - yN + Abs(h)
        }
        gBox(x, y, Abs(w), Abs(h))
    }
Return

!RButton::
    Loop {
        CoordMode, Mouse, Screen
        CoordMode, Pixel, Screen
        MouseGetPos, xC, yC
        xGui := xC + 20, yGui := yC
        PixelGetColor, cColour, xC, yC, RGB
        Gui gColour: +LastFound +AlwaysOnTop -Caption +ToolWindow +Border
        Gui gColour: Color, %cColour%
        Gui gColour: Show, x%xGui% y%yGui% w35 h35 NA
        WinSet, Transparent, Off
        WinSet, Region, 0-0 w35 h35 r35-35
        Sleep, 50
        if (Abs(w) <= 3 && Abs(h) <= 5) {
            ToolTip,,,, 2
            Clipboard := % cColour ", "
        } else {
            Clipboard := % x - xN ", " y - yN ", " x - xN + Abs(w) ", " y - yN + Abs(h) ", " cColour ", "
        }
        if GetKeyState("RButton", "P") {
            Break
        }
    }
Return

F1::Reload
F2::ExitApp


; ===  FUNCTIONS  ===
gBox(x, y, w, h)
{
    Gui, gColour: Destroy
    CoordMode, Mouse, Window
    CoordMode, Pixel, Window
    t := 3 ; Thickness of the border in pixels
    w2 := w - t, h2 := h - t 
    Gui gBox: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
    Gui gBox: Color, Red ; Colour of the border 
    Gui gBox: Show, w%w% h%h% x%x% y%y% NA
    WinSet, Transparent, 150
    WinSet, Region, 0-0 %w%-0 %w%-%h% 0-%h% 0-0 %t%-%t% %w2%-%t% %w2%-%h2% %t%-%h2% %t%-%t%
    Return  
}
