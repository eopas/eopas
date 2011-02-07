HANDLING TRANSCRIPTS
====================

EOPAS has been set up to take as input files of four different formats:
* ELAN
* Transcriber
* Toolbox
The XML Schema specifications of the used file formats are available in public/SCHEMAS/ .

These formats are very flexible, but EOPAS has a very specific goal:
to display phrases of spoken text in a time-synchronised manner with the video or audio
during which they are spoken. For the phrases EOPAS further provides a translation and
a segmentation of the phrase into words, morphemes and gloss.

Therefore, only input files of specific formatting will work.
For others, the system will only do a best effort.

Further we have developed an EOPAS native XML format, which can be used for imports and exports.
It exists because we import into the EOPAS system by transcoding from the other formats to the
EOPAS native format first using XSL transforms. The transforms can be found in public/XSLT/ .

This documentation describes what formatting of the files work and how we degrade for other formatting.


1. Toolbox
==========
An example file that works well:

<?xml version="1.0" encoding="UTF-8"?>
<database>
  <itmgroup>
    <itm>107</itm>
    [optional <nt>Narrator</nt>]
    <idgroup>
      <id>107:001</id>
      <aud>file start end</aud>
      <txgroup>
        <tx>Amurin</tx>
        <mr>a=</mr>
        <mg>1S.RS=</mg>
        <mr>mur</mr>
        <mg>want</mg>
        <mr>-i</mr>
        <mg>-TS</mg>
        <mr>-n</mr>
        <mg>-3S.O</mg>
      </txgroup>
      [further <txgroup></txgroup>]
      <fg>I want to tell you. You, children of today,</fg>
    </idgroup>
    [further <idgroup></idgroup>]
  </itmgroup>
</database>

Some Toolbox files use camel-case on element and attribute names.
Others come with a namespace of "tb:" on all the elements.
These differences will be removed using a clean-up script called fixToolbox.xsl.




2. ELAN
=======


3. Transcriber
==============