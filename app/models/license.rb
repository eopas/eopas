class License < Struct.new(:code, :name)
  LICENSES = {
    "PD"             => ["Public Domain", "http://creativecommons.org/publicdomain/"],
    "CC-AU-BY"       => ["CC Attribution", "http://creativecommons.org/licenses/by/3.0/au/"],
    "CC-AU-BY-SA"    => ["CC Attribution Share-alike", "http://creativecommons.org/licenses/by-sa/3.0/au/"],
    "CC-AU-BY-ND"    => ["CC Attribution No derivative works", "http://creativecommons.org/licenses/by-nd/3.0/au/"],
    "CC-AU-NC-BY"    => ["CC Noncommercial Attribution", "http://creativecommons.org/licenses/by-nc/3.0/au/"],
    "CC-AU-NC-BY-SA" => ["CC Noncommercial Attribution Share-alike", "http://creativecommons.org/licenses/by-nc-sa/3.0/au/"],
    "CC-AU-NC-BY-ND" => ["CC Noncommercial Attribution No derivative works", "http://creativecommons.org/licenses/by-nc-nd/3.0/au/"]
  }

    def self.find(code)
        new(code, "#{code}  #{LICENSES[code][1]}")
    end

    def self.all
        results = []
        LICENSES.each do |code, name|
          results << new(code, "#{code}  #{name[1]}")
        end
        results
    end
end
