require 'setup.rb'

def add_pcs
  set = ask("Enter: Name, Roll; Repeat").split(";")
  for char in set
    pc = Character.new
    pc.name = char.split(",")[0].strip
    pc.init = char.split(",")[1].strip.to_i
    @characters << pc
  end
  characters.sort!
end



#Shoes App
Shoes.app :title => "Initiative Tracker", :width => 500, :height => 550 do
  style Link, :underline => false, :stroke => rgb(50,68,32)
  style LinkHover, :underline => false, :stroke => rgb(93,130,58)
  background rgb(225,225,196)

  @characters = Array.new
  @buttons = flow do
    
    button "+Players" do
      str = ask("Enter: Name, Modifier, [Roll]")
      name = str.split(",")[0].strip
      mod  = str.split(",")[1].strip.to_i
      init = str.split(",")[2]
      
      character = Character.new
      character.name = name
      character.mod = mod
      
      if init
        character.init = init.strip.to_i
      else
        character.roll_init!
      end
      character.ask = true
      @characters << character
      @characters.sort!
      paint
    end

    button "+Monsters" do
      monster = Character.new
      s = ask("Enter: Name, Modifier, [Number]")
      name = s.split(",")[0].strip
      mod  = s.split(",")[1].strip.to_i
      num  = s.split(",")[2].strip.to_i
      init = 1 + rand(20) + mod

      num ||= 1
      num.times do |i|
        monster = Character.new
        monster.name = name
        monster.note = (i+1).to_s
        monster.mod = mod
        monster.init = init
        @characters << monster
      end
      @characters.sort!
      paint
    end

    button "Re-Roll!" do
      @characters.each do |char|
        if char.ask
          input = ask("Initative for #{char.name}?  (Blank to roll at #{char.mod})").strip
          if input.length > 0 then
            char.init = input.to_i
          else
            char.roll_init!
          end
        else
          char.roll_init!
        end
      end
      @characters.sort!
      paint
    end

    button "Next>" do
      @characters.next
      @characters.first.waiting = false
      paint
    end 
  end #end button flow

  @list = stack :width => 600
  @waiting = stack :width => 600

  def paint
    @list.clear
    @list.prepend do
      @characters.select{|x| !x.waiting }.each_with_index do |char,i|
        
        flow do
          if (i % 2) == 0
            background rgb(188,188,157)
          else
            background rgb(225,225,196)
          end

          image "images/x.png" do 
            @characters.delete(char)
            paint
          end
        
          image "images/dotdotdot.png" do
            char.waiting = true
            if @characters.first == char then
              @characters.next
            end
            paint
          end
        
          para link(char.nice_init) {
            char.init = ask("New Init?")       
            paint
          }, :left => 50
          
          para "#{char.name}", :left => 80
          edit_line char.note, :left => 210, :width => 200 do |e|
            char.note = e.text
          end
          
          para link(char.nice_hp) {
            char.hit(ask("Damage?"))
            paint 
          }, :left => 420
        end
      end
    end

    @waiting.clear
    @waiting.prepend do
      stack :margin_left => 5, :margin_right => 5, :margin_top => 10 do
        waiting_characters = @characters.select{ |x| x.waiting }
        if waiting_characters.length > 0
          background rgb(210,210,186), :curve => 5
        end
        waiting_characters.each do |char|
          flow do
            image "images/x.png" do 
              @characters.delete(char)
              paint
            end
            image "images/wake-up.png" do
              char.waiting = false
              char.init = @characters.first.init
              @characters.push(@characters.delete char)
              paint
            end

            para link(char.nice_init) {
              char.init = ask("New Init?")       
              paint
            }, :left => 55
            
            
            para "#{char.name}", :left => 85
            edit_line char.note, :left => 215, :width => 200 do |e|
              char.note = e.text
            end

            para link(char.nice_hp) {
              char.hit(ask("Damage?"))
              paint 
            }, :left => 425
            
          end
        end
      end
    end
  end
end