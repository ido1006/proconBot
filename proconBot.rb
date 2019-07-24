#####
# proconBot.rb
# This is a discord bot for my club members.
#
# coding: utf-8
#
# execute:
#   ruby proconBot.rb
#
# Copyright (c) 2019, K.Kanai
#####

require "discordrb"
require "net/http"
require "uri"
require "json"

class ProconBot
  attr_accessor :bot

  BOT_TOKEN = ENV["TOKEN"].freeze
  BOT_CLIENT_ID = ENV["CLIENT_ID"].freeze

  LIVEDOOR_WEATHER_API_HOST = "http://weather.livedoor.com/forecast/webservice/json/v1".freeze
  MISHIMA_CITY_ID = 220030

  def initialize
    @bot = Discordrb::Commands::CommandBot.new(client_id: BOT_CLIENT_ID, token: BOT_TOKEN, prefix: "!")
  end

  def start
    puts "This bot's invite URL is #{@bot.invite_url}"
    puts "Click on it to invite it to your server."

    commands

    @bot.run
  end

  def commands
    ### メンションに反応(形だけ) ###
    @bot.mention do |event|
      event.respond("なんだようるさいな")
    end

    ### ping ###
    @bot.command :ping do |event|
      m = event.respond("Pong")
      m.edit "Pong 応答時間は #{Time.now - event.timestamp}秒。"
    end

    ### 日にち ###
    @bot.command :date do |event|
      dn = DateTime.now
      dn = dn.new_offset(Rational(9,24))
      event.respond("今日は#{dn.year}年#{dn.month}月#{dn.day}日です。")
    end

    ### 時刻 ###
    @bot.command :time do |event|
      dn = DateTime.now
      dn = dn.new_offset(Rational(9,24))
      event.respond("今は#{dn.hour}時#{dn.min}分#{dn.sec}秒です。")
    end

    ### サイコロ ###
    @bot.command :dice do |event, max|
      event.respond(dice_message(max: max))
    end

    ### 天気 ###
    @bot.command :weather do |event|
      event.respond(weather_message)
    end

    ### S先生の語録 ###
    @bot.command :serizawa do |event, first, second|
      event.respond(serizawa_message(first: first, second: second))
    end

    ### 音楽語録 ###
    @bot.command :musicwords do |event|
      event.respond(musicwords_message)
    end

    ### ヘルプ ###
    @bot.command :help do |event|
      event.respond(help_message)
    end
  end

  ### サイコロの文 ###
  def dice_message(max: nil)
    max ||= 6
    max = max.to_i.abs
    val = rand(1..max)
    "d#{max} = #{val}"
  end

  ### 天気の取得、作文 ###
  def weather_message
    uri = URI.parse("#{LIVEDOOR_WEATHER_API_HOST}?city=#{MISHIMA_CITY_ID}")
    response = Net::HTTP.get_response(uri)
    res_json = JSON.parse(response.body)

    city = res_json.dig("location","city")
    forecasts = res_json["forecasts"]

    message = ""
    forecasts.each { |f|
      max_temperature = f.dig("temperature","max","celsius")
      message += "#{f["dateLabel"]}（#{f["date"]}）の#{city}の天気は「#{f["telop"]}」"
      message += "、最高気温は#{max_temperature}℃" unless max_temperature.nil?
      message += "\n"
    }
    message
  end

  ### S先生語録の作文 ###
  def serizawa_message(first: nil, second: nil)
    first ||= "勉強"
    second ||= "ゲーム"
    message  = "みんな大丈夫かなぁ〜？\n"
    message += "ちゃんと#{first}やってる？\n"
    message += "#{second}なんかにハマってないよね？\n"

    message
  end

  ### 音楽語録の作文 ###
  def musicwords_message
    message = "めんどくさいので工事中、誰か書いて"
    message
  end

  ### へるぷ ###
  def help_message
    message  = "!ping : 速度チェック。\n"
    message += "!date : 日にちをお伝えします。\n"
    message += "!time : 時間をお伝えします。\n"
    message += "!dice : サイコロを振ります。引数があると、それを最大値とします。\n"
    message += "!weather : 天気をお伝えします。\n"
    message += "!serizawa : 芹沢語録をお伝えします。引数があると、それを元にします。\n"
    message += "!musicwords : 音楽語録をお伝えしたいです。\n"
    message += "!help : これです。\n"
    message += "SourceCode -> `https://github.com/ido1006/proconBot`\n"
  end

end

proconBot = ProconBot.new
proconBot.start
