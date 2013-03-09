
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

class Transcription

  def initialize(options = {})
    @data = options[:data]
    @format = options[:format].downcase

    @errors = []

    # parse XML file
    @doc = Nokogiri::XML(@data)

    # fix different types of toolbox files before trying transcode
    if @format == "toolbox"
      xsltname = "#{Rails.root}/public/XSLT/fixToolbox.xsl"
      @xslt  = Nokogiri::XSLT(File.open(xsltname))
      @doc = @xslt.transform(@doc)
    end
  end

  def validate
    # load Schema file
    xsdname = "#{Rails.root}/public/SCHEMAS/#@format.xsd"
    begin
      @xsd = Nokogiri::XML::Schema(File.open(xsdname))
    rescue Nokogiri::XML::SyntaxError => e
      @errors << e
    end

    # validate doc and print errors
    if @xsd
      @errors += @xsd.validate(@doc)
    end

    @errors
  end

  def errors
    @errors
  end

  def valid?
    @xsd.valid?(@doc) and @errors.nil?
  end

  def to_eopas
    # load correct XSLT
    xsltname = "#{Rails.root}/public/XSLT/#{@format}2eopas.xsl"
    @xslt  = Nokogiri::XSLT(File.open(xsltname))

    # transcode XML file
    begin
      e_doc = @xslt.transform(@doc)
    rescue RuntimeError => e
      @errors << e
      return
    end


    # transcoding failed and just produced:
    # <?xml version="1.0" encoding="UTF-8"?>
    if e_doc == '<?xml version="1.0" encoding="UTF-8"?>'
      @errors << 'ERROR: Empty XML returned'
      return
    end

    e_doc
  end

  def import(transcript)
    doc = to_eopas
    return if doc.nil?
    eopas = doc.xpath('/eopas')

    metas = eopas.xpath('//meta')
    metas.each do |meta|
      case meta['name']
      # TODO put this back somehow
      when "dc:creator"
        if !meta['value'].empty?
          pa = transcript.participants.build
          pa.role = "creator"
          pa.name = meta['value']
          pa.transcript = transcript
        end
      when "dc:language"
        transcript.language_code = meta['value']
      when "dc:date"
        transcript.date = meta['value']
      end
    end

    phrases = eopas.xpath('interlinear/phrase')
    phrases.each do |phrase|
      # create new phrase
      ph = transcript.phrases.build

      ph.phrase_id  = phrase['id'].gsub(/.*_/, '')
      ph.start_time = phrase['startTime'].to_f
      ph.end_time   = phrase['endTime'].to_f

      import_phrase phrase, ph
    end
  end

  private
  def import_phrase(phrase, ph)
    ph.original = phrase.xpath('transcription').first.content
    unless phrase.xpath('graid').empty?
      ph.graid = phrase.xpath('graid').first.content
    end
    unless phrase.xpath('translation').empty?
      ph.translation = phrase.xpath('translation').first.content
    end
    words = phrase.xpath('wordlist/word')

    word_position = 1
    words.each do |word|
      w = ph.words.build
      w.position = word_position
      word_position += 1
      w.word = word.xpath('text').first.content

      morphemes = word.xpath('morphemelist/morpheme')

      morpeheme_position = 1
      morphemes.each do |morpheme|
        m = w.morphemes.build
        m.position = morpeheme_position
        morpeheme_position += 1

        texts = morpheme.xpath('text')
        texts.each do |text|
          case text['kind']
          when 'morpheme'
            m.morpheme = text.content
          when 'gloss'
            m.gloss = text.content
          else
            @errors << Struct.new(:message).new("Unknown text kind #{text['kind']}")
            next
          end
        end
      end
    end
  end

end
