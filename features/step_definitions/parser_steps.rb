# -*- encoding: UTF-8 -*-

CAPTURE_STRING = Transform /^.*?$/ do |str|
  str
end

前提 /^一行の文字列"(#{CAPTURE_STRING})"を入力する$/ do |input|
  @input = input
end

もし /^一行の文字列を解析する$/ do
  @output = Narabi::Message.parse_line(@input)
end

ならば /^送信元は"(#{CAPTURE_STRING})"となること$/ do |expected_from|
  @output[:from].should == expected_from
end

ならば /^受信先は"(#{CAPTURE_STRING})"となること$/ do |expected_to|
  @output[:to].should == expected_to
end

ならば /^受信先はnilとなること$/ do
  @output[:to].should be_nil
end

ならば /^電文は"(#{CAPTURE_STRING})"となること$/ do |expected_body|
  @output[:body].should == expected_body
end

ならば /^種類は呼び出しとなること$/ do
  @output[:is_return].should be_false
  @output[:is_note].should be_false
end

ならば /^種類は応答となること$/ do
  @output[:is_return].should be_true
  @output[:is_note].should be_false
end

ならば /^種類はノートとなること$/ do
  @output[:is_note].should be_true
end

ならば /^メッセージは不正$/ do
  @output.should == nil
end

もし /^一行のインスタンス文字列を解析する$/ do
  @output = Narabi::Instance.parse_line(@input)
end

ならば /^インスタンスは"(#{CAPTURE_STRING})"となること$/ do |expected_name|
  @output[:name].should == expected_name
end

もし /^一行のタイトル文字列を解析する$/ do
  @output = Narabi::Diagram.parse_line(@input)
end

ならば /^タイトルは"(#{CAPTURE_STRING})"となること$/ do |expected_title|
  @output[:title].should == expected_title
end

前提 /^次のエイリアスを含むテキストを入力する:$/ do |text|
  @input = text
  @output = []
end

もし /^エイリアスを含むテキストを解析する$/ do
  Narabi::Alias.scope do |parser|
    @input.each_line do |line|
      next if line.empty?

      if ret = parser.parse_line_for_instance(line)
        @output << ret
        next
      end
      if ret = parser.parse_line_for_message(line)
        @output << ret
        next
      end
      if ret = parser.parse_line_for_diagram(line)
        @output << ret
        next
      end
    end
  end
end

ならば /^次のハッシュの配列となる:$/ do |expected_lines|
  lines = []
  expected_lines.each_line { |l| lines << eval(l.strip) }
  @output.size.should == lines.size
  @output.each { |h| h.should == lines.shift }
end
