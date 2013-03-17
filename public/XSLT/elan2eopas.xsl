<?xml version="1.0" encoding="UTF-8"?>
<!-- working with EOPAS 2.0 Schema -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:dc="http://purl.org/dc/elements/1.1/" 
version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="mediafile" select="/ANNOTATION_DOCUMENT/HEADER/MEDIA_DESCRIPTOR/@EXTRACTED_FROM"/>
  <xsl:param name="type" select="/ANNOTATION_DOCUMENT/HEADER/MEDIA_DESCRIPTOR/@MIME_TYPE"/>
  <xsl:param name="creator" select="/ANNOTATION_DOCUMENT/@AUTHOR"/>
  <xsl:param name="language_code" select="/ANNOTATION_DOCUMENT/LOCALE/@LANGUAGE_CODE"/>
  <xsl:param name="country_code" select="/ANNOTATION_DOCUMENT/LOCALE/@COUNTRY_CODE"/>
  <xsl:param name="lang_code" select="concat($language_code, '-', $country_code)"/>
  <xsl:param name="date" select="/ANNOTATION_DOCUMENT/@DATE"/>
  <xsl:template match="/">
    <xsl:if test="not(/ANNOTATION_DOCUMENT)">
        <xsl:message terminate="yes">ERROR: Not an ELAN document</xsl:message>
    </xsl:if>
    <xsl:if test="not(/ANNOTATION_DOCUMENT/HEADER/@TIME_UNITS = 'milliseconds')">
        <xsl:message terminate="yes">ERROR: I only understand milliseconds as TIME_UNITS</xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
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

      <interlinear>

        <xsl:choose>

        <!-- FIRST CASE: utterance and word tiers -->
        <!-- write a transcription if there are utterances -->
        <xsl:when test="TIER[@LINGUISTIC_TYPE_REF='utterance']">

          <!-- Get Phrases from utterances and sort them on their number -->
          <xsl:for-each select="TIER[@LINGUISTIC_TYPE_REF='utterance']/ANNOTATION/ALIGNABLE_ANNOTATION">
            <xsl:sort select="substring-after(@TIME_SLOT_REF1, 'ts')" data-type="number"/>

            <!-- grab phrase timing -->
            <xsl:variable name="startTimeId" select="@TIME_SLOT_REF1"/>
            <xsl:variable name="endTimeId" select="@TIME_SLOT_REF2"/>
            <xsl:variable name="startTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$startTimeId]/@TIME_VALUE"/>
            <xsl:variable name="endTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$endTimeId]/@TIME_VALUE"/>
            <xsl:variable name="Milliseconds_CONST" select="1000"/>
            <xsl:variable name="startTime_Seconds" select="$startTime_VALUE div $Milliseconds_CONST"/>
            <xsl:variable name="endTime_Seconds" select="$endTime_VALUE div $Milliseconds_CONST"/>

            <!-- write phrase -->
            <phrase>
              <xsl:attribute name="id">
                <xsl:value-of select="@ANNOTATION_ID"/>
              </xsl:attribute>
              <xsl:attribute name="startTime">
                <xsl:value-of select="$startTime_Seconds"/>
              </xsl:attribute>
              <xsl:attribute name="endTime">
                <xsl:value-of select="$endTime_Seconds"/>
              </xsl:attribute>

              <xsl:if test="normalize-space(parent::TIER/@DPARTICIPANT) != ''">
                <xsl:attribute name="participant">
                  <xsl:value-of select="parent::TIER/@DPARTICIPANT"/>
                </xsl:attribute>
              </xsl:if>
              <transcription>
                <xsl:value-of select="ANNOTATION_VALUE"/>
              </transcription>

              <!-- now we need to go through all the 'words' types tiers that belong to the
                   time frame between TIME_SLOT_REF1 and TIME_SLOT_REF2 and add them as <word> -->
              <xsl:if test="/ANNOTATION_DOCUMENT/TIER[@LINGUISTIC_TYPE_REF='words']">
                <wordlist>
                  <xsl:for-each select="/ANNOTATION_DOCUMENT/TIER[@LINGUISTIC_TYPE_REF='words']/ANNOTATION/ALIGNABLE_ANNOTATION">
                    <xsl:sort select="substring-after(@TIME_SLOT_REF1, 'ts')" data-type="number"/>

                    <xsl:variable name="wordStartTime" select="@TIME_SLOT_REF1"/>
                    <xsl:variable name="wordEndTime" select="@TIME_SLOT_REF2"/>
                    <xsl:variable name="word_startTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$wordStartTime]/@TIME_VALUE"/>
                    <xsl:variable name="word_endTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$wordEndTime]/@TIME_VALUE"/>

                    <xsl:if test="($word_startTime_VALUE &gt;= $startTime_VALUE) and ($word_endTime_VALUE &lt;= $endTime_VALUE)">
                      <word>
                        <text>
                          <xsl:value-of select="normalize-space(ANNOTATION_VALUE)"/>
                        </text>
                      </word>
                    </xsl:if>
                  </xsl:for-each>
                </wordlist>
              </xsl:if>

            </phrase>
          </xsl:for-each>
        </xsl:when>

        <!-- SECOND CASE: default-lt tier -->
        <!-- write a transcription tier -->
        <xsl:when test="TIER[@LINGUISTIC_TYPE_REF='default-lt']">

          <!-- Get Phrases from track and sort them on their number -->
          <xsl:for-each select="TIER[@LINGUISTIC_TYPE_REF='default-lt']/ANNOTATION/ALIGNABLE_ANNOTATION">
            <xsl:sort select="substring-after(@TIME_SLOT_REF1, 'ts')" data-type="number"/>

            <!-- grab phrase timing -->
            <xsl:variable name="startTimeId" select="@TIME_SLOT_REF1"/>
            <xsl:variable name="endTimeId" select="@TIME_SLOT_REF2"/>
            <xsl:variable name="startTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$startTimeId]/@TIME_VALUE"/>
            <xsl:variable name="endTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$endTimeId]/@TIME_VALUE"/>
            <xsl:variable name="Milliseconds_CONST" select="1000"/>
            <xsl:variable name="startTime_Seconds" select="$startTime_VALUE div $Milliseconds_CONST"/>
            <xsl:variable name="endTime_Seconds" select="$endTime_VALUE div $Milliseconds_CONST"/>

            <!-- write phrase -->
            <xsl:if test="ANNOTATION_VALUE != ''">
              <phrase>
                <xsl:attribute name="id">
                  <xsl:value-of select="@ANNOTATION_ID"/>
                </xsl:attribute>
                <xsl:attribute name="startTime">
                  <xsl:value-of select="$startTime_Seconds"/>
                </xsl:attribute>
                <xsl:attribute name="endTime">
                  <xsl:value-of select="$endTime_Seconds"/>
                </xsl:attribute>

                <xsl:if test="normalize-space(parent::TIER/@DPARTICIPANT) != ''">
                  <xsl:attribute name="participant">
                    <xsl:value-of select="parent::TIER/@DPARTICIPANT"/>
                  </xsl:attribute>
                </xsl:if>
                <transcription>
                  <xsl:value-of select="normalize-space(ANNOTATION_VALUE)"/>
                </transcription>
              </phrase>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>

        <!-- THIRD CASE: ref/tx/mr/mg/fg tiers -->
        <!-- write a transcription tier -->
        <xsl:when test="TIER[@LINGUISTIC_TYPE_REF='ref']">

          <!-- Get Phrases from track and sort them on their number -->
          <xsl:for-each select="TIER[@LINGUISTIC_TYPE_REF='ref']/ANNOTATION/ALIGNABLE_ANNOTATION">
            <xsl:sort select="substring-after(@TIME_SLOT_REF1, 'ts')" data-type="number"/>

            <!-- grab phrase timing -->
            <xsl:variable name="startTimeId" select="@TIME_SLOT_REF1"/>
            <xsl:variable name="endTimeId" select="@TIME_SLOT_REF2"/>
            <xsl:variable name="startTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$startTimeId]/@TIME_VALUE"/>
            <xsl:variable name="endTime_VALUE" select="/ANNOTATION_DOCUMENT/TIME_ORDER/TIME_SLOT[@TIME_SLOT_ID=$endTimeId]/@TIME_VALUE"/>
            <xsl:variable name="Milliseconds_CONST" select="1000"/>
            <xsl:variable name="startTime_Seconds" select="$startTime_VALUE div $Milliseconds_CONST"/>
            <xsl:variable name="endTime_Seconds" select="$endTime_VALUE div $Milliseconds_CONST"/>
            <xsl:variable name="annotationId" select="@ANNOTATION_ID"/>

            <!-- write phrase -->
            <xsl:if test="ANNOTATION_VALUE != ''">
              <phrase>
                <xsl:attribute name="id">
                  <xsl:value-of select="@ANNOTATION_ID"/>
                </xsl:attribute>
                <xsl:attribute name="startTime">
                  <xsl:value-of select="$startTime_Seconds"/>
                </xsl:attribute>
                <xsl:attribute name="endTime">
                  <xsl:value-of select="$endTime_Seconds"/>
                </xsl:attribute>

                <xsl:if test="normalize-space(parent::TIER/@DPARTICIPANT) != ''">
                  <xsl:attribute name="participant">
                    <xsl:value-of select="parent::TIER/@DPARTICIPANT"/>
                  </xsl:attribute>
                </xsl:if>
                <transcription>
                  <xsl:value-of select="normalize-space(ANNOTATION_VALUE)"/>
                </transcription>

                <!-- go through the 'tx' type tier to pick the words that belong to the
                     current phrase and add them as <word> -->
                <xsl:if test="/ANNOTATION_DOCUMENT/TIER[@LINGUISTIC_TYPE_REF='tx']">
                  <wordlist>
                    <xsl:for-each select="/ANNOTATION_DOCUMENT/TIER[@LINGUISTIC_TYPE_REF='tx']/ANNOTATION/REF_ANNOTATION[@ANNOTATION_REF = $annotationId]">
                        <word>
                          <text>
                            <xsl:value-of select="."/>
                          </text>
                          <xsl:variable name="wordId" select="@ANNOTATION_ID"/>

                          <!-- grab morphemes and gloss -->
                          <morphemelist>
                            <xsl:for-each select="/ANNOTATION_DOCUMENT/TIER[@LINGUISTIC_TYPE_REF='mr']/ANNOTATION/REF_ANNOTATION[@ANNOTATION_REF = $wordId]">
                              <xsl:variable name="morphemeId" select="@ANNOTATION_ID"/>
                              <morpheme>
                                <text>
                                  <xsl:attribute name="kind">morpheme</xsl:attribute>
                                  <xsl:value-of select="."/>
                                </text>
                                <text>
                                  <xsl:attribute name="kind">gloss</xsl:attribute>
                                  <xsl:value-of select="/ANNOTATION_DOCUMENT/TIER[@LINGUISTIC_TYPE_REF='mg']/ANNOTATION/REF_ANNOTATION[@ANNOTATION_REF = $morphemeId]"/>
                                </text>
                              </morpheme>
                            </xsl:for-each>
                          </morphemelist>
                        </word>
                    </xsl:for-each>
                  </wordlist>
                </xsl:if>

                <!-- go through the 'GRAID' type tier to pick the words that belong to the
                     current phrase and add them as <graid> -->
                <xsl:if test="/ANNOTATION_DOCUMENT/TIER[@LINGUISTIC_TYPE_REF='GRAID']">
                  <graid>
                    <xsl:for-each select="/ANNOTATION_DOCUMENT/TIER[@LINGUISTIC_TYPE_REF='GRAID']/ANNOTATION/REF_ANNOTATION[@ANNOTATION_REF = $annotationId]">
                      <!-- write phrase -->
                      <xsl:if test="ANNOTATION_VALUE != ''">
                            <xsl:value-of select="normalize-space(ANNOTATION_VALUE)"/>
                      </xsl:if>
                    </xsl:for-each>
                  </graid>
                </xsl:if>

                <!-- go through the 'fg' type tier to pick the words that belong to the
                     current phrase and add them as <translation> -->
                <xsl:if test="/ANNOTATION_DOCUMENT/TIER[@LINGUISTIC_TYPE_REF='fg']">
                  <translation>
                    <xsl:for-each select="/ANNOTATION_DOCUMENT/TIER[@LINGUISTIC_TYPE_REF='fg']/ANNOTATION/REF_ANNOTATION[@ANNOTATION_REF = $annotationId]">
                      <!-- write phrase -->
                      <xsl:if test="ANNOTATION_VALUE != ''">
                            <xsl:value-of select="normalize-space(ANNOTATION_VALUE)"/>
                      </xsl:if>
                    </xsl:for-each>
                  </translation>
                </xsl:if>

              </phrase>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>

        <!-- DEFAULT CASE: fail -->
        <xsl:otherwise>
          <xsl:message terminate="yes">ERROR: I only understand milliseconds as TIME_UNITS</xsl:message>
        </xsl:otherwise>

        </xsl:choose>

      </interlinear>
    </eopas>
  </xsl:template>
</xsl:stylesheet>
