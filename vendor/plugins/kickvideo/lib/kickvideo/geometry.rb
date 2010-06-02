module Kickvideo
  # TODO: trim up Paperclip's Geometry class instead?
  class Geometry
    attr_reader :width, :height
    
    def initialize(w, h)
      @width, @height = w.to_f, h.to_f
    end
    
    def aspect
      if full?
        4.0/3
      elsif wide?
        16.0/9
      else
        ratio
      end
    end
    
    def ratio
      width / height
    end
    
    def full?
      (ratio - 4.0/3).abs < 0.02
    end
    
    def wide?
      (ratio - 16.0/9).abs < 0.02
    end
  end
end
