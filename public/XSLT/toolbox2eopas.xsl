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
    <xsl:if test="not(/database)">
        <xsl:message terminate="yes">ERROR: Not a Toolbox document</xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/database">
    <eopas>
      <header>
        <meta>
          <!-- MIME Type -->
          <xsl:attribute name="name">dc:type</xsl:attribute>
          <xsl:attribute name="value">text/xml</xsl:attribute>
        </meta>
        <meta>
          <!-- MIME Type -->
          <xsl:attribute name="name">dc:contributor</xsl:attribute>
          <xsl:attribute name="value"><xsl:value-of select="/database/itmgroup/nt/text()"/></xsl:attribute>
        </meta>
      </header>

      <interlinear>
        <!-- for each "itmGroup" and "itmgroup" -->
        <!-- normally there is only one such element in the file -->
        <xsl:for-each select="itmgroup">

          <!-- individual phrases -->
          <xsl:for-each select="idgroup">
            <xsl:if test="normalize-space(txgroup) != ''">
              <phrase>
                <!-- get start and end time -->
                <xsl:variable name="s" select="aud"/>
                <xsl:variable name="delimiter" select="' '"/>
                <xsl:variable name="partOnly" select="substring-after(normalize-space($s), $delimiter)"/>
                <xsl:variable name="timeOnly">
                  <xsl:choose>
                    <xsl:when test="contains(substring-after($partOnly, $delimiter), $delimiter)">
                      <xsl:value-of select="substring-after($partOnly, $delimiter)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$partOnly"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="startTime">
                  <xsl:variable name="startTime" select="substring-before($timeOnly, $delimiter)"/>
                  <xsl:value-of select="$startTime"/>
                </xsl:attribute>
                <xsl:attribute name="endTime">
                  <xsl:variable name="endTime" select="substring-after($timeOnly, $delimiter)"/>
                  <xsl:value-of select="$endTime"/>
                </xsl:attribute>

                <!-- the identifier has to be unique -->
                <xsl:variable name="o_ident" select="id"/>
                <xsl:attribute name="id"><xsl:value-of select="translate($o_ident,':','-')"/>_<xsl:value-of select="count(preceding::idgroup)+1"/></xsl:attribute>

                <!-- compose text together -->
                <!-- for each "txGroup" and "txgroup" -->
                <transcription>
                  <xsl:for-each select="txgroup/tx">
                    <xsl:value-of select="concat(., ' ')"></xsl:value-of>
                  </xsl:for-each>
                </transcription>

                <!-- add words decomposition -->
                <wordlist>
                  <xsl:for-each select="*[tx]">
                    <word>
                      <xsl:for-each select="tx">
                        <text>
                          <xsl:value-of select="."/>
                        </text>
                      </xsl:for-each>
                      <xsl:if test="mr">
                        <morphemelist>
                          <xsl:for-each select="mr">
                            <xsl:variable name="pos" select="position()"></xsl:variable>
                            <morpheme>
                              <text kind="morpheme">
                                <xsl:value-of select="."/>
                              </text>
                              <text kind="gloss">
                                <xsl:value-of select="../mg[$pos]"/>
                              </text>
                            </morpheme>
                          </xsl:for-each>
                        </morphemelist>
                      </xsl:if>
                    </word>
                  </xsl:for-each>
                </wordlist>

                <!-- add translation -->
                <translation>
                  <xsl:value-of select="fg/text()"/>
                </translation>
              </phrase>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </interlinear>

    </eopas>
  </xsl:template>
</xsl:stylesheet>
