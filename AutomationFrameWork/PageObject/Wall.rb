require 'base64'
require 'json'
require_relative  '../UtilityClasses/WallDriver'
require_relative '../../app/models/workspace_analyzer'


class Wall
  def self.GetCurrentPIN(wall_address)
    walldriver = WallDriver.new(wall_address)
    walldriver.input << '{"command":"getWallPin","id":"WallAutomationTesting1"}'
    walldriver.open
    puts 'output:' + walldriver.output.to_s
    unless walldriver.output[1].nil?
      puts 'args:' + walldriver.output[1]
      parsed = JSON.parse(walldriver.output[1])
      #puts 'parsed: ' + parsed['args']['pin']
      return parsed['args']['pin']
    else
      puts '!!! Unable to retrieve the current Wall PIN. Are IP address and port correct? Is the TSX_remote_control daemon running with the test automation features enabled?'
    end

  end
  
  def self.AddNotecard(color, notecard_text, wall_address)
    walldriver = WallDriver.new(wall_address)
    template_index = ConvertColorToTemplateIndex(color)
    walldriver.input << '{"command":"addNotecard","id":"WallAutomationNoteCard1","args":{"templateIndex":"' + template_index + '","text":"' + notecard_text + '","capitalized":false,"worldSpaceX":"' + rand(-150..150).to_s + '","worldSpaceY":"' + rand(-320..320).to_s + '","centerInViewport":true}}'
    walldriver.open

    #puts 'output: ' + walldriver.output.to_s
  end
  
  def self.AddImage(image_path, wall_address)
    walldriver = WallDriver.new(wall_address)
    image_type = ''
    
    if image_path.include?('.png')
      image_type = 'png'
    elsif image_path.include?('.jpg')
      image_type = "jpg"
    end
    
    File.open(image_path, 'r') do|image_file| 
      encodedImage = Base64.encode64(image_file.read) 
      walldriver.input << '{"command":"addImageToWorkspace","id":"WallAutomationImagePNG","args":{"encodedData":"' + encodedImage + '","imageType":"' + image_type + '","worldSpaceX":"' + rand(-10..10).to_s + '","worldSpaceY":"' + rand(-270..270).to_s + '","centerInViewport":true}}'
    end
    walldriver.open

    #puts 'output: ' + walldriver.output.to_s
  end
  
  def self.VerifyItemExists(environment, workspace_id, type, arg1, arg2, arg3)
    wall_analyzer = WorkspaceAnalyzer.new(workspace_id, environment)
    return true if wall_analyzer.find_item(type, arg1, arg2, arg3)
    false
  end

  def self.VerifyItemMoved(environment, workspace_id, type, arg1, arg2, arg3, delta_x, delta_y)
    wall_analyzer = WorkspaceAnalyzer.new(workspace_id, environment)
    return true if wall_analyzer.find_moved_item(type, arg1, arg2, arg3, delta_x, delta_y)
    false
  end
  
  def self.ConvertColorToTemplateIndex(color)
    template_index = '0'
    case color
    when 'teal'
      template_index = '0'
    when 'beige'
      template_index = '1'
    when 'gold'
      template_index = '2'
    when 'grey'
      template_index = '3'
    when 'red'
      template_index = '4'
    when 'yellow'
      template_index = '5'
    when 'blue'
      template_index = '6'
    end
    return template_index
  end
end