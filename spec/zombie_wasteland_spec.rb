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

describe WastelandMap do
  let(:wasteland) { WastelandMap.new(map) }
  let :map do %q(@*^^^
                 zz*z.
                 **...
                 ^..*z
                 zz*zS)
  end
  describe "#get_map_string" do
    subject { wasteland.get_map_string }
    it "generates the correct string" do
      expect(subject).to eq(map.gsub(/ +/, ''))
    end
  end
  describe "#get_space" do
    subject { wasteland.get_space([2,0]) }
    it "gets the coorect value" do
      expect(subject).to eq("^")
    end
  end
  describe "#set_space" do
    it "sets the coorect value" do
      wasteland.set_space([2,0], "#")
      expect(wasteland.get_space([2,0])).to eq("#")
    end
  end
  describe "#find_symbol" do
    subject { wasteland.find_symbol("@") }
    it "finds the start symbol" do
      expect(subject).to eq([0,0])
    end
  end
end

describe ZombieWasteland do
  let(:wasteland) { ZombieWasteland.new(map) }
  let :map do %q(@*^^^
                 zz*z.
                 **...
                 ^..*z
                 zz*zS)
  end

  describe "#finish_point" do
    it do
      expect(wasteland.finish_point).to eq([4,4])
    end
  end
  
  describe "#start_point" do
    it do
      expect(wasteland.start_point).to eq([0,0])
    end
  end
  describe "#generate_throughpath_map" do
    context "A 5 x 5 Wasteland" do
      subject { wasteland.generate_throughpath_map }
      let :throughpath_map do
        %q(@8988
           zz6z5
           76444
           8543z
           zz5z1)
      end
      it "finds the shortest and cheapest route to the safehouse" do
        expect(subject.get_map_string).to eq(throughpath_map.gsub(/ +/, ''))
      end
    end
  end
  
  describe "#navigate" do
    context "A 5 x 5 Wasteland" do
      subject { wasteland.navigate }
      let :best_survial_strategy do
        %q(##^^^
           zz#z.
           **.#.
           ^..#z
           zz*z#)
      end
      it "gets the first move" do
        expect(wasteland.start_point).to eq([0,0])
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
        expect(solution).to eq(best_survial_strategy)
      end
    end
  end
end
