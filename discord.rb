# Shikakun Bot!!
# Created by RubyMine.
# User: axlyody

require 'rubygems'
require 'discordrb'
require 'yaml'
require 'uri'
require_relative 'lib/moonkaini'

config = YAML.load_file('config.yaml')

bot = Discordrb::Commands::CommandBot.new token: config['token'], client_id: config['client_id'], prefix: '.', advanced_functionality: true, help_command: 'shikakun'
moonkaini = Moonkaini.new

bot.ready do
  bot.game = '.ask_shikakun for help'
end

bot.command :vn, description:'Get the visual novel information including download link itself' do |event, action, *args|
  case action
    when 'list'
      getobject = moonkaini.findby_letter(args.join(' '))
      event.channel.send_embed do |embed|
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name:'Request from '+event.user.name, icon_url:  event.user.avatar_url)
        embed.title = 'Results for "'+args.join(' ')+'"'
        embed.description = getobject
        embed.colour = "#009688"
      end
    when "get"
      getobject = moonkaini.findby_vn(args.join(' '))
      event.channel.send_embed do |embed|
        if getobject[0] == 'Unknown'
          embed.colour = '#f44336'
          embed.title = 'Hmmm...'
          embed.description = '"'+args.join(' ')+'" was not found.'
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: 'https://moonkaini.co/ui/images/toa1.png')
        else
          embed.title = getobject[0]
          embed.description = getobject[3]
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: 'https://'+getobject[6])
          embed.add_field(name: 'Original', value: getobject[2], inline: true)
          embed.add_field(name: 'Released', value: getobject[4], inline: true)
          embed.add_field(name: 'Download', value: getobject[5], inline: false)
          embed.add_field(name: 'VNDB', value: 'https://vndb.org/v/all?sq='+URI.encode(getobject[0]), inline: false)
          embed.colour = "#6689d6"
        end
      end
    else
      event.channel.send_embed do |embed|
        embed.colour = '#f44336'
        embed.title = 'Wrong command'
        embed.description = '**List of available commands**

.ask_shikakun : Provide a list commands available
.vn get [title] : Get the visual novel information including download link itself Ex ".vn get Wagamama"
.vn list [query] : List of available data on the database. Ex ".vn list Wa"
.vn new : New releases this month
     '
      end
  end
end

bot.command :ask_shikakun do |event|
  event.channel.send_embed message = 'Getting help with commands' do |embed|
    embed.title = 'Shikakun Bot!! Ruby ver.'
    embed.description = '
.ask_shikakun : Provide a list commands available
.vn get [title] : Get the visual novel information including download link itself Ex ".vn get Wagamama"
.vn list [query] : List of available data on the database. Ex ".vn list Wa"
.vn new : New releases this month
     '
  end
end

bot.run
