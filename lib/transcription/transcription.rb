
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

class Transcription

  def initialize(options = {})
    @data = options[:data]
    @format = options[:format]
  end

  def validate

    # load Schema file
    xsdname = "lib/transcription/SCHEMAS/#@format.xsd"
    @xsd = Nokogiri::XML::Schema(File.open(xsdname))

    # parse XML file
    @doc = Nokogiri::XML(@data)

    # validate doc and print errors
    @errors = @xsd.validate(@doc)

  end

  def errors
    @errors
  end

  def valid?
    @xsd.valid?(@doc)
  end


end