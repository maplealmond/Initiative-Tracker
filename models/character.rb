class Character
  include DataMapper::Resource 
  
  property :id, Integer, :serial => true
  property :name, String, :nullable => false
  property :init, Integer, :nullable => false
  property :mod, Integer
  property :note, String
  property :hp, Integer, :nullable => false
  property :waiting, Boolean
  
  attr_accessor :ask
    
  def nice_hp
    unless self.hp
      self.hp = 0
    end
    "(" + self.hp.to_s + ")"
  end
  
  def nice_init
    "[" + self.init.to_s + "]"
  end

  def hit(damage)
    unless self.hp
      self.hp = 0
    end
    if damage
      self.hp = self.hp.to_i + eval(damage)
    end
  end
  
  def set_note
    self.note = ask("Details?")
  end

  def <=>(other)
    return other.init <=> self.init unless (self.init <=> other.init) == 0
    return other.mod <=> self.mod unless (self.mod <=> other.mod) == 0
    return self.note.to_i <=> other.note.to_i if self.name == other.name
    return rand(20) <=> rand(20)
  end
  
  def roll_init!
    self.init = self.mod + 1 + rand(20)
  end

end