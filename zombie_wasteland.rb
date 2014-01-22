class ZombieWasteland
  DEFAULT_WASTELAND = %q(@*^^^
                         zz*z.
                         **...
                         ^..*z
                         zz*zS)
  def initialize(wasteland=DEFAULT_WASTELAND)
    @wasteland = wasteland
    self.map = wasteland.split(/\s+/m)
  end


  def navigate
    solve_forward(*start_point)
    map.join("\n")
  end

  def solve_forward(x,y)
    space = space_at(x,y)
    map[y][x] = "#"
    if space != "S"
      next_point = move_from(x,y)
      solve_forward(*next_point) unless next_point == []
    end
  end

  def move_from(x,y)
    distances = {}
    valid_moves_from(x,y).each do |pair|
      distances[distance_to_finish(*pair)] = pair
    end
    distances[distances.keys.min]
  end

  def valid_moves_from(x,y)
    valid_moves = []
    (x-1).upto(x+1).each do |_x|
      (y-1).upto(y+1).each do |_y|
        next if _x == x && _y == y
        valid_moves << [_x, _y] if [".", "*", "^", "S"].include?(space_at(_x, _y))
      end
    end
    valid_moves
  end

  def space_at(x, y)
    return nil if x < 0 || y < 0
    return nil if map.length <= y
    return nil if map[y].length <= x
    map[y][x]
  end

  def distance_to_finish(x, y)
    _x, _y = finish_point
    Math.hypot(x-_x, y-_y)
  end

  def start_point
    find_symbol("@")
  end

  def finish_point
    find_symbol("S")
  end

  def find_symbol(symbol)
    map.each_index do |row_index|
      row = map[row_index]
      next unless row =~ /#{symbol}/
      return [row_index, row.index(symbol)]
    end
  end

  def parse
    @wasteland.split(/\s+/m)
  end


  private 

  attr_accessor :map, :solution
end
