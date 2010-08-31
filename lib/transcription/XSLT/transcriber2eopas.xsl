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
  <xsl:template match="/Trans/Episode">
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
        <meta>
          <!-- Dublin Core "creator" -->
          <xsl:attribute name="name">dc:creator</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$creator"/>
          </xsl:attribute>
        </meta>
      </header>

      <interlinear-text>
        <!-- section tier -->
        <tier>
          <!-- Metadata for section tier -->
          <xsl:attribute name="id">Sections</xsl:attribute>
          <xsl:attribute name="linguistic_type">
            <xsl:value-of select="Section/@type"/> <!-- seems they are always the same -->
          </xsl:attribute>

          <!-- Phrases of section tier -->
          <phrases>
            <xsl:for-each select="Section">
              <phrase>
                <xsl:variable name="topicId" select="@topic"/>
                <xsl:variable name="description" select="/Trans/Topics/Topic[@id=$topicId]/@desc"/>
                <xsl:attribute name="startTime">
                  <xsl:value-of select="@startTime"/>
                </xsl:attribute>
                <xsl:attribute name="endTime">
                  <xsl:value-of select="@endTime"/>
                </xsl:attribute>
                <xsl:attribute name="id">
                  <xsl:value-of select="@topic"/>
                </xsl:attribute>
                <xsl:value-of select="$description"/>
              </phrase>
            </xsl:for-each>
          </phrases>
        </tier>

        <!-- turn tier -->
        <tier>
          <!-- Metadata for turn tier -->
          <xsl:attribute name="id">Turns</xsl:attribute>
          <xsl:attribute name="parent">Sections</xsl:attribute>
          <xsl:attribute name="linguistic_type">speaker turn</xsl:attribute>

          <!-- Phrases of turn tier -->
          <phrases>
            <xsl:for-each select="Section/Turn">
              <phrase>
                <xsl:attribute name="startTime">
                  <xsl:value-of select="@startTime"/>
                </xsl:attribute>
                <xsl:attribute name="endTime">
                  <xsl:value-of select="@endTime"/>
                </xsl:attribute>
                <xsl:if test="@speaker">
                  <xsl:variable name="speakerId" select="@speaker"/>
                  <xsl:variable name="speaker" select="/Trans/Speakers/Speaker[@id=$speakerId]/@name"/>
                  <xsl:variable name="dialect" select="/Trans/Speakers/Speaker[@id=$speakerId]/@dialect"/>
                  <xsl:variable name="type" select="/Trans/Speakers/Speaker[@id=$speakerId]/@type"/>
                  <xsl:variable name="accent" select="/Trans/Speakers/Speaker[@id=$speakerId]/@accent"/>
                  <xsl:attribute name="participant">
                    <xsl:value-of select="$speaker"/>
                  </xsl:attribute>
                  <xsl:value-of select="normalize-space(concat($dialect,' ',$type,' ',$accent))"/>
                </xsl:if>
              </phrase>
            </xsl:for-each>
          </phrases>
        </tier>

        <!-- Sync tier -->
        <tier>
          <!-- Metadata for sync tier -->
          <xsl:attribute name="id">Syncs</xsl:attribute>
          <xsl:attribute name="parent">Turns</xsl:attribute>
          <xsl:attribute name="linguistic_type">orthographic</xsl:attribute>

          <!-- Phrases of sync tier -->
          <phrases>
            <xsl:for-each select="Section/Turn/text()">
              <xsl:if test="not(local-name(.)='Sync')">
                <phrase>
                  <xsl:variable name="speakerId" select="@speaker"/>
                  <xsl:variable name="speaker" select="/Trans/Speakers/Speaker[@id=$speakerId]/@name"/>
                  <xsl:attribute name="id">s<xsl:value-of select="position()"/></xsl:attribute>
                  <xsl:attribute name="startTime">
                    <xsl:value-of select="(preceding-sibling::Sync)[last()]/@time"/>
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
                  <xsl:value-of select="normalize-space(.)"/>
                </phrase>
              </xsl:if>
            </xsl:for-each>
          </phrases>
        </tier>

      </interlinear-text>

    </eopas>
  </xsl:template>
</xsl:stylesheet>
