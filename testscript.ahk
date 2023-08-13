; Requires Gdip_All.ahk from AHKv2-Gdip(https://github.com/buliasz/AHKv2-Gdip/tree/master) @buliasz
#Include Gdip_All.ahk
#Include Gdip_ImageSearch.ahk

getFoundPosition(_hwndId, _fileDir, _variation := 0, _sX := 0, _sY := 0, _eX := 0, _eY := 0) {
    pToken := Gdip_Startup()
    pHaystack := Gdip_BitmapFromScreen("hwnd:" . _hwndId)
    pNeedle := Gdip_CreateBitmapFromFile(_fileDir)

    ; save the current screen to file
    ; Gdip_SaveBitmapToFile(pHaystack, "captured.png", 100)

    result := Gdip_ImageSearch(pHaystack, pNeedle, &outputVar, _sX, _sY, _eX, _eY, _variation)

    Gdip_DisposeImage(pHaystack)
    Gdip_DisposeImage(pNeedle)
    Gdip_Shutdown(pToken)

    if (result > 0) {
        posArr := StrSplit(outputVar, ",")
        return {
            x: posArr[1],
            y: posArr[2]
        }
    }
    return result
}

convertToFullDirectory(fileNameWithExtension) {
    return A_ScriptDir . "\img\" . fileNameWithExtension
}

; How To Test
; 0. run this script
; 1. open /img/lena.png with mspaint
; 2. press F5 to check the result and compare the position with WindowSpy.ahk showing
;    press F6 to exit this script
F5:: {
    activeHWND := WinGetID("A") ;
    dir := convertToFullDirectory("target.png")

    pos := getFoundPosition(activeHWND, dir)
    MsgBox(IsObject(pos) ? pos.x "," pos.y : "NotFound (errcode:" pos ")")
}
F6:: {
    ExitApp
}