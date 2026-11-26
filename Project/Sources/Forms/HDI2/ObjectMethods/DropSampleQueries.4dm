If (Form event code=On Clicked)
	
	If (Form.sampleQueries.index>=0)
		Form.queryText:=Form.sampleQueries.values[Form.sampleQueries.index]
		SearchStudents
	End if 
	
End if 
