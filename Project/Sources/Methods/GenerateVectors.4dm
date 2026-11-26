//%attributes = {"invisible":true}
// GenerateVectors: runs the Embedding Studio pipeline and returns a readable report
// $force = False -> only entities with a null or dirty vector are processed
// $force = True  -> every vector is recomputed

#DECLARE($force : Boolean)->$report : Text

var $cr : Text:=Char(Carriage return)
var $settings : cs.EmbeddingStudio.Settings
var $process : cs.EmbeddingStudio.Process
var $result : cs.EmbeddingStudio.ProcessResult
var $err : Object

$settings:=cs.EmbeddingStudio.Settings.new()
$process:=cs.EmbeddingStudio.Process.new($settings; {force: $force})
$result:=$process.process()

If ($result.success)
	$report:=\
		Localized string("Report_Done")+$cr+\
		Replace string(Localized string("Report_Updated"); "{1}"; String($result.entitiesUpdated))+$cr+\
		Replace string(Localized string("Report_Skipped"); "{1}"; String($result.entitiesSkipped))+$cr+\
		Replace string(Localized string("Report_Tokens"); "{1}"; String($result.totalTokens))+$cr+\
		Replace string(Localized string("Report_APICalls"); "{1}"; String($result.apiCalls))+$cr+\
		Replace string(Localized string("Report_Duration"); "{1}"; String($result.duration))
Else 
	$report:=Localized string("Report_Error")+$cr
	For each ($err; $result.errors)
		$report+=" "+$err.message+$cr
	End for each 
End if 
