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

The following mapping is done:
* itmgroup          -> tier@linguistic_type['transcription']
* idgroup           ->   phrase
* concat txgroup/tx ->     text
* txgroup           ->     wordlist
* tx                ->       word/text
* mr                ->         morphemelist/morpheme/text@kind['morpheme']
* mg                ->         morphemelist/morpheme/text@kind['gloss']
* fg                -> tier@linguistic_type['translation']/phrase/text

The above example gets transformed into EOPAS:

<?xml version="1.0" encoding="UTF-8"?>
<eopas xmlns:dc="http://purl.org/dc/elements/1.1/">
  <header>
    <meta name="dc:type" value="text/xml"/>
    <meta name="dc:contributor" value="Narrator"/>
  </header>
  <interlinear>
    <tier id="o_107" linguistic_type="transcription">
      <phrase endTime="5.465" startTime="0.020" id="o_107:001">
        <text>Amurin </text>
        <wordlist>
          <word>
            <text>Amurin</text>
            <morphemelist>
              <morpheme>
                <text kind="morpheme">a=</text>
                <text kind="gloss">1S.RS=</text>
              </morpheme>
              <morpheme>
                <text kind="morpheme">mur</text>
                <text kind="gloss">want</text>
              </morpheme>
              <morpheme>
                <text kind="morpheme">-i</text>
                <text kind="gloss">-TS</text>
              </morpheme>
              <morpheme>
                <text kind="morpheme">-n</text>
                <text kind="gloss">-3S.O</text>
              </morpheme>
            </morphemelist>
          </word>
        </wordlist>
      </phrase>
    </tier>
    <tier id="fg_107" linguistic_type="translation">
      <phrase startTime="0.020" endTime="5.465" id="fg_107:001">
        <text>I want to tell you. You, children of today,</text>
      </phrase>
    </tier>
  </interlinear>
</eopas>

Notice how there is a transcription and a translation tier.
These are the only tiers that the EOPAS system cares about.


2. ELAN
=======
XML Schema Definitions are e.g. at http://www.mpi.nl/tools/elan/EAFv2.7.xsd

A typical example file:

<?xml version="1.0" encoding="UTF-8"?>
<ANNOTATION_DOCUMENT xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" DATE="2006-10-16T11:59:34+10:00" AUTHOR="" VERSION="2.3" FORMAT="2.3">
    <HEADER MEDIA_FILE="" TIME_UNITS="milliseconds">
        <MEDIA_DESCRIPTOR MEDIA_URL="file:///D:/Data/elan/elan-example1.mpg" MIME_TYPE="video/mpeg"/>
    </HEADER>
    <TIME_ORDER>
        <TIME_SLOT TIME_SLOT_ID="ts1" TIME_VALUE="0"/>
        <TIME_SLOT TIME_SLOT_ID="ts2" TIME_VALUE="280"/>
        <TIME_SLOT TIME_SLOT_ID="ts3" TIME_VALUE="440"/>
        <TIME_SLOT TIME_SLOT_ID="ts4" TIME_VALUE="780"/>
        <TIME_SLOT TIME_SLOT_ID="ts5" TIME_VALUE="1250"/>
        <TIME_SLOT TIME_SLOT_ID="ts6" TIME_VALUE="1340"/>
        <TIME_SLOT TIME_SLOT_ID="ts7" TIME_VALUE="1570"/>
        <TIME_SLOT TIME_SLOT_ID="ts8" TIME_VALUE="1600"/>
        <TIME_SLOT TIME_SLOT_ID="ts9" TIME_VALUE="1810"/>
        <TIME_SLOT TIME_SLOT_ID="ts10" TIME_VALUE="2000"/>
        [further <TIME_SLOT/>]
    </TIME_ORDER>
    <TIER TIER_ID="NeparrŋaGumbula" PARTICIPANT="Neparrŋa Gumbula" LINGUISTIC_TYPE_REF="utterance" DEFAULT_LOCALE="en">
        <ANNOTATION>
            <ALIGNABLE_ANNOTATION ANNOTATION_ID="a1" TIME_SLOT_REF1="ts2" TIME_SLOT_REF2="ts5">
                <ANNOTATION_VALUE>so from here.</ANNOTATION_VALUE>
            </ALIGNABLE_ANNOTATION>
        </ANNOTATION>
        [further <ANNOTATION></ANNOTATION>]
    </TIER>
    <TIER DEFAULT_LOCALE="en" LINGUISTIC_TYPE_REF="utterance" PARTICIPANT="" TIER_ID="W-Spch">
        <ANNOTATION>
            <ALIGNABLE_ANNOTATION ANNOTATION_ID="a8" TIME_SLOT_REF1="ts4" TIME_SLOT_REF2="ts23">
                <ANNOTATION_VALUE>so you go out of the Institute to the Saint Anna Straat.</ANNOTATION_VALUE>
            </ALIGNABLE_ANNOTATION>
        </ANNOTATION>
        [further <ANNOTATION></ANNOTATION>]
    </TIER>
    [further <TIER></TIER>]
    <LINGUISTIC_TYPE LINGUISTIC_TYPE_ID="utterance" TIME_ALIGNABLE="true" GRAPHIC_REFERENCES="false"/>    
    <LOCALE COUNTRY_CODE="US" LANGUAGE_CODE="en"/>
    <CONSTRAINT DESCRIPTION="Time subdivision of parent annotation's time interval, no time gaps allowed within this interval" STEREOTYPE="Time_Subdivision"/>
    <CONSTRAINT DESCRIPTION="Symbolic subdivision of a parent annotation. Annotations refering to the same parent are ordered" STEREOTYPE="Symbolic_Subdivision"/>
    <CONSTRAINT DESCRIPTION="1-1 association with a parent annotation" STEREOTYPE="Symbolic_Association"/>
    <CONSTRAINT DESCRIPTION="Time alignable annotations within the parent annotation&apos;s time interval, gaps are allowed" STEREOTYPE="Included_In"/>
</ANNOTATION_DOCUMENT>

The following LINGUISTIC_TYPE tiers have been seen in the wild:
* utterance
* words
* part of speech
* phonetic_transcription
* gestures
* gesture_phases
* gesture_meaning
* ref
* tx
* mr
* mg
* fg

The EOPAS system will only make use of the following tiers with the following mapping:
* utterance (last one)   -> tier@linguistic_type['transcription']/phrase/text
* words                  ->   phrase/wordlist/word/text
OR:
* ref               -> tier@linguistic_type['transcription']/phrase/text
* tx                ->   phrase/wordlist/word/text
* mr                ->   phrase/wordlist/word/morphemelist/morpheme/text@kind['morpheme']
* mg                ->   phrase/wordlist/word/morphemelist/morpheme/text@kind['gloss']
* fg                -> tier@linguistic_type['translation']/phrase/text



3. Transcriber
==============