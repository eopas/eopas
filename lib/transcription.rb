
# provides functions to deal with import and export of
# interlinear text files in different formats

# validate
# transcode to EOPAS format
# import from EOPAS format into DB
# export to EOPAS format from DB
# transcode from EOPAS format

# supported formats:
# - elan
# - toolbox
# - transcriber

require 'nokogiri'
require 'fileutils'
require 'xml-object'
require 'xml-object/adapters/libxml'

class Transcription

  def initialize(options = {})
    @data = options[:data]
    @format = options[:format].downcase

    # parse XML file
    @doc = Nokogiri::XML(@data)
  end

  def validate
    # load Schema file
    xsdname = "#{Rails.root}/public/SCHEMAS/#@format.xsd"
    @xsd = Nokogiri::XML::Schema(File.open(xsdname))

    # validate doc and print errors
    @errors = @xsd.validate(@doc)
  end

  def errors
    @errors
  end

  def valid?
    @xsd.valid?(@doc)
  end

  def to_eopas
    # load correct XSLT
    xsltname = "#{Rails.root}/public/XSLT/#{@format}2eopas.xsl"
    @xslt  = Nokogiri::XSLT(File.open(xsltname))

    # transcode XML file
    @e_doc = @xslt.transform(@doc)

    # transcoding failed and just produced:
    # <?xml version="1.0" encoding="UTF-8"?>
    return if @e_doc == '<?xml version="1.0" encoding="UTF-8"?>'

    @e_doc.to_s
  end

  def import(transcript)
    eopas_xml = to_eopas
    eopas = XMLObject.new(eopas_xml)

    metas = eopas.header.meta
    metas = [metas] unless metas.is_a? Array
    metas.each do |meta|
      case meta.name
      when "dc:creator"
        transcript.creator = meta.value
      when "dc:language"
        transcript.language_code = meta.value
      when "dc:date"
        transcript.date = meta.value
      end
    end

    tiers = eopas.interlinear.tier
    tiers = [tiers] unless tiers.is_a? Array
    tiers.each do |tier|
      # create new tier
      t = transcript.tiers.build
      begin
        t.tier_id         = tier.id
      rescue NameError
      end
      begin
        t.language_code   = tier.lang
      rescue NameError
      end
      begin
        t.linguistic_type = tier.linguistic_type
      rescue NameError
      end
      begin
        t.parent = transcript.tiers.select{|tt| tt.tier_id == tier.parent}.first
      rescue NameError
      end

      phrases = tier.phrase
      phrases = [phrases] unless phrases.is_a? Array
      phrases.each do |phrase|
        # create new phrase
        ph = t.phrases.build
        begin
          ph.phrase_id       = phrase.id
        rescue NameError
        end
        ph.start_time      = phrase.startTime.to_f
        ph.end_time        = phrase.endTime.to_f
        begin
          ph.ref_phrase      = phrase.ref
        rescue NameError
        end
        begin
          ph.participant     = phrase.participant
        rescue NameError
        end
        begin
          ph.text            = phrase.text
        rescue NameError
        end
        ph.words           = []

        begin
          words = phrase.wordlist.word
        rescue NameError => e
          words = []
        end
        words = [words] unless words.is_a? Array

        words.each do |word|
          new_word = {:text => word.text + "", :morphemes => {} }

          begin
            morphemes = word.morphemelist.morpheme
          rescue NameError => e
            morphemes = []
          end
          morphemes = [morphemes] unless morphemes.is_a? Array

          morphemes.each do |morpheme|
            texts = morpheme.text
            texts.each do |text|
              new_word[:morphemes][text.kind + ""] ||= []
              new_word[:morphemes][text.kind + ""] << (text + "")
            end
          end
          ph.words << new_word
        end
      end
    end
  end
end
