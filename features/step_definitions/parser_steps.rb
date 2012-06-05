# -*- encoding: UTF-8 -*-

CAPTURE_STRING = Transform /^.*?$/ do |str|
  str
end

前提 /^一行の文字列"(#{CAPTURE_STRING})"を入力する$/ do |input|
  @input = input
end

もし /^一行の文字列を解析する$/ do
  @output = Narabi.parse_line(@input)
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

ならば /^電文は"(#{CAPTURE_STRING})"となること$/ do |expected_message|
  @output[:message].should == expected_message
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

ならば /^インスタンスは"(.*?)"となること$/ do |expected_name|
  @output[:name].should == expected_name
end
