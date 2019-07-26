# coding: utf-8
#####
# proconBot.rb
# This is a discord bot for my club members.
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
    @bot.command :musicwords do |event, letter|
      event.respond(musicwords_message(letter: letter))
    end

    ### HelloWorld ###
    @bot.command :helloworld do |event, lang|
      event.respond(hw_message(lang: lang))
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
  def musicwords_message(letter: letter)
    message = ""
    case letter
    when "あ"
      message += "挨拶は美しく\n"
    when "い"
      message += "一生懸命やれば大抵のことはできる\n"
      message += "一生懸命やればおもしろくなる\n"
      message += "一生懸命やれば誰かが助けてくれる\n"
    when "う"
      message += "歌はうったう訴える\n"
    when "え"
      message += "笑顔は音楽の扉\n"
    when "お"
      message += "音楽は最良の外交官\n"
    when "か"
      message += "外国では自国の伝統文化が表札\n"
    when "き"
      message += "嫌いなもの苦手なものほど一生懸命やれ\n"
    when "く"
      message += "苦悩を通して歓喜 L.V.Beethven\n"
    when "け"
      message += "謙虚にAllegro conbrio\n"
    when "こ"
      message += "心を耕すは文化なり\n"
    when "さ"
      message += "作曲はだいたい曲げて作るのだ\n"
    when "し"
      message += "親しくなればなるほど危険が増す\n"
    when "す"
      message += "すべて自然でないものは不完全である\n"
    when "せ"
      message += "声は生(声)命力\n"
    when "そ"
      message += "solo solo しっかりやろう\n"
    when "た"
      message += "他人と違う人間になれ\n"
    when "ち"
      message += "地上の芸術はすべて自己主張\n"
    when "つ"
      message += "尽きない好奇心を起こせ\n"
    when "て"
      message += "Take it easy.(気楽になれ)\n"
    when "と"
      message += "富と名声は危険な持物\n"
    when "な"
      message += "悩む力は生きる力\n"
    when "に"
      message += "人間はなりたいものしかなれない\n"
    when "ぬ"
      message += "抜き打ちにチャンス到来\n"
    when "ね"
      message += "労う言葉をかけろ！\n"
    when "の"
      message += "能率だけを求める能なし\n"
    when "は"
      message += "八方美人は美人か？\n"
    when "ひ"
      message += "人前で愚痴るな\n"
      message += "人前で暗い顔するな\n"
      message += "人と比べるな\n"
    when "ふ"
      message += "フクロウはすごい聴能力\n"
    when "へ"
      message += "平和は音楽のなかにこそある\n"
    when "ほ"
      message += "褒めて育てる\n"
    when "ん"
      message += "挨拶は美しく\n"
      message += "一生懸命やれば大抵のことはできる\n"
      message += "一生懸命やればおもしろくなる\n"
      message += "一生懸命やれば誰かが助けてくれる\n"
      message += "歌はうったう訴える\n"
      message += "笑顔は音楽の扉\n"
      message += "音楽は最良の外交官\n"
      message += "外国では自国の伝統文化が表札\n"
      message += "嫌いなもの苦手なものほど一生懸命やれ\n"
      message += "苦悩を通して歓喜 L.V.Beethven\n"
      message += "謙虚にAllegro conbrio\n"
      message += "心を耕すは文化なり\n"
      message += "作曲はだいたい曲げて作るのだ\n"
      message += "親しくなればなるほど危険が増す\n"
      message += "すべて自然でないものは不完全である\n"
      message += "声は生(声)命力\n"
      message += "solo solo しっかりやろう\n"
      message += "他人と違う人間になれ\n"
      message += "地上の芸術はすべて自己主張\n"
      message += "尽きない好奇心を起こせ\n"
      message += "Take it easy.(気楽になれ)\n"
      message += "富と名声は危険な持物\n"
      message += "悩む力は生きる力\n"
      message += "人間はなりたいものしかなれない\n"
      message += "抜き打ちにチャンス到来\n"
      message += "労う言葉をかけろ！\n"
      message += "能率だけを求める能なし\n"
      message += "八方美人は美人か？\n"
      message += "人前で愚痴るな\n"
      message += "人前で暗い顔するな\n"
      message += "人と比べるな\n"
      message += "フクロウはすごい聴能力\n"
      message += "平和は音楽のなかにこそある\n"
      message += "褒めて育てる\n"
    else
      message += "「あ」〜「ほ」を引数にしてください。\n"
      message += "「ん」で全部表示します。\n"
    end
    message
  end

  def hw_message(lang: lang)
    message = "```"
    case lang
    when ""
      message += "引数に好きなプログラミング言語を入力。"
    when "C"
      message += "#include <stdio.h>\n"
      message += "int main(void) {\n"
      message += "  printf(\"Hello, World!\");"
      message += "  return 0;"
      message += "}"
    when "C++"
      message += "#include <iostream>\n"
      message += "int main(void) {\n"
      message += "  std::cout << \"Hello,World!\" << std::endl;"
      message += "  return 0;"
      message += "}"
    end
    message += "```"

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
    message += "!musicwords : 音楽語録をお伝えします。引数に頭文字を入れるとそれを出します。「ん」にすると全部出ますけど、あんま使わないでね。\n"
    message += "!helloworld : お好きな言語のhelloworldをお伝えします。欲しい言語があったらリクエストしてください\n"
    message += "!help : これです。\n"
    message += "SourceCode -> `https://github.com/ido1006/proconBot`\n"
  end

end

proconBot = ProconBot.new
proconBot.start
