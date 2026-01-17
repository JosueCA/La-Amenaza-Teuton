
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl" xmlns:HTML="http://www.w3.org/Profiles/XHTML-transitional">
  <xsl:template match="text()"><xsl:value-of/></xsl:template>
  
  <xsl:template match="/">
	<html>
		<head>
		<style type="text/css">
			body { font-family: Tahoma; font-size: 9pt; background-color: #E0E0E0; }
			table { font-family: Tahoma; font-size: 9pt; text-align="center"; }
			th.big { font-size: 11 pt; }
		</style>
		</head>
		<body>
			<xsl:apply-templates select="entity"/>
		</body>
	</html>	
  </xsl:template>

  <xsl:template match="entity">
	<h1><xsl:value-of select="@name"/></h1>
	<p>
		<b>Type: </b><xsl:value-of select="@type"/><br/>
		<b>Radius: </b><xsl:value-of select="@radius"/><br/>
		<b>Selection radius: </b><xsl:value-of select="@selection_radius"/><br/>
		<b>Variations: </b><xsl:value-of select="@variations"/><br/>
	</p>
	
	<xsl:apply-templates select="images"/><p/>
	<xsl:apply-templates select="points"/><p/>
	<xsl:apply-templates select="layers"/><p/>
	<xsl:apply-templates select="states"/><p/>
	<xsl:apply-templates select="anims"/><p/>
 </xsl:template>

  <xsl:template match="images">
	<table border="1">
		<tr>
			<th colspan="5" class="big">Images</th>
		</tr>
		<tr>
			<th>Index</th>
			<th>Filename</th>
			<th>Drawmode</th>
			<th>Rows</th>
			<th>Columns</th>
		</tr>
		<xsl:apply-templates select="image"/>
	</table>
</xsl:template>

<xsl:template match="image">
	<tr>
		<td><xsl:value-of select="@idx"/></td>
		<td><xsl:value-of select="@file"/></td>
		<td><xsl:value-of select="@drawmode"/></td>
		<td><xsl:value-of select="@rows"/></td>
		<td><xsl:value-of select="@columns"/></td>
	</tr>	
</xsl:template>

<xsl:template match="points">
	<table border="1">
		<tr>
			<th colspan="5" class="big">Points</th>
		</tr>
		<tr>
			<th>Index</th>
			<th>Name</th>
			<th>Coords</th>
		</tr>
		<xsl:apply-templates select="point"/>
	</table>
</xsl:template>

<xsl:template match="point">
	<tr>
		<td><xsl:value-of select="@idx"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@x"/>,<xsl:value-of select="@y"/></td>
	</tr>	
</xsl:template>

<xsl:template match="layers">
	<table border="1">
		<tr>
			<th colspan="5" class="big">Layers</th>
		</tr>
		<tr>
			<th>Index</th>
			<th>Name</th>
			<th>Image</th>
			<th>Z</th>
			<th>Offset</th>
		</tr>
		<xsl:apply-templates select="layer"/>
	</table>
</xsl:template>

<xsl:template match="layer">
	<tr>
		<td><xsl:value-of select="@idx"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@image"/></td>
		<td><xsl:value-of select="@z"/></td>
		<td><xsl:value-of select="@offsetx"/>,<xsl:value-of select="@offsety"/></td>
	</tr>	
</xsl:template>

<xsl:template match="states">
	<table border="1">
		<tr>
			<th colspan="5" class="big">States</th>
		</tr>
		<tr>
			<th>Index</th>
			<th>Name</th>
		</tr>
		<xsl:apply-templates select="state"/>
	</table>
</xsl:template>

<xsl:template match="state">
	<tr>
		<td><xsl:value-of select="@idx"/></td>
		<td><xsl:value-of select="@name"/></td>
	</tr>	
</xsl:template>

<xsl:template match="anims">
	<xsl:apply-templates select="anim"/><p/>
</xsl:template>

<xsl:template match="anim">
	<table border="1">
		<tr>
			<th colspan="7" class="big">Animation</th>
		</tr>
		<tr>
			<th>Index</th>
			<th>Name</th>
			<th>Start state</th>
			<th>End state</th>
			<th>Frames</th>
			<th>Duration</th>
			<th>Step</th>
		</tr>
	<tr>
		<td><xsl:value-of select="@idx"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@startstate"/></td>
		<td><xsl:value-of select="@endstate"/></td>
		<td><xsl:value-of select="@frames"/></td>
		<td><xsl:value-of select="@duration"/></td>
		<td><xsl:value-of select="@step"/></td>
	</tr>	
	<tr>
		<td/>
		<td colspan="6">
		<table border="1" width="100%">
			<tr>
				<th colspan="4" class="big">
					Replace
				</th>
			</tr>
			<tr>
				<th>Layer</th>
				<th>With image</th>
				<th>Offset</th>
			</tr>
			<xsl:apply-templates select="replace"/>
		</table>
		</td>
	</tr>	
	<tr>
		<td/>
		<td colspan="6">
		<table border="1" width="100%">
			<tr>
				<th colspan="4" class="big">
					Frames
				</th>
			</tr>
			<tr>
				<th>Index</th>
				<th>Duration</th>
			</tr>
			<xsl:apply-templates select="frame"/>
		</table>
		</td>
	</tr>	
	</table>
	<br/>
</xsl:template>

<xsl:template match="replace">
	<tr>
		<td><xsl:value-of select="@layer"/></td>
		<td><xsl:value-of select="@image"/></td>
 		<td><xsl:value-of select="@offsetx"/>,<xsl:value-of select="@offsety"/></td>
	</tr>	
</xsl:template>

<xsl:template match="frame">
	<tr>
		<td><xsl:value-of select="@idx"/></td>
		<td><xsl:value-of select="@duration"/></td>
	</tr>	
</xsl:template>

</xsl:stylesheet>
