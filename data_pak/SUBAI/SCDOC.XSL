<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:HTML="http://www.w3.org/Profiles/XHTML-transitional">
  
<xsl:template match="/">
	<html>
		<head>
		<style type="text/css">
			body { font-family: Tahoma; font-size: 9pt; background-color: #E0E0E0; margin-left:1em; }
			table { font-family: Tahoma; font-size: 9pt; text-align="left"; }
			th.big { font-size: 11 pt; }
			.typedef   { margin-left:1em; font-size: 12pt; margin-top:10pt; margin-bottom:4pt; cursor:hand }
			.typebody  { margin-left:3em; }
			.groupdef  { margin-left:1em; font-size: 12pt; margin-top:10pt; margin-bottom:4pt; cursor:hand }
			.groupbody { margin-left:3em; }
			.funcdef   { margin-left:2em; margin-top:4pt; margin-bottom:2pt; cursor:hand }
			.funcbody  { margin-left:4em; }
			.propdef   { margin-left:2em; margin-top:4pt; margin-bottom:2pt; cursor:hand }
			.propbody  { margin-left:4em; }
			.descr     { margin-left:3em; margin-top:4pt; }
			.divider   { margin-top:6pt; margin-bottom:0pt; font-weight:bold }
		</style>
		<script><xsl:comment>
		function toggle(e) {
			if (e.style.display == "") { 
				e.style.display = "none"; 
			} else 
			if (e.style.display == "none") {
				e.style.display = "";
			}
			return false
		}
		
		function a_click() {
			e = window.event.srcElement;
			while (e.parentElement) {
				if (e.className == "typedef") return toggle(e.nextSibling);
				if (e.className == "groupdef") return toggle(e.nextSibling);
				if (e.className == "funcdef") return toggle(e.nextSibling);
				if (e.className == "propdef") return toggle(e.nextSibling);
				e = e.parentElement;
			} 
			return false
		}
		</xsl:comment></script>
		</head>
		<body>
		    <div><h2>Types</h2></div>
			<div><xsl:apply-templates select="doc/type"/></div>
		    <div style="margin-top:30pt"><h2>Function groups</h2></div>
			<div><xsl:apply-templates select="doc/group"/></div>
		</body>
	</html>	
</xsl:template>

<xsl:template name="typename">
	<xsl:element name="a"> 
		<xsl:attribute name="href">#type-<xsl:value-of select="."/></xsl:attribute> 
		<xsl:value-of select="."/> 
	</xsl:element>
</xsl:template>

<xsl:template name="treenode">
	<a href="#" onclick="javascript:return a_click()" style="text-decoration:none; color:black"> 
		<b> <xsl:value-of select="@name"/> </b> 
	</a>
</xsl:template>

<xsl:template match="type">
	<a name="type-{@name}"/>
	<div class="typedef">
  		type <xsl:call-template name="treenode"/>
		<xsl:if test="@parent!=''">
			:  
			<xsl:for-each select="@parent">
				<xsl:call-template name="typename"/>
			</xsl:for-each>
		</xsl:if>
	</div>
	<div class="typebody" style="display:none">
	  <xsl:if test="prop">
			<div class="divider">properties:</div>
			<xsl:apply-templates select="prop"/>
		</xsl:if>
	  <xsl:if test="func">
			<div class="divider">methods:</div>
			<xsl:apply-templates select="func"/>
		</xsl:if>
	  <xsl:if test="description">
		<div class="divider">description:</div>
		<div class="descr">
			<xsl:value-of select="description"/>
		</div>
		</xsl:if>
	</div>
</xsl:template>

<xsl:template match="prop">
	<div class="propdef">
		<xsl:for-each select="@type">
			<xsl:call-template name="typename"/>
		</xsl:for-each>
		<xsl:if test="@ptr='1'">*</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:call-template name="treenode"/>
	</div>
	<div class="propbody" style="display:none">
		<xsl:value-of select="description"/>
	</div>
</xsl:template>

<xsl:template match="func">
	<div class="funcdef" onclick="click">
		<xsl:for-each select="@returns">
			<xsl:call-template name="typename"/>
		</xsl:for-each>
		<xsl:if test="@ptr='1'">*</xsl:if>
		<xsl:if test="@latent='1'"> latent</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:call-template name="treenode"/>
		(<xsl:for-each select="param">
			<xsl:if test="preceding-sibling::param[1]"><xsl:text>, </xsl:text></xsl:if>
			<xsl:for-each select="@type">
				<xsl:call-template name="typename"/>
			</xsl:for-each>
			<xsl:if test="@ptr='1'">*</xsl:if>
			<xsl:text> </xsl:text><xsl:value-of select="@name"/>
		</xsl:for-each>)
	</div>
	<div class="funcbody" style="display:none">
		<xsl:value-of select="description"/>
	</div>
</xsl:template>

<xsl:template match="group">
	<div class="groupdef" onclick="click"> 
		group <xsl:call-template name="treenode"/>
	</div>
	<div class="groupbody" style="display:none">
		<div class="divider">functions:</div>
		<xsl:apply-templates select="func"/>
		<div class="divider">description:</div>
		<div class="descr">
			<div><xsl:value-of select="description"/></div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>

