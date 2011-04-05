<?xml version="1.0" encoding="UTF-8"?>
<!-- working with EOPAS 2.0 Schema -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:dc="http://purl.org/dc/elements/1.1/"
version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="mediafile" select="/Trans/@audio_filename"/>
  <xsl:param name="creator" select="/Trans/@scribe"/>
  <xsl:template match="/">
    <xsl:if test="not(/Trans)">
        <xsl:message terminate="yes">ERROR: Not a Transcriber document</xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="/Trans">
    <eopas>
      <header>
        <meta>
          <!-- MIME Type -->
          <xsl:attribute name="name">dc:type</xsl:attribute>
          <xsl:attribute name="value">text/xml</xsl:attribute>
        </meta>
        <meta>
          <!-- media resource URI -->
          <xsl:attribute name="name">dc:source</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$mediafile"/>
          </xsl:attribute>
        </meta>
        <xsl:if test="normalize-space($creator) != ''">
          <meta>
            <!-- Dublin Core "creator" -->
            <xsl:attribute name="name">dc:creator</xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="$creator"/>
            </xsl:attribute>
          </meta>
        </xsl:if>
        <!-- Add all speakers to metadata -->
        <xsl:for-each select="Speakers/Speaker">
          <meta>
            <xsl:attribute name="name">
              <xsl:value-of select="./@id"/>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="./@name"/>
            </xsl:attribute>
          </meta>
        </xsl:for-each>
      </header>

      <interlinear>

        <!-- Phrases of sync tier -->
        <xsl:for-each select="Episode/Section/Turn">

          <xsl:for-each select="Sync">
            <xsl:if test="following-sibling::node()">
            <xsl:if test="name(following-sibling::node())!='Sync'">
              <phrase>
                <xsl:if test="normalize-space(../@speaker) != ''">
                  <xsl:attribute name="participant"><xsl:value-of select="../@speaker"/></xsl:attribute>
                </xsl:if>
                <xsl:attribute name="id">s<xsl:value-of select="count(preceding::Sync)+1"/></xsl:attribute>
                <xsl:attribute name="startTime">
                  <xsl:value-of select="@time"/>
                </xsl:attribute>
                <xsl:attribute name="endTime">
                  <xsl:choose>
                    <xsl:when test="(following-sibling::Sync)[1]/@time">
                      <xsl:value-of select="(following-sibling::Sync)[1]/@time"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="../@endTime"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <transcription>
                  <xsl:value-of select="normalize-space((following-sibling::text()))"/>
                  <xsl:if test="name(following-sibling::node())='Comment'">[<xsl:value-of select="(following-sibling::Comment)[1]/@desc"/>]</xsl:if>
                  <xsl:if test="name(following-sibling::node())='Event'">[<xsl:value-of select="(following-sibling::Event)[1]/@desc"/> - <xsl:value-of select="(following-sibling::Event)[1]/@extent"/>]</xsl:if>
                </transcription>
              </phrase>
            </xsl:if>
            </xsl:if>
          </xsl:for-each>

        </xsl:for-each>

      </interlinear>

    </eopas>
  </xsl:template>
</xsl:stylesheet>
