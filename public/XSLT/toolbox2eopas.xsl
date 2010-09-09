<?xml version="1.0" encoding="UTF-8"?>
<!-- working with EOPAS 2.0 Schema -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:dc="http://purl.org/dc/elements/1.1/" 
xmlns:tb="http://wiki.arts.unimelb.edu.au/ethnoer/toolbox/1.0/"
exclude-result-prefixes="tb"
version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/">
    <xsl:if test="not(/tb:database)">
        <xsl:message terminate="yes">ERROR: Not an ELAN document</xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:variable name="narrator"/>
  <xsl:template match="/tb:database">
    <xsl:if test="/tb:database/tb:itmgroup/tb:nt">
      <xsl:variable name="narrator" select="/tb:database/tb:itmgroup/tb:nt/text()"/>
    </xsl:if>

    <eopas>
      <header>
        <meta>
          <!-- MIME Type -->
          <xsl:attribute name="name">dc:type</xsl:attribute>
          <xsl:attribute name="value">text/xml</xsl:attribute>
        </meta>
      </header>

      <interlinear-text>
        <!-- for each "tb:itmGroup" and "tb:itmgroup" -->
        <xsl:for-each select="tb:itmgroup">
          <!-- create translation (free gloss) tier -->
          <tier>
            <!-- Metadata per tier -->
            <xsl:attribute name="id">fg_<xsl:value-of select="./tb:itm/text()"/></xsl:attribute>
            <xsl:attribute name="linguistic_type">translation</xsl:attribute>

            <!-- individual phrases -->
            <xsl:for-each select="tb:idgroup">
              <phrase>
                <!-- get start and end time -->
                <xsl:variable name="s" select="tb:aud"/>
                <xsl:variable name="delimiter" select="' '"/>
                <xsl:variable name="timeOnly" select="substring-after($s, $delimiter)"/>
                <xsl:attribute name="startTime">
                  <xsl:variable name="startTime" select="substring-before($timeOnly, $delimiter)"/>
                  <xsl:value-of select="$startTime"/>
                </xsl:attribute>
                <xsl:attribute name="endTime">
                  <xsl:variable name="endTime" select="substring-after($timeOnly, $delimiter)"/>
                  <xsl:value-of select="$endTime"/>
                </xsl:attribute>

                <xsl:attribute name="id">fg_<xsl:value-of select="tb:id"/></xsl:attribute>

                <xsl:if test="$narrator != ''">
                  <xsl:attribute name="participant">
                    <xsl:value-of select="$narrator"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="tb:fg/text()"/>
              </phrase>
            </xsl:for-each>
          </tier>

          <!-- create transcription (orthographic) tier -->
          <tier>
            <!-- Metadata per tier -->
            <xsl:attribute name="id">o_<xsl:value-of select="./tb:itm/text()"/></xsl:attribute>
            <xsl:attribute name="linguistic_type">orthographic</xsl:attribute>

            <!-- individual phrases -->
            <xsl:for-each select="tb:idgroup">
              <phrase>
                <!-- get start and end time -->
                <xsl:variable name="s" select="tb:aud"/>
                <xsl:variable name="delimiter" select="' '"/>
                <xsl:variable name="timeOnly" select="substring-after($s, $delimiter)"/>
                <xsl:attribute name="startTime">
                  <xsl:variable name="startTime" select="substring-before($timeOnly, $delimiter)"/>
                  <xsl:value-of select="$startTime"/>
                </xsl:attribute>
                <xsl:attribute name="endTime">
                  <xsl:variable name="endTime" select="substring-after($timeOnly, $delimiter)"/>
                  <xsl:value-of select="$endTime"/>
                </xsl:attribute>

                <xsl:attribute name="id">o_<xsl:value-of select="tb:id"/></xsl:attribute>

                <xsl:if test="$narrator != ''">
                  <xsl:attribute name="participant">
                    <xsl:value-of select="$narrator"/>
                  </xsl:attribute>
                </xsl:if>

                <!-- compose text together -->
                <!-- for each "txGroup" and "txgroup" -->
                <xsl:for-each select="tb:txgroup/tb:tx">
                  <xsl:value-of select="concat(., ' ')"></xsl:value-of>
                </xsl:for-each>
              </phrase>
            </xsl:for-each>
          </tier>
        </xsl:for-each>
      </interlinear-text>

    </eopas>
  </xsl:template>
</xsl:stylesheet>
