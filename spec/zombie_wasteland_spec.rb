require "rspec"
require_relative "../zombie_wasteland.rb"

#
#  Welcome to the Zombie Apocalypse!
#
#  Your job is to survive. You can do this by avoiding zombies and navigating
#  the horrific zombie infested wasteland to the safe house as quickly as
#  possible.
#
#  Sample Map:
#
#  @*^^^
#  zz*z.
#  **...
#  ^..*z
#  zz*zS
#
#  @ = Survivor start
#  S = The Safe house#
#
#  Movement Cost for Terrain:
#    Non-walkable:
#      N/A = Zombie Infestation Area (z)
#    Walkable:
#      1 = Flatlands (. or @ or S)
#      2 = Forest (*)
#      3 = Mountain (^)
#
#  Best Solution:
#
#  ##^^^
#  zz#z.
#  **.#.
#  ^..#z
#  zz*z#
#

describe ZombieWasteland do
  let(:wasteland) { ZombieWasteland.new(map) }
  let :map do %q(@*^^^
                 zz*z.
                 **...
                 ^..*z
                 zz*zS)
  end

  describe "#finish" do
    it do
      expect(wasteland.finish_point).to eq([4,4])
    end
  end
  
  describe "#move_from" do
    it do
      expect(wasteland.move_from(1,2)).to eq([2,3])
    end
  end

  describe "#valid_moves_from" do
    let(:origin) { [0,0] }
    let(:valid_moves) { [[1,0]] }

    it "finds the valid moves" do
      expect(wasteland.valid_moves_from(*origin)).to eq(valid_moves)
    end

    context "again" do
      let(:origin) { [3,3] }
      let(:valid_moves) { [[2, 2], [2, 3], [2, 4], [3, 2], [4, 2], [4, 4]] }

      it "finds the valid moves" do
        expect(wasteland.valid_moves_from(*origin)).to eq(valid_moves)
      end
    end
  end

  describe "#space_at" do
    let(:map) { %q(@*
                   .S) }
    it "can be accessed by points" do
      expect(wasteland.space_at(1,1)).to eq("S")
    end
    it "finds points well" do
      expect(wasteland.space_at(1,0)).to eq("*")
    end

    it "return nil for out of bounds on the X axis" do
      expect(wasteland.space_at(2,0)).to eq(nil)
    end
    it "returns nil for out of bounds on the Y axis" do
      expect(wasteland.space_at(0,2)).to eq(nil)
    end
  end

  describe "#navigate" do
    let(:wasteland) { ZombieWasteland.new(map) }

    context "A 5 x 5 Wasteland" do
      subject { wasteland.navigate }
      let :map do %q(@*^^^
           zz*z.
           **...
           ^..*z
           zz*zS)
      end

      let :best_survial_strategy do
        %q(##^^^
           zz#z.
           **.#.
           ^..#z
           zz*z#)
      end

      it "gets the first move" do
        expect(wasteland.start_point).to eq([0,0])
        expect(wasteland.move_from(0,0)).to eq([1,0])
      end

      it "finds the shortest and cheapest route to the safehouse" do
        expect(subject).to eq(best_survial_strategy.gsub(/ +/, ''))
      end
    end

    context "Bonus Round with a huge Wasteland" do
      let(:wasteland) { ZombieWasteland.new(map) }
      let :map do
        %q(@^.^z****^*zz.z^z..zzz^z.^z.*z**.^^*^*^z..*^^..z^.
           *.*z*.z^^^zz.*z*.**.zz^*^**.^z*^^.*^...^..^.**.z^*
           ^^***z.*^*^..^**.zzz.z*.z^^z^z^.^z^*z**.z*^.^**.*.
           *zz.z^.z*z^z^^*^**.z.*^^*zz^^*z.^.*^^*^.^.zz^^^*z.
           *.^z^^.z^.^.^^*z^zz*^..^z^zz^.*^^..**.**z.zz^z*z**
           ^.^^z^.*z**.*z*^*z^*zz^.^.z.z^**z.^^^^*.z.zzz^^.^.
           *zz.*.^zzz^*.^*zzz*^.^**^*^.^.^zz***^^*^.z^^.^^.z.
           .z.*zz^*.**.z^^z**^.^.^zzz^.z.^zz^^.z^^.^^z.z.z.*^
           .^^^zz*z.^.z.*z.zz..z*z^.z**z..^****z.*z^zz*z**^z^
           ^^^*^^**...*.^^*^^^.*z*z^^z*zz.z****zzzz***.^^zz^z
           ..*^^^^^.^z.^z.^.^^z*z^*z**^*^.zzz*^.^^z**z*z.....
           **.^zzz^z*z****.**^z.^.*^^^z.^...z.**^^^^z^.z^z.z*
           ^*z.*.z*^.z.^^^^^*z.**z^.*^*.zz..^zzz*z*^.zz^*^*^^
           z*^.^..**z**^*^z***^zz*^*.*z..z^^***^.*z.^*^^^^.z.
           *z^z^**^^*^^z^*z^^*zzz*^*zzzz*z^^^*z..zzzzz.*z^z*.
           ^.*.^*^**^^^z**.*.z^zzz^..zzz*zz^*z..^^.^z*.^z^z**
           .***^..*^zzzz^z.*^zz.*.z^.^^*.***^z^.*....z.^.*z^^
           ^^zzzz.**.*.^^*.^zz^....*z*^z*^^.^zzz^*.z^^^z**^zz
           ^zz*^*.z.*^^^*^.*..z*...z**^.^^z.^^.^..^.^**.^^..*
           z^***z^.z.z^^^*zzz.*..^z^^.z^.z.**...z^z**z^zz**^z
           zzz^z.^*.^*.z*.*zz^..z*^^zz**.*.*.z^^^..^.z^.*.^zz
           ^^z...^.*z.^^**z^z*..^z^z*....^.^^**z.*.^^*..z*z.*
           ^..^...z.z.*.z***z*zz*..z*z^^zz^z**^zz^*^^z*.z*^*^
           *^.**^z*****.zzz..z^z.*.^*z^.^^*^..*z^.^.^*.^.z^^*
           z...z*^....*^.*^^*...^.zz..^.*z.*z.*^.^*^*^.****^z
           ^..z***^.*^zz.****.z*^.z.^z*.z^*^z^.****z..z*..*^z
           .z^z**z^^..zzz^..*z*.^**z..^^*.z.*..*zz*z.^z.z*zz.
           .***z..z**^.z.z.z*.zz**..^.^z..z*zzzz*.**zz^..^.^^
           z.*.z^*^*z^.z*..*z^zz.*.*..*.*..^z.*z^^*.z^.^z^**^
           .*^z^^*.^*.z*...*zzz*.**.z...*.*^.^*.^*z*.^z^**^*.
           .z..*....z..z.***z..z^..zz^*^*^z^^zz**^.*z**^**^^*
           ^.*.z.^.**^*^.z^^*.z..*^z*^***.z**..^.zz*..^*^z*.z
           ^zz^zz*.z^^zz^**.^.^^^*^.*^^zz.^.*z^*^^..**..**..^
           ^.^*.*^..*.zz.^^***^.*z..z.**^*.z^...^^z*.z^z^..zz
           z^^.^..*^^.**.zz^*z*^z*z^zz.z*.^z.z*^z*.*..^.^^*^*
           ^^.z*^zz*.zz*z.^..z*.^.z**.^*^.^z.**.z*.z...zz..*.
           .z..^.z.z.^*.z^*z.z.*^*zz*.^.******z*zz*^zzz^.zz*z
           z.*..^^*^z*.zz.z.^z..z.z^^^.*z*.**z^*z*^*^^z..^z^^
           *.^*^**^*.^^*....**..z^^z.^*^.*z*^**^^..*.^^*^^^.z
           ^*^z^^*.z*z^*z^zz.*.^*^z*^^z.*z.*z.**.*z^zz.z*^zz*
           zz**z*.^.*z..zz^^^z^^^.z***^*.^*z^*z^z*z**...z..z.
           *z**^zz.^.*.z^**z*^^.*^*.^zz*zzz*^.*..zz^*^.*^.^.*
           .*^z..*z.*^^^^^zz^^*.z*.zzz.***z^.*..zz******zz^*.
           .^^..^.^*^z^.z*...**zzz.**^*zzz*^***z^*^z^zz^^^*.*
           **.**z.**z.*.*^zz.z^.*^.zz*.^*.z.***z*^^..z*.z*^*^
           z..^.****^.****z^z***..^^^^*^.z*^^*.zz.^**^*z^*.zz
           ^*z^.z*...^^.^z.^^..z^...**...^****^*z*z*^..z^*z.z
           ...^z^.z^^zzzz.*^z.^z***zz^^^.*^^.z.^*z*z**^***^z^
           .zzzzz^^.zz*^.z^^^**z^z.^z^z*..^*z^^*..*z^z**.*.^.
           z^**.z**..*^z^^^.^*^z^z*^.z*z.^.**.^.^^.z**^zz^z^S)
      end

      let(:best_survial_strategy) { "good luck human" }
      let(:solution) { wasteland.navigate }

      it "safely navigates the gaint map to the safehouse" do
        puts solution
        expect(solution).to eq(best_survial_strategy)
      end
    end
  end
end
