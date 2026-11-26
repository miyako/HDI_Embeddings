var $count : Integer

If (Form event code=On Clicked)
	
	If (Not(CONFIRM(Localized string("Confirm_Regenerate"))))
		return 
	End if 
	
	ds:C1482.Students.all().drop()
	SET DATABASE PARAMETER([Students]; Table sequence number; 0)
	PopulateStudents
	$count:=ds:C1482.Students.all().length
	
	Form.allStudents:=ds:C1482.Students.all()
	Form.students:=ds:C1482.Students.all()
	Form.currentStudent:=Null
	
	ALERT(Replace string(Localized string("Msg_Regenerated"); "{1}"; String($count)))
	
End if 
