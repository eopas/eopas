# FIx a bug in paperclip http://github.com/thoughtbot/paperclip/issues/issue/137
module Paperclip
  class Style
    def initialize name, definition, attachment
      @name = name
      @attachment = attachment
      if definition.is_a? Hash
        definition = definition.dup
        @geometry = definition.delete(:geometry)
        @format = definition.delete(:format)
        @processors = definition.delete(:processors)
        @other_args = definition
      else
        @geometry, @format = [definition, nil].flatten[0..1]
        @other_args = {} 
      end
      @format  = nil if @format.blank?
    end
  end
end


