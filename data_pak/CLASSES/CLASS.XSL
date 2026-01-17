<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:HTML="http://www.w3.org/Profiles/XHTML-transitional">

<xsl:template match="/">
	<html>
		<head>
		<style type="text/css">
			body { font-family: Tahoma; font-size: 9pt; background-color: #E0E0E0; }
			table { font-family: Tahoma; font-size: 9pt; text-align="left"; }
			th.big { font-size: 11 pt; }
		</style>
		</head>
		<body>
			<xsl:apply-templates select="class"/>
		</body>
	</html>	
</xsl:template>

<xsl:template match="class">
	<p>
	<b>class</b> <xsl:value-of select="@id"/> (<xsl:value-of select="@cpp_class"/>) 
	<xsl:if test="@parent">
		:  
		<xsl:element name="a"> 
			<xsl:attribute name="href"> <xsl:value-of select="@parent"/>.sc.xml </xsl:attribute> 
			<xsl:value-of select="@parent"/> 
		</xsl:element>
	</xsl:if>
	</p> 
	<xsl:if test="@entity">
		<p>
		<b>entity</b>
		<xsl:element name="a"> 
			<xsl:attribute name="href"> ../../<xsl:value-of select="@entity"/> </xsl:attribute> 
			<xsl:value-of select="@entity"/> 
		</xsl:element>
		</p>
	</xsl:if>
	<xsl:if test="properties">
		<p>
		<table border="1" cellspacing="2" cellpadding="3">
			<tr>
				<td colspan="2"> <b>properties:</b> </td>
			</tr>
			<xsl:apply-templates select="properties"/>
		</table>
		</p>
	</xsl:if>
	<xsl:if test="method">
		<p>
		<table border="1" cellspacing="2" cellpadding="3">
			<tr>
				<td colspan="2"> <b>methods:</b> </td>
			</tr>
			<xsl:apply-templates select="method"/>
		</table>
		</p>
	</xsl:if>
</xsl:template>

<xsl:template match="properties">
	<xsl:for-each select="@*">
		<tr>
			<td> <xsl:value-of select="name()"/> </td> 
			<td> <xsl:value-of select="."/> </td>
		</tr>
	</xsl:for-each>
</xsl:template>

<xsl:template match="method">
		<tr>
			<td> <xsl:value-of select="@sig"/> </td>
			<td>  
			<xsl:element name="a"> 
				<xsl:attribute name="href"> ../../<xsl:value-of select="@vs"/> </xsl:attribute> 
				<xsl:value-of select="@vs"/>
			</xsl:element>
			</td>
		</tr>
</xsl:template>

</xsl:stylesheet>

