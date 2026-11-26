//%attributes = {"invisible":true}
// SearchStudents: embeds Form.queryText and fills Form.students with the
// best matches (called by the Search button and the sample-query dropdown)

var $settings : cs.EmbeddingStudio.Settings
var $definition : cs.EmbeddingStudio.Definition
var $embedPrompt : cs.EmbeddingStudio.StudioEmbedder
var $result : cs.EmbeddingStudio.EmbedderResult
var $query : Text

Form.searchResults:=""

If (Form.queryText="")
	ALERT(Localized string("Alert_EnterQuery"))
	return 
End if 

If (Form.trace)
	TRACE
End if 

$settings:=cs.EmbeddingStudio.Settings.new()
$definition:=$settings.find("Students"; "student_vector")
If ($definition=Null)
	Form.searchResults:=Localized string("Alert_NoDefinition")
	return 
End if 

// Embed the query text with the same model as the stored vectors
// (the embedder throws on API errors, e.g. provider unreachable or invalid key)
$embedPrompt:=cs.EmbeddingStudio.StudioEmbedder.new()
Try
	$result:=$embedPrompt.embed(Form.queryText; $definition)
Catch
	Form.searchResults:=Replace string(Localized string("Alert_ErrorTemplate"); "{1}"; Last errors[0].message)
	return 
End try

If ($result.vector=Null)
	Form.searchResults:=Localized string("Alert_NoVector")
	return 
End if 

// Similarity query: keep students above the threshold, best match first
$query:="student_vector > :1"
If (Not(Form.includeDirtyVectors))
	$query+=" and student_vector_dirty = false"
End if 
$query+=" order by student_vector desc"

Form.students:=ds.Students.query($query; {vector: $result.vector; threshold: Form.threshold})

If (Form.students.length=0)
	Form.searchResults:=Localized string("Msg_NoResult")
End if 
