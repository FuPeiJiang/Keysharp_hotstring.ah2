#SingleInstance force
ListLines 0
KeyHistory 0
SendMode "Input" ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory.

Persistent ;this is needed or else it just,, stops
#MaxThreadsPerHotkey 4 ;idk why, but maybe it helps

; https://tree.nathanfriend.io/?s=%28%27options%21%28%27fancy%21true%7EfullPath3%7EtrailingSlash3%7ErootDot3%29%7E6%28%276%27%2F5+b0e0+a0*t02i09n08g%7BSEND+thumpingA8.8-9*.9-8.2-9.*-2.7*.-7%27%29%7Eversion%21%271%27%2927Default4%2F%7D5.b4bA058*+3%21false4%7BJump+5%5Cn6source%217+-8*29**A%7D0%01A987654320.-*
; https://tree.nathanfriend.io/?s=%28%27options%21%28%27fancy%21true%7EfullPath9%7EtrailingSlash9%7ErootDot9%29%7EB%28%27B%27%2FFbCe*aHt*.i*6n*GgAthumping2G4G5G0*646560*.s-eats2.4.5.0*8K7eCa*tHs*.Adevours28KCe-e%7D70%27%29%7Eversion%21%271%27%29*36-%7BJump+6IDefault-%2F%7D2%7D*3%5Cn4e-e25b-b26.+7Cb-b%7DC0F8+4+5I9%21falseA%7BSEND+Bsource%21C3.F3+G..H*+I+0K*450%01KIHGFCBA987654320.-*

root:=Map()
root.Default := root
everythingThatHasThisChar:=Map() ;children are HUGE
everywhereYouCanBranch:=Map() ;children are HUGE, everywhereYouCanBranch["e"].Count : 1000, then I'll 2048
charIsJumpOrNot:=Map() ;HUGE charIsJumpOrNot.Capacity 262144
charIsJumpOrNot.Capacity:=524288
; I don't think it makes it faster

sure(rest, toSend) {
    global root, everythingThatHasThisChar, everywhereYouCanBranch, charIsJumpOrNot

    bChar:=SubStr(rest, 1, 1)
    if (root.Has(bChar)) {
        b_:=root[bChar]
    } else {
        b_:=root[bChar]:=Map()
        b_.Default:=root
    }

    currentArr:=[b_]
    len:=StrLen(rest)
    lenPlusOne:=len+1
    i_:=2
    e_:=b_
    startI:=len
    while (i_<len) {
        char_:=SubStr(rest, i_, 1)

        if (e_.Has(char_)) {
            fromChars:=SubStr(rest, 1, i_)
            if (charIsJumpOrNot.Has(fromChars)) {
                charIsJumpOrNot.Delete(fromChars)

                startI:=Min(startI, i_)
                e_:=e_[char_]:=Map()
                e_.Default:=root
            } else {
                e_:=e_[char_]
            }
        } else {
            startI:=Min(startI, i_)
            e_:=e_[char_]:=Map()
            e_.Default:=root
        }
        currentArr.Push(e_)

        i_++
    }
    ;last
    if (charIsJumpOrNot.Has(rest)) {
        charIsJumpOrNot.Delete(rest)
    }
    char_:=SubStr(rest, len, 1)
    last_:=e_[char_]:=[toSend,StrLen(rest),rest]
    currentArr.Push(last_)

    ; root join on all your new added chars
    i_:=startI
    outer1:
    while (i_<len) {
        j_:=i_

        char_:=SubStr(rest, j_, 1)
        if (root.Has(char_)) {
            j_++
            v_:=root[char_]

            while (j_<lenPlusOne) {
                char_:=SubStr(rest, j_, 1)
                if (v_.Has(char_)) {
                    v_:=v_[char_]
                    if (Type(v_)=="Array") {
                        i_++
                        continue outer1
                    }
                } else {
                    ;decorate e_ with tree's keys of v_
                    e_:=currentArr[j_ - 1]

                    ; since tree's line is same as ours
                    chars_:=SubStr(rest, 1, j_ - 1)
                    thisChars:=SubStr(rest, i_, j_ - i_)
                    for k2, v2 in v_ {
                        if (!e_.Has(k2)) {
                            toChars_:=thisChars k2
                            fromChars:=chars_ k2
                            if (charIsJumpOrNot.Has(toChars_)) {
                                newToChars:=charIsJumpOrNot[toChars_]
                                charIsJumpOrNot[fromChars]:=newToChars
                            } else {
                                charIsJumpOrNot[fromChars]:=toChars_
                                e_[k2]:=v2 ;SETS TO MAGIC (JUMP)
                            }
                        }
                    }
                    i_++
                    continue outer1
                }
                j_++
            }
        }
        i_++
    }

    ;join my line /e----- on all "e"
    if (everywhereYouCanBranch.Has(bChar)) {
        everywhereToBranchOn:=everywhereYouCanBranch[bChar]
        outer2:
        for v_, preChars in everywhereToBranchOn { ;ahahahah, v_ is key, used like value of array

            j_:=2
            while (j_<lenPlusOne) {

                char_:=SubStr(rest, j_, 1)
                if (v_.Has(char_)) {
                    chars_:=SubStr(rest, 2, j_ - 1)
                    fromChars:=preChars chars_
                    if (charIsJumpOrNot.Has(fromChars)) {
                        toChars_:=SubStr(rest, 1, j_)
                        if (StrLen(toChars_) > StrLen(charIsJumpOrNot[fromChars])) {
                            charIsJumpOrNot[fromChars]:=toChars_

                            e_:=currentArr[j_]
                            v_[char_]:=e_ ;SETS TO MAGIC (JUMP)
                        }
                        continue outer2
                    } else {
                        v_:=v_[char_]
                    }
                    if (Type(v_)=="Array") {
                        continue outer2
                    }
                } else {
                    chars_:=SubStr(rest, 2, j_ - 1)
                    fromChars:=preChars chars_

                    toChars_:=SubStr(rest, 1, j_)
                    charIsJumpOrNot[fromChars]:=toChars_

                    e_:=currentArr[j_]
                    v_[char_]:=e_ ;SETS TO MAGIC (JUMP)
                    continue outer2
                }

                j_++
            }

        }
    }

    i_:=startI
    while (i_<len) {
        char_:=SubStr(rest, i_, 1)
        chars_:=SubStr(rest, 1, i_)
        everywhereYouCanBranch.Has(char_) || everywhereYouCanBranch[char_]:=Map()
        everywhereYouCanBranch[char_][currentArr[i_]]:=chars_

        i_++
    }

}

; #Include %A_LineFile%\..\star_Hotstrings.ah2

sure("beasing","333333333333")
sure("beating","thumping")
sure("easter","devours")
sure("easper","mono")

; sure("easper","mono")
; sure("easter","devours")
; sure("beasing","333333333333")
; sure("beating","thumping")

; sure("beat","1111111")
; sure("east","2222222")
; sure("ass","3333333")

; sure("beat","1111111")
; sure("ass","3333333")
; sure("east","2222222")

; sure("ass","3333333")
; sure("east","2222222")
; sure("beat","1111111")

; sure("2dn","2nd")
; sure("dady","daddy")
; sure("dyxlexia","dyslexia")

SacHook := InputHook("V")
SacHook.MinSendLevel := 1
SacHook.OnChar := SacChar
; SacHook.KeyOpt("{Backspace}", "N")
SacHook.Start()

tree_:=root
A_Clipboard:=printCircleObject(tree_)

ToolTip "ready"
SoundPlay "*-1"
sleep 300
ToolTip

history:=[]
history.Length := 2000 ;should be enough
histIndex:=0

return

SacChar(ih, char)
{
    global tree_, root, history, histIndex

    newTree:=tree_[char]

    if (Type(newTree)=="Array") {
        REEEEEEEEEE:="{BS " newTree[2] "}{Raw}" newTree[1]
        Send REEEEEEEEEE
        tree_:=root
        histIndex:=0
        return
    }

    ;bad patch, but makes startup way faster
    ; (I didn't notice a huge difference though)
    ;now it's O(1) to O(2) instead of O(1)
    ;O(2) being: 2 Map Accesses
    if (newTree==root && root.Has(char)) {
        tree_:=root[char]
    }

    histIndex++
    history[histIndex]:=tree_
    tree_:=newTree
}

~Backspace::{
    global tree_, history, histIndex
    if (histIndex) {
        tree_:=history[histIndex]
        histIndex--
    } else {
        tree_:=root
    }
}

f3::Exitapp

printCircleObject(root) {
    pleaseMaps:=Map()

    thisMap:=root
    pleaseMaps[thisMap]:="/"

    justMaps:=[thisMap]
    justCharArr:=[""]

    while (justMaps.Length) {
        tempMaps:=[]
        tempCharArr:=[]
        for i_, map_ in justMaps {
            chars:=justCharArr[i_]
            for k_, v_ in map_ {
                if (!pleaseMaps.Has(v_)) {
                    pleaseMaps[v_]:=chars k_

                    if (Type(v_)=="Map") {
                        tempMaps.Push(v_)
                        tempCharArr.Push(chars k_)
                    }

                }
            }
        }
        justMaps:=tempMaps
        justCharArr:=tempCharArr
    }

    VarSetStrCapacity(&finalStr, 1000000)

    chars:=""
    parents:=[]
    thisMap:=root
    EnumFunction:=thisMap.__Enum()
    while (true) {
        while (EnumFunction(&char_, &thisMap)) {
            finalStr.=Format("{:" parents.Length "}", "")
            if (pleaseMaps.Has(thisMap) && pleaseMaps[thisMap] !== chars char_) {
                finalStr.="(Jump " pleaseMaps[thisMap] ")`n"
                continue
            } else {
                chars.=char_
                finalStr.=char_ "`n"
            }

            if (Type(thisMap)=="Array") {
                finalStr.=Format("{:" parents.Length + 1 "}", "")
                finalStr.="(SEND " thisMap[1] ")`n"

                chars:=SubStr(chars,1,-1)
            } else {
                parents.Push(EnumFunction)
                EnumFunction:=thisMap.__Enum()
            }
        }

        if (parents.Length) {
            chars:=SubStr(chars,1,-1)
            EnumFunction:=parents.pop()
        } else {
            break
        }
    }

    return finalStr

}