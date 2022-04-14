#SingleInstance force
ListLines 0
KeyHistory 0
SendMode "Input" ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory.

filePath:="dump2.ahk"

; ^:\*\?:(.*)::(?:[^:]|`:)*?$
; sure("$1","$2")

text_:=FileRead(filePath)
hotstringText:=RegExReplace(text_, "m)^:\*\?:(.*)::((?:[^:]|`:)*?)$", "$1")
replacementText:=RegExReplace(text_, "m)^:\*\?:(.*)::((?:[^:]|`:)*?)$", "$2")
arr_:=StrSplit(text_, "`n")
hotstringArr:=StrSplit(hotstringText, "`n")
replacementArr:=StrSplit(replacementText, "`n")

manualText:=""

okYouMay:=false

finalStr_auto:=""
finalStr_manual:=""

linesToRemove:=[]

mapOfExistence:=Map()
; mapOfExistence.Count
; 52183 to 51147
mapOfExistence.Capacity:=65536

removeKline(k_) {
    line_:=hotstringArr[k_]
    len2:=len1:=StrLen(line_)
    i_:=1
    while (i_ < len1) {
        j_:=1

        while (j_ < len2) {
            slice:=SubStr(line_, i_, j_)
            if (mapOfExistence.Has(slice)) {
                if (mapOfExistence[slice].Has(k_)) {
                    mapOfExistence[slice].Delete(k_)
                    if (mapOfExistence[slice].Count == 0) {
                        mapOfExistence.Delete(slice)
                    }
                }

            }
            j_++
        }
        len2--
        i_++
    }
}

for k_, line_ in hotstringArr {

    len2:=len1:=StrLen(line_)
    i_:=1
    while (i_ < len1) {
        j_:=1

        while (j_ < len2) {
            slice:=SubStr(line_, i_, j_)
            if (mapOfExistence.Has(slice)) {
                ; if it's not there, it cant push the slice
                ; so now it's pushing the line, so when line changes, everything is messed up
                ; we need to push something that when the line changes, everything is not messed up
                ; we can just remove all lines at the end

                ; we add the string to it, then the string can be removed, as if it was never there

                ; we want to remove it from the array, and the map, somehow
                ; lines to remove, then sort it
                mapOfExistence[slice][k_]:=true
            } else {
                mapOfExistence[slice]:=Map(k_, true)
            }
            j_++
        }
        len2--
        i_++
    }
}
outer:
for k_, line_ in hotstringArr {

    if (mapOfExistence.Has(line_)) {
        whyIsItTakingSoMuchTime:=mapOfExistence[line_]

        str_:=""
        subHotstring:=hotstringArr[k_]
        subReplacement:=replacementArr[k_]

        loop 1 {
            for k2 in whyIsItTakingSoMuchTime {
                thisHotstring:=hotstringArr[k2]
                thisReplacement:=replacementArr[k2]
                afterReplace:=StrReplace(thisHotstring, subHotstring, subReplacement, true)
                if (afterReplace=="appreciation") {
                    letno:=0
                }
                if (afterReplace !== thisReplacement) {
                    ; remove the shorter one

                    str_:=""
                    for k2 in whyIsItTakingSoMuchTime {
                        str_.= arr_[k2] "`n"
                    }

                    for k2 in whyIsItTakingSoMuchTime {
                        thisHotstring:=hotstringArr[k2]
                        thisReplacement:=replacementArr[k2]
                        afterReplace:=StrReplace(thisHotstring, subHotstring, subReplacement, true)
                        if (afterReplace !== thisReplacement) {
                            str_.= thisHotstring "::" afterReplace "`n"
                        }

                    }

                    manualText.= subHotstring "::" subReplacement "`n"

                    str_.="`n" arr_[k_] "`n`n`n`n"
                    finalStr_manual.=str_

                    removeKline(k_)
                    linesToRemove.Push(k_)
                    continue outer
                }

            }
            ; remove the longer ones

            str_:=""
            for k2 in whyIsItTakingSoMuchTime {
                str_.= arr_[k2] "`n"
            }
            str_.="`n" arr_[k_] "`n`n`n`n"
            finalStr_auto.=str_

            arrOfKeys:=[]
            for k2 in whyIsItTakingSoMuchTime {
                arrOfKeys.Push(k2)
            }
            for k2 in arrOfKeys {
                linesToRemove.Push(k2)
                removeKline(k2)
            }

            continue outer
        }


    }

}

linesToRemove:=sortArray(linesToRemove) ;yup, I sorted reverse
for lineNum in linesToRemove {
    arr_.RemoveAt(lineNum)
    hotstringArr.RemoveAt(lineNum)
    replacementArr.RemoveAt(lineNum)
}

deleteIfExist("3-autoremove")
deleteIfExist("3-manualRemove")
FileAppend finalStr_auto, "3-autoremove"
FileAppend finalStr_manual, "3-manualRemove"

deleteIfExist("3-intersects.ahk")

VarSetStrCapacity(&finalStr_intersects, 1000000)
for v_ in arr_ {
    finalStr_intersects.=v_ "`n"
}
finalStr_intersects.=SubStr(manualText,1,-1)
FileAppend finalStr_intersects, "3-intersects.ahk"

deleteIfExist("3-sure.ah2")
VarSetStrCapacity(&finalStr_sure, 1000000)

for k_, v_ in hotstringArr {
    escaped_hotstring:=StrReplace(v_, "`"", "```"", true)
    escaped_replacement:=StrReplace(replacementArr[k_], "`"", "```"", true)
    finalStr_sure.="sure(`"" escaped_hotstring  "`",`"" escaped_replacement "`")`n"
}

FileAppend finalStr_sure, "3-sure.ah2"

ToolTip "Done"
SoundPlay "*-1"
Sleep 500

Exitapp

f3::Exitapp

deleteIfExist(fileName) {
    if (FileExist(fileName)) {
        FileDelete fileName
    }
}

sortArray(a_) {
    if (!a_.Length) {
        return []
    }

    str_:=a_[1]
    len:=a_.Length + 1
    i_:=2
    while (i_ < len) {
        str_.="|" a_[i_]
        i_++
    }

    SortedString := Sort(str_, "N D| R")

    retArr:=[]
    Loop Parse SortedString, "|" {
        retArr.Push(A_LoopField)
    }
    return retArr
}