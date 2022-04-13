put all your `:*?:` hotstrings in `star_Hotstrings.ah2` then run `Keysharp_hotstring.ah2`

I'm not putting my personal hotstrings as an example: I need some example hotstrings

___
to convert `:*?:wouldnt::wouldn't` -> `sure("wouldnt","wouldn't")`<br>
<br>
regex:<br>
replace<br>
``^:(?:\?\*|\*\?):(.*)::((?:[^:]|`:)*?)$``<br>
with<br>
`sure("$1","$2")`<br>
<br>
or
<br>
<br>
run `clipboard_ahkHotstring_to_func.ah2`
