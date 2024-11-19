//%attributes = {"invisible":true,"preemptive":"capable"}
var $tExpected; $tPattern; $tReplacement; $tTarget : Text
var $rgx : Object

$tTarget:="Hello world"
$rgx:=_o_rgx($tTarget)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.text=$tTarget)

$tPattern:="world"
$tReplacement:="all"
$tExpected:="Hello all"
$rgx.substitute($tPattern; $tReplacement)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.result=$tExpected)

$tExpected:=""
$rgx.setText($tTarget)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.text=$tTarget)
ASSERT:C1129($rgx.result=$tExpected)

$tExpected:="Hello "
$rgx.substitute($tPattern)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.result=$tExpected)

$tPattern:="none"
$tExpected:="No match for the pattern: \""+$tPattern+"\""
$rgx.setText($tTarget).substitute($tPattern; $tReplacement)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.text=$tTarget)
ASSERT:C1129($rgx.warnings.length=1)
ASSERT:C1129($rgx.warnings[0]=$tExpected)

$tTarget:="<!-- Hello wolrld -->"
$tPattern:="(?si-m)<!--(.*)-->"
$tReplacement:="<!--\r"+"Hello world"+"\r-->"
$tExpected:=$tReplacement
$rgx.setText($tTarget).substitute($tPattern; $tReplacement)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.text=$tTarget)
ASSERT:C1129($rgx.warnings.length=0)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.result=$tExpected)

$tTarget:="HELLO world, hello WORLD"
$tPattern:="(?mi-s)hello "
$tReplacement:="_"
$tExpected:="_world, _WORLD"
$rgx.setText($tTarget).substitute($tPattern; $tReplacement)
ASSERT:C1129($rgx.text=$tTarget)
ASSERT:C1129($rgx.success)
ASSERT:C1129($rgx.result=$tExpected)

$tPattern:="(?mi-s)hello ["
$tExpected:="Error: -1"
$rgx.substitute($tPattern; $tReplacement)
ASSERT:C1129(Not:C34($rgx.success))
ASSERT:C1129($rgx.errors.length=1)
ASSERT:C1129($rgx.errors[0]=$tExpected)


