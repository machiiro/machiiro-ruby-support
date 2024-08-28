module YAML
  @cache = {}

  # 外部から混入される危険性がないと分かっていて、safe_load_file ではチェックが
  # 厳しすぎて load できない場合に use_unsafe_load: true を指定できる
  def self.load_file_in_cache(path, use_unsafe_load: false)
    load_method = use_unsafe_load ? :unsafe_load_file : :load_file
    yaml = @cache[path]
    yaml = @cache[path] = YAML.public_send(load_method, path) if yaml.nil?
    yaml
  end
end
