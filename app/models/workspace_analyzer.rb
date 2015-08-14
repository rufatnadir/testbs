require 'base64'
require 'httmultiparty'
require 'yaml'
require 'openssl'

class WorkspaceAnalyzer
  attr_accessor :workspace_id, :environment, :config, :results

  def initialize(workspace_id, environment, config = nil)
    @workspace_id = workspace_id
    @environment = environment
    @config = config
    @results = ''

    #bVqGsQtzNKkaGPdw-E-S

    if @workspace_id.length == 20
      @analyzer = Analyzer.new(@workspace_id, @environment)
      #if @config == "summaryonly"
      #  @analyzer.analyze(:summaryonly)
      #else
      #  @analyzer.analyze
      #end
      #@results = @analyzer.report(:all).gsub("\n", '<br>')
    end
  end
  
  def analyze
    unless @analyzer.nil?
      if @config == "summaryonly"
        @analyzer.analyze(:summaryonly)
      else
        @analyzer.analyze
      end
      @results = @analyzer.report(:all).gsub("\n", '<br>')
    end
  end
  
  def find_item(type, arg1, arg2 = nil, arg3 = nil)
    unless @analyzer.nil?
      @analyzer.find_item(type, arg1, arg2, arg3)
    end
  end
  
  def find_moved_item(type, arg1, arg2, arg3, delta_x, delta_y)
    unless @analyzer.nil?
      @analyzer.find_moved_item(type, arg1, arg2, arg3, delta_x, delta_y)
    end
  end
  
end

class Analyzer
  attr_reader :canvas_items
  attr_reader :canvas_items_filtered
  attr_reader :item_factory

  def initialize(session_id, environment)
    reset_variables
    @session_id = session_id
    @environment = environment
  end

  def reset_variables
    @client = HTTPClient.new(@environment)
    @chunks = []
    @history = []
    @events = []
    @events_by_type = Hash.new { |h, k| h[k] = []}
    @events_by_target = Hash.new { |h, k| h[k] = []}
    @size_by_event_type = Hash.new(0)
    @creates_by_type = Hash.new(0)
    @tsx_app_events_by_type = Hash.new { |h, k| h[k] = Hash.new(0)}
    @text_fields  = Hash.new(0)
    @@canvas_items = Hash.new { |h, k| h[k] = []}
    @@canvas_items_filtered = []
  end

  def find_item(type, arg1, arg2 = nil, arg3 = nil)
    reset_variables
    @item_factory = get_item_factory(type)
    if @item_factory
      assert_item = @item_factory.create(type, arg1, arg2, arg3)
      analyze
      return true if canvas_item_exists?(assert_item)
    else
      return false
    end
  end

  def canvas_item_exists?(assert_item)
    #unless assert_item.nil?
    if assert_item.is_a?(CanvasItem)
      #puts "searching for: #{assert_item.item_type}, description: #{assert_item.description}"

      @@canvas_items_filtered.each do |canvas_item|
        #puts "canvas item  #{canvas_item.item_type}, #{canvas_item.description}"
        if assert_item.item_type == canvas_item.item_type
          return true if assert_item.is_equal?(canvas_item)
        end
      end
      return false
    else
      return false
    end
    #end
  end

  def find_moved_item(type, arg1, arg2, arg3, delta_x, delta_y)
    reset_variables
    @item_factory = get_item_factory(type)
    if @item_factory
      assert_item = @item_factory.create(type, arg1, arg2, arg3)
      analyze()
      return true if canvas_item_moved?(assert_item, delta_x, delta_y)
    else
      return false
    end
  end

  def canvas_item_moved?(assert_item, delta_x, delta_y)
    #unless assert_item.nil?
    if assert_item.is_a?(CanvasItem)
      #puts "searching for: #{assert_item.item_type}, description: #{assert_item.description}"

      @@canvas_items_filtered.each do |canvas_item|
        #puts "canvas item  #{canvas_item.item_type}, #{canvas_item.description}"
        if assert_item.item_type == canvas_item.item_type
          return true if canvas_item.has_moved?([delta_x, delta_y])
        end
      end
      return false
    else
      return false
    end
    #end
  end

  def analyze(input = nil)
    reset_variables

    puts 'Connect to ' + @environment + ' database: Authenticating'
    @client.authenticate
    puts 'Connect to ' + @environment + " database: Authenticated\n"

    @chunks = @client.get("/#{@session_id}/history").body
    @chunks.each do |chunk_url|
      @history += @client.get(chunk_url).body
    end

    @history.each do |message|
      event = Event.new(message)
      if input == :debug
        puts
        puts message
      end

      unless input == :summaryonly
        @item_factory = get_item_factory(event.event_type)
        if @item_factory
          @@canvas_items[event.event_id] << @item_factory.create_from_event(event)

          @@canvas_items.each do |k, v|
            v[0].update_state(event)
          end
        end
      end

      @events << event
      @events_by_type[event.event_type] << event
      @events_by_target[event.target_id] << event
      @size_by_event_type[event.event_type] += message.to_s.bytesize
    end

    @events_by_type['create'].each do |event|
      create_type = event.props['type']
      @creates_by_type[create_type] += 1

      text_field = event.props['text']
      @text_fields[text_field] = text_field
    end

    @events_by_type['tsxappevent'].each do |event|
      tsx_app_type = event.props['targetTsxAppId']
      tsx_app_msg_type = event.props['messageType']
      @tsx_app_events_by_type[tsx_app_type][tsx_app_msg_type] += 1
    end

    @@canvas_items.each do |k, v|
      if !v[0].is_deleted
        case v[0].item_type
          when 'delete', 'pin', 'position', 'markerdelete', 'markermove'
            #do not include these events
          when 'tsxappevent'
            if v[0].message_type == 'createBrowser'
              @@canvas_items_filtered << v[0]
            end
          else
            @@canvas_items_filtered << v[0]
        end
      end
    end

  end

  def report(input = nil)

    results = "\nSession Statistics For #{@session_id} in " + @environment + "\n"
    results << "-------------------------------------\n\n"
    results <<  "Number of Chunks: #{@chunks.count}\n"
    results << "Number of Events: #{@events.count}\n"

    if @@canvas_items.size > 0
      results << "Number of Canvas Items: #{@@canvas_items.count}\n"
    end
    if @@canvas_items_filtered.size > 0
      results << "Number of Filtered Canvas Items: #{@@canvas_items_filtered.count}\n"
    end

    results << "\nNumber of Events By Type\n"
    @events_by_type.each do |k, v|
      results << "#{k}, #{v.length}\n"
    end

    unless @creates_by_type.empty?
      results << "\nCreates by Type\n"
      @creates_by_type.each do |k, v|
        results << "#{k}, #{v}\n"
      end
    end

    unless @tsx_app_events_by_type.empty?
      results << "\nTSX App Events by Type\n"
      @tsx_app_events_by_type.each do |k, v|
        v.each do |l, m|
          results << "#{k}, #{l}, #{m}\n"
        end
      end
    end

    #puts "Text Fields"
    #@text_fields.each do |k, v|
    #  puts "#{v}"
    #end
    #puts

    if input == :all
      if @@canvas_items.size > 0
        results << "\nCanvas Items\n"
        @@canvas_items.each do |k, v|
          results << v[0].to_s + "\n"
        end
      end
    end

    if @@canvas_items_filtered.size > 0
      results << "\nFiltered Canvas Items\n"
      @@canvas_items_filtered.each do |k|
        results << "#{k}\n"
      end
    end

    return results

  end
end

class HTTPClient
  attr_accessor :cookies

  def initialize(environment)
    @config = ClientConfig.new(environment)
    @cookies = ''
  end

  def authenticate
    response = post('', {'uid' => @config.wall_uid}, 'authentication_url')

    encoded_challenge = response.body['challenge']

    raw_challenge = @config.private_key.private_decrypt(Base64.decode64(encoded_challenge))

    put('', { 'uid' => @config.wall_uid, 'answer' => raw_challenge }, 'authentication_url')
  end

  def get(*args); http_request('get', *args) end

  def post(*args); http_request('post', *args) end

  def put(*args); http_request('put', *args) end

  def delete(*args); http_request('delete', *args) end

  private

  def http_request(verb, url, body = {}, config_key = 'http_collaboration_service_address')
    uri = @config.urls[config_key] + url

    options                    = {}
    options[:body]             = body
    options[:headers]          = {'Cookie' => @cookies, 'User-Agent' => 'Integration-Tests'}
    options[:verify]           = @config.allow_invalid_cert ? false : true
    options[:detect_mime_type] = true

    response = HTTMultiParty.send(verb,
                                  uri,
                                  options)

    @cookies = response.headers['set-cookie']

    Response.new(response)
  end

end

class ClientConfig

  attr_accessor :wall_uid, :private_key, :urls, :allow_invalid_cert, :log_level

  def initialize(environment)
#    config = YAML.load_file('../../test_automation/AutomationFrameWork/config/settings.yml')
    #config = YAML.load_file('settings.yml')
    @wall_uid = "7Zyi7kWhyfxi9tHXxpsj"
    # @private_key = OpenSSL::PKey::RSA.new(File.read(config['private_key_path']))
    @private_key = OpenSSL::PKey::RSA.new('-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA158+/mYa1oCA8CfNhN6Ab2ZGSn+AMgQQRaZzCGFSKerqCpHW
lA+3kS7TlbIrjtxXRb5ZLgbZlbNZoF95vDrH/c3XtcGjqsOeMg8k0MnQBNQ243n8
Cpp5i3bGuV8IEpl4Yu0qrz78QBNv+C/351JL53H4dqHCInB3z8j7Q3Myr0XhUW8Y
Shv2C6LJ2VtSFCeTHAp8F5UYLwDXl6pHAf83JA/YHr0ArOB+YL6QQf4+ssZswjC7
sYBs7j9cdLyTmAZ8Grt8gK5zwtfvWd9XiMZZaBoJmOSYH0LDPubcyV/b3e2Busi3
IprSbLPXR2HhOnHBuNNDd5U8W53mFbO/thyP0wIDAQABAoIBAQCf6T5ytY7Z3lvB
wAMvs0RVWehvf7e3YEQhI5zUbjjdVZdVV2toS2+8gJnyvzyGqusekljZRcNAvs6N
ncFO09lWZb7A0WdsUb+VKJ4JKmLX8frzIZjG1GGoCOLAv7Xg9WjPFU0+wtuZOdEk
o46bQ/F/KIs4kCbGG9r/gvK1x02jpjZoXfS3p6uVBB0ojvZ193LCXHfKxy5jlofD
TpYSh1gaSwE2ef+uxTe7a8sK/DmIP7EhWVmRXLgZ2/MmMplqI9gEe9tB7JmnXVho
I6CaVCML7ojjo9dYo660EgMbO4fQedr+1+OK9yeY18t5ZEuXiVK2BSuYH34Vgheg
NixdwjPBAoGBAPv/VqJQ24s5C/tabCkuo0W+oiM+DYJp7iFi1CZxl5871tzMtTMD
QG+Hi6JVrlX5mxqs6dJcDJ9Vj2vYme/2MMth86d+wiBbjHDFvzp4Eu0+bBPL5xU2
ZhxlWPh6kpY/uHCflz0sIr/XZyuqQmIBY3cP0+Bf7wf2cBilEpewW9HbAoGBANsL
/+kfwyZOHRroIJHlS8sckE1ZttBYkR/f+3lRkl580kw8VZjRxsoOrC9jdPG87xmy
9agyl+1qvLkVdT/u9XiNXBHHq5XaVSp8zYBJSUYHag2N4xje5tosXqPf5+g+W/DD
SAyKWpBGt90jj4Lz7Rjr6TGYp6AszKakJyWvK4dpAoGAaXmzolbjvb9P85IiaY5a
yquDI+sqLmb2REUgdULgasbaJSsNwN9gjg4W9QiV4uiJ8j1j1SewJNTkJgjQTe8m
90n1eSsGSBLpkp5Cb0+o5GJXTGXxQCC31rTY65AqYPck1QcHf5REqzWWumEWTf00
y7X1QhoFa7jLrJUTVih8FjcCgYAnWJRzT51COC3KM4AGNOXUaiERg9fuvLn0u8r0
E87y4gD0aLIHbUcD7HbJXFgZRBK+zwKJX+0iXFXh+RTCky3MpbewCemsVTePFjPj
o0ZiKdrG7IGqaf+VmPq2/PUvJmRlbu52MjPqTomgU07n+uDP5TBSFFWn0+Q+2qWd
g0WSYQKBgQCaAZXezXsoxnehJQ005kXmSUP4F9n+S4wEYEwKuBKx8ocRJEWwwm33
U9Qyje75IaG4JAlVqwptKJ5Cf1B5YDbYi/JT4eGcs4laZVdDc8uLoSHMZmQgaoVT
1JIGZRsZwxnT+YJOGS10N7eBz9LoiEC1mpRnwylzRMjW2Thbo8Txcg==
-----END RSA PRIVATE KEY-----')
    @log_level = 'DEBUG'
    @allow_invalid_cert = true
    options = @allow_invalid_cert ? {:verify => false} : {}
    @owner_mail = 'automation.org.owner@bluescape.com'

    @config_url = 'https://staging.configuration.bluescape.com/'
    case (environment)
      when 'acceptance'
        @config_url = 'https://acceptance.configuration.bluescape.com/'
      when 'production'
        @config_url = 'https://configuration.bluescape.com/'
    end
    @urls = HTTParty.get(@config_url, options).parsed_response
  end
end

class Response
  attr_accessor :status, :body

  def initialize(http_response)
    @status = http_response.code
    @body = http_response.parsed_response
  end
end

Event = Struct.new(:message) do
  def target_id
    message[2]
  end

  def event_id
    message[3]
  end

  def event_type
    message[4]
  end

  def props
    message[5]
  end
end

module AbstractCanvasItemFactory
  def create_from_event(event)
    raise NotImplementedError, 'Abstract create_from_event method should not be called'
  end
  def create(type, arg1, arg2 = nil, arg3 = nil)
    raise NotImplementedError, 'Abstract create method should not be called'
  end
end

def get_item_factory(type)
  case type
    when 'bgtexture'
      BGTextureItemFactory.new
    when 'create', 'note', 'image', 'pdf'
      CreateItemFactory.new
    when 'delete'
      DeleteItemFactory.new
    when 'markercreate', 'marker'
      MarkerCreateItemFactory.new
    when 'markerdelete'
      MarkerDeleteItemFactory.new
    when 'markermove'
      MarkerMoveItemFactory.new
    when 'navigate'
      NavigateItemFactory.new
    when 'pin'
      PinItemFactory.new
    when 'position'
      PositionItemFactory.new
    when 'stroke'
      StrokeItemFactory.new
    when 'style'
      StyleItemFactory.new
    when 'template'
      TemplateItemFactory.new
    when 'text'
      TextItemFactory.new
    when 'tsxappevent', 'webbrowser'
      TsxAppEventItemFactory.new
    else
      puts "get_item_factory: Workspace Analyzer cannot recognize events of type: \"#{type}\" at this time. Please implement support for these in the Workspace Analyzer."
      UnknownEventItemFactory.new
  end
end

class BGTextureItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    BGTextureItem.new event
  end
  def create(type, arg1, arg2 = nil, arg3 = nil)
    BGTextureItem.new type, arg1, arg2, arg3
  end
end

class CreateItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    CreateItem.new event
  end
  def create(type, arg1, arg2 = nil, arg3 = nil)
    CreateItem.new type, arg1, arg2, arg3
  end
end

class DeleteItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    DeleteItem.new event
  end
end

class MarkerCreateItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    MarkerCreateItem.new event
  end
  def create(type, arg1, arg2 = nil, arg3 = nil)
    MarkerCreateItem.new type, arg1, arg2, arg3
  end
end

class MarkerDeleteItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    MarkerDeleteItem.new event
  end
end

class MarkerMoveItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    MarkerMoveItem.new event
  end
end

class NavigateItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    NavigateItem.new event
  end
end

class PinItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    PinItem.new event
  end
end

class PositionItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    PositionItem.new event
  end
end

class StrokeItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    StrokeItem.new event
  end
  # def create(type, arg1, arg2 = nil, arg3 = nil)
  #   StrokeItem.new type, arg1, arg2, arg3
  # end
end

class StyleItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    StyleItem.new event
  end
  def create(type, arg1, arg2 = nil, arg3 = nil)
    StyleItem.new type, arg1, arg2, arg3
  end
end

class TemplateItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    TemplateItem.new event
  end
  # def create(type, arg1, arg2 = nil, arg3 = nil)
  #   StrokeItem.new type, arg1, arg2, arg3
  # end
end

class TextItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    TextItem.new event
  end
  # def create(type, arg1, arg2 = nil, arg3 = nil)
  #   StrokeItem.new type, arg1, arg2, arg3
  # end
end

class TsxAppEventItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    TsxAppEventItem.new event
  end
  def create(type, arg1, arg2, arg3)
    TsxAppEventItem.new type, arg1, arg2, arg3
  end
end

class UnknownEventItemFactory
  include AbstractCanvasItemFactory
  def create_from_event(event)
    UnknownEventItem.new event
  end
end

class CanvasItem
  attr_reader :target_id
  attr_accessor :item_type
  attr_reader :item_id
  attr_reader :link_id
  attr_reader :properties
  attr_accessor :is_deleted
  attr_accessor :is_pinned

  def initialize(event = nil)
    puts 'canvas item initialize should not be called!'
  end
  def update_state(event)
    puts 'canvas item update_state should not be called!'
  end
  def is_equal?(input)
    puts 'canvas item is_equal? should not be called!'
    false
  end
  def has_moved?(input)
    puts 'canvas item has_moved? should not be called!'
    false
  end
  def to_s
    'canvas item to_s should not be called!'
  end
end

class BGTextureItem < CanvasItem
  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @link_id = args[0].target_id unless args[0].nil?
    end
  end
  def update_state(event)
    if event.target_id == @link_id
      case event.event_type
        when 'delete'
          @is_deleted = true
      end
    end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id && input.page == @page if input.is_a?(BGTextureItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - #{@properties}\n"
  end
end

class CreateItem < CanvasItem
  attr_accessor :description
  attr_accessor :height
  attr_accessor :width
  attr_accessor :location
  attr_accessor :color
  attr_accessor :style
  attr_accessor :position_history
  attr_accessor :position_deltas
  attr_accessor :size_history

  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    @is_pinned = false
    @is_deleted = false
    @position_deltas = []

    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].props['type'] unless args[0].nil?
      @link_id = args[0].props['id'] unless args[0].nil?
      @height = args[0].props['actualHeight'] unless args[0].nil?
      @width = args[0].props['actualWidth'] unless args[0].nil?
      @location = args[0].props['rect'] unless args[0].nil?
      @position_history = [args[0].props['rect']] unless args[0].nil?
      @size_history = [[args[0].props['actualHeight'], args[0].props['actualWidth']]] unless args[0].nil?

      if @item_type == 'note'
        @description = args[0].props['text'] unless args[0].nil?
        @color = args[0].props['baseName'] unless args[0].nil?
        @style = args[0].props['styles']['text-transform'] unless args[0].nil? || args[0].props['styles'].nil? || args[0].props['styles']['text-transform'].nil?
      elsif @item_type == 'image'
        #@description = @item_type + ': ' + args[0].props['ext'] unless args[0].nil?
        @description = @properties
      elsif @item_type == 'pdf'
        @description = @item_type + ': ' + args[0].props['filename'] unless args[0].nil?
      elsif @item_type == 'youtube'
        @description = @item_type + ': ' + args[0].props['youtubeId'] unless args[0].nil?
      end
    else
      @item_type = args[0]
      @description = args[1]

      if args.size > 2
        unless args[2].nil?
          @color = 'sessions/all/' + args[2].capitalize
        end
        unless args[3].nil?
          @style = args[3]
          if @style.downcase == 'header' || @style.downcase == 'caps'
            @style = 'uppercase'
          else
            @style = 'inherit'
          end
        end
      end
    end
  end
  def update_state(event)
    if event.target_id == @link_id
      case event.event_type
        when 'delete'
          @is_deleted = true
        when 'pin'
          @is_pinned = event.props['pin']
        when 'text'
          if @item_type == 'note'
            @description = event.props['text']
          end
        when 'template'
          @color = event.props['baseName']
        when 'position'
          @location = event.props['rect']
          @position_history << event.props['rect']
          @position_deltas << @position_history[@position_history.length-2].zip(event.props['rect']).map { |x,y| y - x }

          @height = (event.props['rect'][3] - event.props['rect'][1])*2
          @width = (event.props['rect'][2] - event.props['rect'][0])*2
          @size_history << [(event.props['rect'][3] - event.props['rect'][1])*2, (event.props['rect'][2] - event.props['rect'][0])*2]
      end
    end
  end
  def is_equal?(input)
    if input.is_a?(CreateItem)
      case @item_type
      when "note"
        return true if input.description == @description && input.item_type == @item_type && input.color == @color && input.style == @style
      else
        return true if input.description == @description && input.item_type == @item_type
      end
    end
    
    false
  end
  def has_moved?(input)
    return true if @position_deltas.include?(input) if input.is_a?(Array)
    false
  end
  def to_s
    "\n#{@item_type} - pinned: #{@is_pinned}, deleted: #{@is_deleted}, description: #{@description}\n" +
        "  height: #{@height}, width: #{@width}, location: #{@location}\n" +
        "  position_history: #{@position_history}\n" +
        "  position_deltas: #{@position_deltas}\n" +
        "  size_history: #{@size_history}\n" +
        "  #{@properties}\n"
  end
end

class DeleteItem < CanvasItem
  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @link_id = args[0].target_id unless args[0].nil?
      @is_pinned = false
      @is_deleted = false
    end
  end
  def update_state(event)
    if event.target_id == @link_id
      case event.event_type
        when 'delete'
          @is_deleted = true
      end
    end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id if input.is_a?(DeleteItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - #{@properties}\n"
  end
end

class MarkerCreateItem < CanvasItem
  attr_accessor :is_deleted
  attr_accessor :description
  attr_accessor :location
  attr_reader :color
  attr_accessor :position_history
  attr_accessor :position_deltas

  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    @is_pinned = false
    @is_deleted = false
    @position_deltas = []

    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @link_id = args[0].target_id unless args[0].nil?
      @description = args[0].props['name'] unless args[0].nil?
      @location = Array[args[0].props['x'] , args[0].props['y']] unless args[0].nil?
      @color = args[0].props['color'] unless args[0].nil?
      @position_history = [Array[args[0].props['x'] , args[0].props['y']]] unless args[0].nil?
    else
      @item_type = 'markercreate'
      @description = args[1]
      @color = args[2]
    end
  end
  def update_state(event)
    if @link_id == event.target_id
      case event.event_type
        when 'markerdelete'
          @is_deleted = true
        when 'markermove'
          @location = Array[event.props['x'], event.props['y']]
          @position_history << Array[event.props['x'], event.props['y']]
          @position_deltas << @position_history[@position_history.length-2].zip(Array[event.props['x'], event.props['y']]).map { |x,y| y - x }
      end
    end
  end
  def is_equal?(input)
    #puts "marker input - description: #{input.description}, value: #{@description}"

    return true if input.description == @description if input.is_a?(MarkerCreateItem)
    false
  end
  def has_moved?(input)
    return true if @position_deltas.include?(input) if input.is_a?(Array)
    false
  end
  def to_s
    "\n#{@item_type} - deleted: #{@is_deleted}, description: #{@description}\n" +
        "  color: #{@color} location: #{@location}\n" +
        "  position_history: #{@position_history}\n" +
        "  position_deltas: #{@position_deltas}\n" +
        "  #{@properties}\n"
  end
end

class MarkerDeleteItem < CanvasItem
  attr_accessor :description

  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @link_id = args[0].target_id unless args[0].nil?
      @is_pinned = false
      @is_deleted = false
    end
  end
  def update_state(event)
    if event.target_id == @link_id
      case event.event_type
        when 'delete'
          @is_deleted = true
      end
    end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id if input.is_a?(MarkerDeleteItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - deleted: #{@is_deleted}, description: #{@description}\n" +
        "  #{@properties}\n"
  end
end

class MarkerMoveItem < CanvasItem
  attr_accessor :description
  attr_accessor :location

  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @link_id = args[0].target_id unless args[0].nil?
      @location = Array[args[0].props['x'], args[0].props['y']] unless args[0].nil?
      @is_pinned = false
      @is_deleted = false
    end
  end
  def update_state(event)
    if event.target_id == @link_id
      case event.event_type
        when 'delete'
          @is_deleted = true
      end
    end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id if input.is_a?(MarkerMoveItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - deleted: #{@is_deleted}, description: #{@description}\n" +
        "  location: #{@location}\n" +
        "  #{@properties}\n"
  end
end

class NavigateItem < CanvasItem
  attr_accessor :page
  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @link_id = args[0].target_id unless args[0].nil?
      @page = args[0].props['page'] unless args[0].nil?
    end
  end
  def update_state(event)
    if event.target_id == @link_id
      case event.event_type
        when 'delete'
          @is_deleted = true
      end
    end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id && input.page == @page if input.is_a?(NavigateItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - #{@properties}\n"
  end
end

class PinItem < CanvasItem
  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @link_id = args[0].target_id unless args[0].nil?
      @is_pinned = args[0].props['pin'] unless args[0].nil?
      @is_deleted = false
    end
  end
  def update_state(event)
    if event.target_id == @link_id
      case event.event_type
        when 'delete'
          @is_deleted = true
      end
    end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id && input.is_pinned == @is_pinned if input.is_a?(PinItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - #{@properties}\n"
  end
end

class PositionItem < CanvasItem
  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @is_pinned = false
      @is_deleted = false
    end
  end
  def update_state(event)
    if event.target_id == @link_id
      case event.event_type
        when 'delete'
          @is_deleted = true
      end
    end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id if input.is_a?(PositionItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - #{@properties}\n"
  end
end

class StrokeItem < CanvasItem
  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @is_pinned = false
      @is_deleted = false
    end
  end
  def update_state(event)
    # if event.target_id == @link_id
    #   case event.event_type
    #     when 'delete'
    #       @is_deleted = true
    #   end
    # end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id if input.is_a?(StrokeItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - #{@properties}\n"
  end
end

class StyleItem < CanvasItem
  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @link_id = args[0].target_id unless args[0].nil?
    end
  end
  def update_state(event)
    if event.target_id == @link_id
      case event.event_type
        when 'delete'
          @is_deleted = true
      end
    end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id && input.page == @page if input.is_a?(StyleItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - #{@properties}\n"
  end
end

class TemplateItem < CanvasItem
  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @is_pinned = false
      @is_deleted = false
    end
  end
  def update_state(event)
    # if event.target_id == @link_id
    #   case event.event_type
    #     when 'delete'
    #       @is_deleted = true
    #   end
    # end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id if input.is_a?(TemplateItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} -#{@properties}\n"
  end
end

class TextItem < CanvasItem
  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @is_pinned = false
      @is_deleted = false
    end
  end
  def update_state(event)
    # if event.target_id == @link_id
    #   case event.event_type
    #     when 'delete'
    #       @is_deleted = true
    #   end
    # end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id if input.is_a?(TextItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - #{@properties}\n"
  end
end

class TsxAppEventItem < CanvasItem
  attr_accessor :tsx_app_id
  attr_accessor :version
  attr_accessor :location
  attr_accessor :description
  attr_accessor :url
  attr_accessor :message_type
  attr_accessor :window_width
  attr_accessor :window_height
  attr_accessor :world_width
  attr_accessor :world_height
  attr_accessor :position_history
  attr_accessor :position_deltas
  attr_accessor :size_history

  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    @is_pinned = false
    @is_deleted = false
    @position_deltas = []
    @position_history = []
    @size_history = []

    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @link_id = args[0].target_id unless args[0].nil?
      @tsx_app_id = args[0].props['targetTsxAppId'] unless args[0].nil?
      @version = args[0].props['payload']['version'] unless args[0].nil?
      @message_type = args[0].props['messageType'] unless args[0].nil?

      case @tsx_app_id
        when 'webbrowser'

          case @message_type
            when 'createBrowser', 'geometryChanged'
              @location = Array[args[0].props['payload']['x'], args[0].props['payload']['y']] unless args[0].nil?
              @window_width = args[0].props['payload']['windowSpaceWidth'] unless args[0].nil?
              @window_height = args[0].props['payload']['windowSpaceHeight'] unless args[0].nil?
              @world_width = args[0].props['payload']['worldSpaceWidth'] unless args[0].nil?
              @world_height = args[0].props['payload']['worldSpaceHeight'] unless args[0].nil?
              @position_history = [Array[args[0].props['payload']['x'], args[0].props['payload']['y']]] unless args[0].nil?
              @size_history = [[args[0].props['payload']['worldSpaceHeight'], args[0].props['payload']['worldSpaceWidth']]] unless args[0].nil?
              @description = args[0].props['messageType'].to_s + ' ' + args[0].props['payload']['url'].to_s  unless args[0].nil?
              @url = args[0].props['payload']['url'].to_s unless args[0].nil?
            when 'navigateTo'
              @description = args[0].props['messageType'].to_s + ' ' + args[0].props['payload']['url'].to_s  unless args[0].nil?
              @url = args[0].props['payload']['url'].to_s unless args[0].nil?
          end

        when 'clocksapp'
          case @message_type
            when 'createClock'
              @location = Array[args[0].props['payload']['worldSpacePositionX'], args[0].props['payload']['worldSpacePositionY']]
              @position_history = [Array[args[0].props['payload']['worldSpacePositionX'], args[0].props['payload']['worldSpacePositionY']]] unless args[0].nil?
          end

      end

    else
      @item_type = 'tsxappevent'
      if args[0] == 'webbrowser'
        @message_type = 'createBrowser'
        @tsx_app_id = args[0]
      else
        @message_type = args[0]
      end

      @url = args[1]
      unless @url.nil? ||
          if @url[0,7] != 'http://'
            @url = 'http://' + args[1]
          end
      end
      @description = @message_type
      unless @url.nil?
        @description = @description + ' ' + @url
      end
    end
  end
  def update_state(event)
    if @link_id == event.target_id && event.event_type == 'tsxappevent'
      case event.props['targetTsxAppId']
        when 'webbrowser'
          case event.props['messageType']
            when 'deleteBrowser'
              @is_deleted = true
              @description = @message_type
            when 'geometryChanged'
              @location = Array[event.props['payload']['x'], event.props['payload']['y']]
              @position_history << Array[event.props['payload']['x'], event.props['payload']['y']]
              @position_deltas << @position_history[@position_history.length-2].zip(Array[event.props['payload']['x'], event.props['payload']['y']]).map { |x,y| y - x }

              #update the world height and width, update the size history
              @world_height = event.props['payload']['worldSpaceHeight']
              @world_width = event.props['payload']['worldSpaceWidth']
              @window_height = event.props['payload']['windowSpaceHeight']
              @window_width = event.props['payload']['windowSpaceWidth']

              @size_history << Array[event.props['payload']['worldSpaceHeight'], event.props['payload']['worldSpaceWidth']]
            when 'navigateTo'
              @url = event.props['payload']['url']
              if @url[0,7] != 'http://' && @url[0,8] != 'https://'
                @url = 'http://' + args[1]
              end
              @description = @message_type + ' ' + @url
          end
        when 'clocksapp'
          case event.props['messageType']
            when 'TWT::geom'
              @location = Array[event.props['payload']['x'], event.props['payload']['y']]
            #@position_history << Array[event.props['payload']['x'], event.props['payload']['y']]
            #@position_deltas << @position_history[@position_history.length-2].zip(Array[event.props['payload']['x'], event.props['payload']['y']]).map { |x,y| y - x }

            when 'createClock'
              @location = Array[event.props['payload']['worldSpacePositionX'], event.props['payload']['worldSpacePositionY']]
              @position_history << Array[event.props['payload']['worldSpacePositionX'], event.props['payload']['worldSpacePositionY']]
              @position_deltas << @position_history[@position_history.length-2].zip(Array[event.props['payload']['worldSpacePositionX'], event.props['payload']['worldSpacePositionY']]).map { |x,y| y - x }

              @description = event.props['payload']['title'] + ' timezone: ' + event.props['payload']['tzId']
            when 'deleteClock'
              @is_deleted = true
          end
      end
    end
  end
  def is_equal?(input)
    #puts "tsxappevent input - url: #{input.url}, value: #{@url}"
    #puts "tsxappevent input - message_type: #{input.message_type}, value: #{@message_type}"

    return true if input.tsx_app_id == @tsx_app_id && input.message_type == @message_type && input.url == @url if input.is_a?(TsxAppEventItem)
    false
  end
  def has_moved?(input)
    #puts "has_moved: #{@position_deltas}  input: #{input}"
    return true if @position_deltas.include?(input) if input.is_a?(Array)
    false
  end
  def to_s
    "\n#{@item_type} - targetApp: #{@tsx_app_id}, deleted: #{@is_deleted}\n" +
        "  description: #{@description}\n" +
        ( @message_type != 'deleteBrowser' ?
            "  window height: #{@window_height}, window width: #{@window_width}, location: #{@location}\n" +
                "  world height: #{@world_height}, world width: #{@world_width}, version: #{@version}\n" +
                "  position_history: #{@position_history}\n" +
                "  position_deltas: #{@position_deltas}\n" +
                "  size_history: #{@size_history}\n" : '' ) +
        "  #{@properties}\n"
  end
end

class UnknownEventItem < CanvasItem
  def properties
    puts '#{@properties}'
  end
  def initialize(*args)
    if args.size == 1
      @target_id = args[0].target_id unless args[0].nil?
      @item_id = args[0].event_id unless args[0].nil?
      @properties = args[0].props unless args[0].nil?
      @item_type = args[0].event_type unless args[0].nil?
      @link_id = args[0].target_id unless args[0].nil?
    end
  end
  def update_state(event)
    if event.target_id == @link_id
      case event.event_type
        when 'delete'
          @is_deleted = true
      end
    end
  end
  def is_equal?(input)
    return true if input.target_id == @target_id && input.page == @page if input.is_a?(UnknownItem)
    false
  end
  def has_moved?(input)
    false
  end
  def to_s
    "\n#{@item_type} - #{@properties}\n"
  end
end
