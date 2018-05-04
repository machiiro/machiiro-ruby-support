module YAML
  @cache = {}

  def self.load_file_in_cache(path)
    yaml = @cache[path]
    yaml = @cache[path] = YAML.load_file(path) if yaml.nil?
    yaml
  end
end
