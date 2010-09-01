class TranscriptsController < ApplicationController
  respond_to :xml

  def eopas_format
    # USED THIS TO IMPORT A RANDOM FILE
    # todo fix up the import somewhere else
    #file = "features/test_data/eopas1.xml"
    #media_item = MediaItem.find(:first)
    #tran = File.read("#{file}")
    #@transcription = Transcription.new(:data => tran, :format => :eopas, :media_item => media_item)
    #@transcription.save_eopas(:file => "#{file}", :media_item => media_item, :depositor => current_user)

    # todo don't just render the first one
    @transcript = Transcript.find(:first)

    # todo write the file somewhere for further export transcoding
    #xml = render_to_string :content_type => 'text/xml', :layout => false
    #File.open("features/test_data/export_eopas.xml", 'w') {|f| f.write(xml) }
    render :content_type => 'text/xml', :layout => false
  end
end
