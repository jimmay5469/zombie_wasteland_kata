class ZombieWasteland
  DEFAULT_WASTELAND = %q(@*^^^
                         zz*z.
                         **...
                         ^..*z
                         zz*zS)
  def initialize(wasteland=DEFAULT_WASTELAND)
    @wasteland = wasteland
  end

  def navigate
    "Your brains have been eaten. You are now Undead."
  end
end
