# モデル基底モジュール
#
class Module
  def attr_json_fields(*names)
    names.each do |name|
      define_method(name) do
        v = read_attribute(name)

        if v.is_a?(Hash)
          return HashWithIndifferentAccess.new(v)
        elsif v.is_a?(Array)
          return v.map { |e| e.is_a?(Hash) ? HashWithIndifferentAccess.new(e) : e }
        end

        v
      end
    end
  end
end
