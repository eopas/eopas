<?xml version="1.0" encoding="UTF-8"?>
<!-- working with EOPAS 2.0 Schema -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:dc="http://purl.org/dc/elements/1.1/" 
version="1.0">
  <xsl:param name="mediafile" select="/ANNOTATION_DOCUMENT/HEADER/MEDIA_DESCRIPTOR/@EXTRACTED_FROM"/>
  <xsl:param name="creator" select="/ANNOTATION_DOCUMENT/@AUTHOR"/>
  <xsl:param name="language_code" select="/ANNOTATION_DOCUMENT/LOCALE/@LANGUAGE_CODE"/>
  <xsl:param name="country_code" select="/ANNOTATION_DOCUMENT/LOCALE/@COUNTRY_CODE"/>
  <xsl:param name="lang_code" select="concat($language_code, '-', $country_code)"/>
  <xsl:param name="date" select="/ANNOTATION_DOCUMENT/@DATE"/>
  <xsl:template match="/ANNOTATION_DOCUMENT">
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
        <meta>
          <!-- language code -->
          <xsl:attribute name="name">dc:language</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$lang_code"/>
          </xsl:attribute>
        </meta>
        <meta>
          <!-- Date -->
          <xsl:attribute name="name">dc:date</xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$date"/>
          </xsl:attribute>
        </meta>
      </header>

      <interlinear-text>
        <xsl:for-each select="TIER">
          <xsl:variable name="CUR_TIER" select="."/>
          <tier>
            <!-- Metadata per tier -->
            <xsl:attribute name="id">
              <xsl:value-of select="$CUR_TIER/@TIER_ID"/>
            </xsl:attribute>
            <xsl:attribute name="parent">
              <xsl:value-of select="$CUR_TIER/@PARENT_REF"/>
            </xsl:attribute>
            <xsl:attribute name="lang">
              <xsl:value-of select="$CUR_TIER/@DEFAULT_LOCALE"/>
            </xsl:attribute>
            <xsl:attribute name="participant">
              <xsl:value-of select="$CUR_TIER/@DPARTICIPANT"/>
            </xsl:attribute>
            <xsl:attribute name="linguistic_type">
              <xsl:value-of select="$CUR_TIER/@LINGUISTIC_TYPE_REF"/>
            </xsl:attribute>

            <!-- individual phrases -->
            <xsl:for-each select="ANNOTATION">
              <xsl:for-each select="ALIGNABLE_ANNOTATION">
                <phrase>
                  <xsl:variable name="startTimeId" select="@TIME_SLOT_REF1"/>
                  <xsl:variable name="endTimeId" select="@TIME_SLOT_REF2"/>
                  <xsl:variable name="startTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$startTimeId]/@TIME_VALUE"/>
                  <xsl:variable name="endTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$endTimeId]/@TIME_VALUE"/>
                  <xsl:variable name="Milliseconds_CONST" select="1000"/>
                  <xsl:variable name="startTime_Seconds" select="$startTime_VALUE div $Milliseconds_CONST"/>
                  <xsl:variable name="endTime_Seconds" select="$endTime_VALUE div $Milliseconds_CONST"/>

                  <xsl:attribute name="startTime">
                    <xsl:value-of select="$startTime_Seconds"/>
                  </xsl:attribute>
                  <xsl:attribute name="endTime">
                    <xsl:value-of select="$endTime_Seconds"/>
                  </xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="@ANNOTATION_ID"/>
                  </xsl:attribute>
                  <xsl:value-of select="ANNOTATION_VALUE"/>
                </phrase>
              </xsl:for-each>
            </xsl:for-each>

            <!-- also parse reference phrases -->
            <xsl:for-each select="ANNOTATION">
              <xsl:for-each select="REF_ANNOTATION">
                <phrase>
                  <xsl:variable name="refPhraseId" select="@ANNOTATION_REF"/>
                  <xsl:variable name="refPhrase" select="/ANNOTATION_DOCUMENT/TIER/ANNOTATION/ALIGNABLE_ANNOTATION[@ANNOTATION_ID=$refPhraseId]"/>
                  <xsl:variable name="startTimeId" select="$refPhrase/@TIME_SLOT_REF1"/>
                  <xsl:variable name="endTimeId" select="$refPhrase/@TIME_SLOT_REF2"/>
                  <xsl:variable name="startTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$startTimeId]/@TIME_VALUE"/>
                  <xsl:variable name="endTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$endTimeId]/@TIME_VALUE"/>
                  <xsl:variable name="Milliseconds_CONST" select="1000"/>
                  <xsl:variable name="startTime_Seconds" select="$startTime_VALUE div $Milliseconds_CONST"/>
                  <xsl:variable name="endTime_Seconds" select="$endTime_VALUE div $Milliseconds_CONST"/>

                  <xsl:attribute name="ref">
                    <xsl:value-of select="$refPhraseId"/>
                  </xsl:attribute>
                  <xsl:attribute name="startTime">
                    <xsl:value-of select="$startTime_Seconds"/>
                  </xsl:attribute>
                  <xsl:attribute name="endTime">
                    <xsl:value-of select="$endTime_Seconds"/>
                  </xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="@ANNOTATION_ID"/>
                  </xsl:attribute>
                  <xsl:value-of select="ANNOTATION_VALUE"/>
                </phrase>
              </xsl:for-each>
            </xsl:for-each>

          </tier>
        </xsl:for-each>
      </interlinear-text>

    </eopas>
  </xsl:template>
</xsl:stylesheet>
