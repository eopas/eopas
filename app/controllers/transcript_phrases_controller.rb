class TranscriptPhrasesController < ApplicationController

  def index
    @type = params[:type]
    @search = params[:search]
    language_code = params[:language_code]

    case @type
    when 'morpheme'
      @phrases = TranscriptPhrase.joins('
          INNER JOIN transcript_words ON transcript_words.transcript_phrase_id = transcript_phrases.id
          INNER JOIN transcript_morphemes ON transcript_morphemes.transcript_word_id = transcript_words.id
          INNER JOIN transcripts ON transcripts.id = transcript_phrases.transcript_id
      ').where('transcript_morphemes.morpheme' => @search).where('transcripts.language_code' => language_code)
    when 'word'
      @phrases = TranscriptPhrase.joins('
          INNER JOIN transcript_words ON transcript_words.transcript_phrase_id = transcript_phrases.id
          INNER JOIN transcripts ON transcripts.id = transcript_phrases.transcript_id
      ').where('transcript_words.word' => @search).where('transcripts.language_code' => language_code)
    end

    @phrases.sort_by(&:id).each {|p| p p.id}
    respond_to do |format|
      format.js { render :partial => "concordance" }
    end

  end
end
