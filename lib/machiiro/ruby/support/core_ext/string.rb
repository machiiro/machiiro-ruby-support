class String
  COLORS = {
    bold: '1',
    underscore: '4',
    black: '30',
    red: '31',
    green: '32',
    yellow: '33',
    blue: '34',
    magenta: '35',
    cyan: '36',
    white: '37',
    bg_black: '40',
    bg_red: '41',
    bg_green: '42',
    bg_yellow: '43',
    bg_blue: '44',
    bg_magenta: '45',
    bg_cyan: '46',
    bg_white: '47'
  }.freeze

  def present_lines
    each_line.map(&:chomp).select(&:present?)
  end

  def integer?
    !!Integer(self)
  rescue ArgumentError, TypeError
    false
  end

  def half
    tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  end

  def kana_half
    NKF.nkf('-w -x -Z4', self).tr('　', ' ')
  end

  def kana_half_up
    s = kana_half.upcase
    s.tr('ｧ', 'ｱ')
     .tr('ｨ', 'ｲ')
     .tr('ｩ', 'ｳ')
     .tr('ｪ', 'ｴ')
     .tr('ｫ', 'ｵ')
     .tr('ｯ', 'ﾂ')
     .tr('ｬ', 'ﾔ')
     .tr('ｭ', 'ﾕ')
     .tr('ｮ', 'ﾖ')
  end

  def nl2br
    gsub("\n", '<br />')
  end

  def lowercamel
    camelize.sub(/./) { $&.downcase }
  end

  def hyphencase
    underscore.tr('_', '-')
  end

  def colorize(name)
    return self if name.nil?
    "\e[#{COLORS[name]}m#{self}\e[0m"
  end

  def adjust_slash
    start_with?('/') ? self : "/#{self}"
  end

  def encode_safe(to_encoding = Encoding::UTF_8)
    return self if encoding == to_encoding
    encode(encoding, to_encoding, invalid: :replace, undef: :replace, replace: '?').encode(to_encoding)
  end

  def eval_erb(vars = {})
    b = OpenStruct.new(vars).instance_eval { binding }
    ERB.new(self, nil, '-').result(b)
  end

  def eval_formula(vars = {})
    vars = ActiveSupport::HashWithIndifferentAccess.new(vars)

    result = self
    scan(/\${([^0-9]\w+)}/).each do |groups|
      key = groups[0]
      result = result.gsub("${#{key}}", (vars[key.to_sym] || '').to_s)
    end

    # 式展開してみる
    begin
      result = eval('"#{' + result + '}"')
    rescue SyntaxError => _
    rescue StandardError => _
    end

    result
  end
end
