# coding: utf-8
require 'discordrb'

bot = Discordrb::Commands::CommandBot.new(
  token: ENV['TOKEN'],
  client_id: ENV['CLIENT_ID'],
  prefix: '/',
)

bot.command :hello do |event|
  event.send_message("hello, #{event.user.name}.")
end

bot.run
