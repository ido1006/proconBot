# coding: utf-8
require 'discordrb'
require 'yaml'

keys = YAML.load_file('./config.yml')
bot = Discordrb::Commands::CommandBot.new(
  token: keys['token'],
  client_id: keys['client_id'],
  prefix: '/',
)

bot.command :hello do |event|
  event.send_message("hello, #{event.user.name}.")
end

bot.run
