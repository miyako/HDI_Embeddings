//%attributes = {"invisible":true}
// Method: PopulateStudents
// Description: Creates the sample student records if the Students table is
// empty, in the current UI language. Data comes from
// Resources/<lang>.lproj/sampleData.json (en.lproj is the fallback).
// -> $count : number of students created (0 when the table was not empty)

#DECLARE->$count : Integer

$count:=0

If (ds:C1482.Students.all().length>0)
	return 
End if 

var $file : 4D.File
var $path : Text:=Localized document path("sampleData.json")
If ($path#"")
	$file:=File($path; fk platform path)
End if 
If ($file=Null) || (Not($file.exists))
	$file:=Folder(fk resources folder).file("en.lproj/sampleData.json")
End if 

var $students : Collection:=JSON Parse($file.getText()).students

var $item : Object
For each ($item; $students)
	var $s : cs:C1710.StudentsEntity:=ds:C1482.Students.new()
	$s.firstName:=$item.firstName
	$s.lastName:=$item.lastName
	$s.program:=$item.program
	$s.bio:=$item.bio
	$s.save()
End for each 

$count:=$students.length
