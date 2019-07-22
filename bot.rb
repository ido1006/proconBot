# coding: utf-8
require 'discordrb'
require 'date'

bot = Discordrb::Commands::CommandBot.new(
  token: ENV['TOKEN'],
  client_id: ENV['CLIENT_ID'],
  prefix: '!',
)

dn = DateTime.now

bot.command :hello do |event|
  event.send_message("#{event.user.name}さん、こんにちは！")
end

bot.command :date do |event|
  event.send_message("今日は#{dn.year}年#{dn.month}月#{dn.day}日です。")
end

bot.command :time do |event|
  event.send_message("今は#{dn.hour}時#{dn.min}分#{dn.sec}秒です。")
end

bot.run
