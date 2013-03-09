class CountryLanguage < Struct.new(:code, :name)

  @@country_languages = {}

  def self.country_languages
    @@country_languages
  end

  def self.setup_languages
    data = File.open("#{Rails.root}/data/LanguageIndex.tab", "rb").read
    data.encode!('UTF-8', 'ISO-8859-1')
    data.each_line do |line|
      next if line =~ /^LangID/
        code, country_code, name_type, name = line.strip.split("\t")
      next unless name_type == "L"
      @@country_languages[country_code] ||= {}
      @@country_languages[country_code][code] = name
    end
  end

  setup_languages

  def self.find_by_country_code_and_code(country_code, code)
    new(code, "#{@@country_languages[country_code][code]} (#{code})")
  end

  def self.find_all_by_country_code(country_code)
    results = []
    return results unless @@country_languages[country_code]
    @@country_languages[country_code].keys.each do |code|
      results << find_by_country_code_and_code(country_code, code)
    end
    results
  end

end
