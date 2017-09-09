# Shikakun Bot!!
# Created by RubyMine.
# User: axlyody


require 'rubygems'
require 'rest-client'
require 'json'
require 'yaml'


class Moonkaini
  config = YAML.load_file(File.expand_path('config.yaml'))
  $api = config['api']
  def findby_vn(title)
    getapi = RestClient.get "#{$api}/public", :params => {:q => 'find', :title => title}
    getdata = JSON.parse(getapi)
    name = getdata.first['name']
    id = getdata.first['id']
    original = getdata.first['original']
    description = getdata.first['description']
    released = getdata.first['released']
    link = getdata.first['link']
    image = getdata.first['image']
    [name,id,original,description,released,link,image]
  end
  def findby_letter(letter)
    getapi = RestClient.get "#{$api}/public", :params => {:q => 'sort', :letter => letter}
    getdata = JSON.parse(getapi)
    results = ""
    getdata.each { |item|
      results += '· '+item['name']+"\n"
    }
    results
  end

  def this_month()
    getapi = RestClient.get url "#{$api}/public", :params => {:q => 'this_month'}
    getdata = JSON.parse(getapi)
    results = ""
    getdata.each {|item|
      results += '· '+item['name']+"\n"
    }
    results
  end
end