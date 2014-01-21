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
  describe "#navigate" do
    context "A 5 x 5 Wasteland" do
      subject { ZombieWasteland.new(wasteland).navigate }
      let :wasteland do
        %q(@*^^^
           zz*z.
           **...
           ^..*z
           zz*zX)
      end

      let :best_survial_strategy do
        %q(##^^^
           zz#z.
           **.#.
           ^..#z
           zz*z#)
      end

      it "finds the shortest and cheapest route to the safehouse" do
        expect(subject).to eq(best_survial_strategy)
      end
    end

    context "Bonus Round with a huge Wasteland" do
      let :gaint_wasteland do
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

      it "safely navigates the gaint wasteland to the safehouse" do
        pending
        expect(subject).to eq(best_survial_strategy)
      end
    end
  end
end
