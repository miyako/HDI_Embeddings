var $status : Object

If (FORM Event.code=On Clicked)
	
	If (Form.currentStudent=Null)
		ALERT(Localized string("Alert_SelectStudent"))
		return 
	End if 
	
	$status:=Form.currentStudent.save()
	If (Not($status.success))
		ALERT(Replace string(Localized string("Alert_SaveFailed"); "{1}"; String($status.statusText)))
	End if 
	
End if 
