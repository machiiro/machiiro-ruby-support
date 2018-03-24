# モデル基底モジュール
#
class Module
  def attr_json_fields(*names)
    names.each do |name|
      define_method(name) do
        v = read_attribute(name)
        return v if v.is_a?(HashWithIndifferentAccess)
        HashWithIndifferentAccess.new(v)
      end
    end
  end
end
