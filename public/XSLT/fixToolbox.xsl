<?xml version="1.0" encoding="UTF-8"?>
<!-- strips off all namespaces (through local-name()) and 
     renames all element and attribute names to lower-case (through translate()) -->
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="*">
    <xsl:element name="{translate(local-name(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqstuvwxyz')}" >
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:attribute name="{translate(local-name(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqstuvwxyz')}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
