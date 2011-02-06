class Participant < ActiveRecord::Base
  belongs_to :transcript

  ROLES = %w(
    annotator artist author compiler consultant data_inputter depositor
    developer editor illustrator interviewer participant performer
    photographer recorder researcher respondent speaker signer singer sponsor
    transcriber translator
  )

  validates :name, :presence => true
  validates :role, :inclusion => {:in => ROLES}
  validates :transcript, :associated => true

end
