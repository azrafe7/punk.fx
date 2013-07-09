<#macro commonImports>
	<#include "commonImports.as.inc">
</#macro>

<#macro commonVars>
	<#include "commonVars.as.inc">
</#macro>

<#macro commonConstructorBody>
	<#include "commonConstructorBody.as.inc">
</#macro>	

<#-- render and update methods have special logic if ${thisClass} == "FXImage" -->
<#macro commonMethods>
	<#include "commonMethods.as.inc">
</#macro>