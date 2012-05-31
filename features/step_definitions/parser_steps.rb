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

ならば /^送信元は"(#{CAPTURE_STRING})"となること$/ do |expected_sender|
  @output.sender.should == expected_sender
end

ならば /^受信先は"(#{CAPTURE_STRING})"となること$/ do |expected_receiver|
  @output.receiver.should == expected_receiver
end

ならば /^電文は"(#{CAPTURE_STRING})"となること$/ do |expected_message|
  @output.message.should == expected_message
end

ならば /^種類は呼び出しとなること$/ do
  @output.is_normal == true
end

ならば /^種類は応答となること$/ do
  @output.is_normal == false
end

ならば /^シーケンスは不正$/ do
  @output.should == nil
end

