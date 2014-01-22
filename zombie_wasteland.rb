class ZombieWasteland
  DEFAULT_WASTELAND = %q(@*^^^
                         zz*z.
                         **...
                         ^..*z
                         zz*zS)
  def initialize(wasteland=DEFAULT_WASTELAND)
    self.wasteland_map = WastelandMap.new(wasteland)
  end

  def generate_throughpath_map
    terrain_values = { "."=>1, "*"=>2, "^"=>3 }

    throughpath_map = WastelandMap.new(wasteland_map.get_map_string)
    edges = {finish_point=>1}
    throughpath_map.set_space(finish_point,"1")

    while edges.length > 0 do
      quickest_edge = edges.sort_by{|k,v| v}.first
      edge_path_cost = quickest_edge[1].to_i
      edges.delete(quickest_edge[0])
      x, y = quickest_edge[0]
      (x-1..x+1).each do |_x|
        (y-1..y+1).each do |_y|
          space_value = throughpath_map.get_space([_x,_y])
          if(terrain_values.keys.include?(space_value))
            cost = edge_path_cost + terrain_values[space_value]
            throughpath_map.set_space([_x,_y], cost.to_s)
            edges[[_x,_y]] = cost
          end
        end
      end
    end

    return throughpath_map
  end

  def navigate
    puts "value: #{"9".to_i}"
    throughpath_map = generate_throughpath_map
    answer_map = WastelandMap.new(wasteland_map.get_map_string)

    cursor = start_point
    answer_map.set_space(cursor, "#")

    while cursor != finish_point do
      x, y = cursor

      surrounding_spaces = Hash.new()
      (x-1..x+1).each do |_x|
        (y-1..y+1).each do |_y|
          space_value = throughpath_map.get_space([_x,_y]).to_i
          if(space_value > 0)
            surrounding_spaces[[_x,_y]] = space_value
          end
        end
      end

      quickest_edge = surrounding_spaces.sort_by{|k,v| v}.first
      cursor = quickest_edge[0]
      answer_map.set_space(cursor, "#")
    end

    answer_map.get_map_string
  end

  def start_point
    wasteland_map.find_symbol("@")
  end

  def finish_point
    wasteland_map.find_symbol("S")
  end

  private 

  attr_accessor :wasteland_map
end

class WastelandMap
  def initialize(wasteland)
    _map = Array.new()
    wasteland.split(/\s+/m).each do |row|
      _map << row.split(//)
    end
    self.map = _map
  end

  def get_map_string #only works if all values are single digit
    _map = Array.new()
    map.each do |row|
      _map << row.join("")
    end
    _map.join("\n")
  end

  def get_space(x_y_coordinates)
    x, y = x_y_coordinates
    return nil if x < 0 || y < 0
    return nil if map.length <= y
    return nil if map[y].length <= x
    return map[y][x]
  end

  def set_space(x_y_coordinates, value)
    x, y = x_y_coordinates
    return nil if x < 0 || y < 0
    return nil if map.length <= y
    return nil if map[y].length <= x
    map[y][x] = value
  end

  def find_symbol(symbol)
    map.each_index do |row_index|
      row = map[row_index].join("")
      next unless row =~ /#{symbol}/
      return [row_index, row.index(symbol)]
    end
  end

  private 

  attr_accessor :map
end
