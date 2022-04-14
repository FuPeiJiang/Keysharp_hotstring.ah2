
run `Keysharp_hotstring.ah2`

these will be your example hotstrings:<br>
`exampleHotstrings\3-sure.ah2` contains 4067 `:*?:` hotstrings derived from https://www.autohotkey.com/download/AutoCorrect.ahk
using script `exampleHotstrings\conflictingHotstrings6.ah2`

___
to convert `:*?:wouldnt::wouldn't` -> `sure("wouldnt","wouldn't")`<br>

1. best method (takes out invalid hotstrings):<br>
put everything inside `exampleHotstrings\dump2.ahk`<br>
and run `exampleHotstrings\conflictingHotstrings6.ah2`<br>
<br>
or<br>
<br>
2. regex:<br>
replace<br>
``^:(?:\?\*|\*\?):(.*)::((?:[^:]|`:)*?)$``<br>
with<br>
`sure("$1","$2")`<br>
<br>
or<br>
<br>
3. run `clipboard_ahkHotstring_to_func.ah2`
