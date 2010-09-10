<?xml version="1.0" encoding="UTF-8"?>
<!-- based on EOPAS 2.0 Schema -->
<!-- BIG DISCLAIMER: THIS IS BROKEN!!! -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="http://www.mpi.nl/tools/elan/EAFv2.6.xsd"
version="1.0"
xmlns:xalan="http://xml.apache.org/xalan"
exclude-result-prefixes="xalan">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="mediafile" select="/eopas/header/meta[@name='dc:source']/@value"/>
  <xsl:param name="type" select="/eopas/header/meta[@name='dc:type']/@value"/>
  <xsl:param name="creator" select="/eopas/header/meta[@name='dc:creator']/@value"/>
  <xsl:param name="lang_code" select="/eopas/header/meta[@name='dc:language']/@value"/>
  <xsl:param name="language_code" select="substring-after($lang_code,'-')"/>
  <xsl:param name="country_code" select="substring-before($lang_code,'-')"/>
  <xsl:param name="date" select="/eopas/header/meta[@name='dc:date']/@value"/>
  <xsl:template match="/">
    <xsl:if test="not(/eopas)">
        <xsl:message terminate="yes">ERROR: Not an EOPAS document</xsl:message>
    </xsl:if>
    <xsl:call-template name="main"/>
  </xsl:template>

  <xsl:key name="start" match="//phrase" use="@startTime"/>
  <xsl:key name="end" match="//phrase" use="@endTime"/>
  <xsl:template match="/eopas" name="main">
    <ANNOTATION_DOCUMENT>
      <xsl:attribute name="AUTHOR">
        <xsl:value-of select="$creator"/>
      </xsl:attribute>
      <xsl:attribute name="DATE">
        <xsl:value-of select="$date"/>
      </xsl:attribute>
      <xsl:attribute name="FORMAT">2.6</xsl:attribute>
      <xsl:attribute name="VERSION">2.6</xsl:attribute>

      <HEADER>
        <xsl:attribute name="MEDIA_FILE">
          <xsl:value-of select="$mediafile"/>
        </xsl:attribute>
        <xsl:attribute name="TIME_UNITS">milliseconds</xsl:attribute>
        <MEDIA_DESCRIPTOR>
          <xsl:attribute name="MEDIA_URL">
            <xsl:value-of select="$mediafile"/>
          </xsl:attribute>
          <xsl:attribute name="MIME_TYPE">
            <xsl:value-of select="$type"/>
          </xsl:attribute>
        </MEDIA_DESCRIPTOR>
      </HEADER>

      <TIME_ORDER>
        <xsl:variable name="Milliseconds_CONST" select="1000"/>

<!-- THIS IS A TEST FOR GETTING UNIQUE startTime AND sorted -->
        <xsl:for-each select="//phrase[count(.|key('start', @startTime)[1]) = 1]">
          <xsl:sort select="@startTime" data-type="number"/>
          <sort>
            <xsl:value-of select="@startTime * $Milliseconds_CONST"/>
          </sort>
        </xsl:for-each>

<!-- THIS IS A TEST FOR GETTING ALL startTime AND endTime ATTRIBUTE VALUES -->
        <xsl:for-each select="//phrase">
          <xsl:variable name="startTime_Seconds" select="@startTime"/>
          <xsl:variable name="endTime_Seconds" select="@endTime"/>
          <xsl:variable name="startTime_VALUE" select="$startTime_Seconds * $Milliseconds_CONST"/>
          <xsl:variable name="endTime_VALUE" select="$endTime_Seconds * $Milliseconds_CONST"/>
          <!-- ignore start for now - is above
          <start>
            <xsl:value-of select="$startTime_VALUE"/>
          </start>
          -->
          <end>
            <xsl:value-of select="$endTime_VALUE"/>
          </end>
        </xsl:for-each>

<!-- SO: THIS IS WHAT SHOULD BE PROGRESSED: IT GETS ALL THE VALUES UNIQUELY -->
<!-- except: the xalan thing doesn't work -->
        <xsl:variable name="treefrag">
          <docfrag>
            <xsl:for-each select="//phrase">
              <xsl:if test="generate-id(.) = generate-id(key('start', @startTime)[1])">
                <unique>
                  <xsl:value-of select="@startTime * $Milliseconds_CONST"/>
                </unique>
              </xsl:if>
              <xsl:if test="generate-id(.) = generate-id(key('end', @endTime)[1])">
                <unique>
                  <xsl:value-of select="@endTime * $Milliseconds_CONST"/>
                </unique>
              </xsl:if>
            </xsl:for-each>
          </docfrag>
        </xsl:variable>
        <xsl:call-template name="process_tree">
          <!-- this may not be possible, but needs two xsl scripts to work -->
          <xsl:with-param name="tree" select="xalan:nodeset($treefrag)"/>
        </xsl:call-template>
      </TIME_ORDER>
    </ANNOTATION_DOCUMENT>
  </xsl:template>

  <xsl:template name="process_tree">
    <xsl:param name="tree"/>
    <TIME_ORDER>
      <xsl:for-each select="$tree/docfrag/unique">
        <xsl:sort select="." data-type="number"/>
        <TIME_SLOT>
          <xsl:attribute name="TIME_VALUE">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </TIME_SLOT>
      </xsl:for-each>
    </TIME-ORDER>
  </xsl:template>
</xsl:stylesheet>
