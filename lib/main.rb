require 'java'
import java.util.Random
import javax.swing.JButton
import javax.swing.JFrame
import javax.swing.JLabel
import javax.swing.JPanel
import javax.swing.JTextField
import java.awt.event.ActionListener
import java.awt.GridLayout
import java.awt.Dimension
import java.awt.Font
import java.awt.Color
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

$current = Array.new(5) { Array.new(5){6} }
$row =  Array.new(5) { Array.new(3) }
$col =  Array.new(5) { Array.new(3) }
$array = []
def after()
  puts $array.size
  if($array.size == 0)then
    froze(false)
    @left.enabled = false
    @right.enabled = false
    return
  end
  puts "Before deleting #{$array.size}"
  0.upto(4) { |x|
    str = ""
    $current[x].each{|i|
      str << i.to_s
    }
    puts str
  }
  puts
  0.upto(4) {|x|
    0.upto(4) {|y|
      #$current[x][y]
      $array = $array.delete_if{|bo|
        if($current[x][y] != 6)then
          if($current[x][y] != 5)then
            bo[x][y] != $current[x][y]
          end
        else
          false
        end
      }
    }
  }
  
  puts "After deleting #{$array.size}"
  if($array.size == 0)then
    froze(false)
    @left.enabled = false
    @right.enabled = false
    return
  end
  $array.each { |item|
    0.upto(4) { |x|
      str = ""
      item[x].each{|i|
        str << i.to_s
      }
      puts str
    }
    puts
  }
  0.upto(4) { |x|  
    0.upto(4) { |y|  
      if($current[x][y] == 6)then
        check = true
        zero = true
        number = $array[0][x][y]
        $array.each{|bo|
          if(bo[x][y]!=number)then
            check = false
          end
          if(bo[x][y] ==0)then
            zero = false
          end
        }
        if(check)then
          $current[x][y] = number
        elsif(zero)then
          $current[x][y] = 5
        end
      end
    }
  }
end
def solve(board,spot)
   x = spot/5
   y = spot%5
   p = [true,true,true,true]
   if(spot >=25)then
      board3 = Array.new(5) { Array.new(5) }
      0.upto(4){|a|
         0.upto(4){|b|
            board3[a][b] = board[a][b]
         }
      }
      $array << board3
      board3.each { |b| 
        str = ""
        b.each { |i|
          str << i.to_s
        }
        puts str
      }
      puts
      return
      #exit
   end
   if(board[x][y]!=6)then
      solve(board,spot+1)
   else
      $numc = 0
      $sumc = 0
      0.upto(4){|t|
         if(board[t][y]!= 6)then
            $sumc+=board[t][y]
         end
         if(board[t][y] == 0)then
            $numc +=1
         end
      }
      
      $numr = 0
      $sumr = 0
      0.upto(4){|t|
         if(board[x][t].to_i != 6)then
            $sumr+=board[x][t].to_i
         end
         if(board[x][t].to_i == 0)then
            $numr +=1
         end
      }
      if($sumc + 2 == $col[y][0])then
         p[3] = false
      elsif($sumc + 1 == $col[y][0])then
         p[3] = false
         p[2] = false
      elsif($sumc  == $col[y][0])then
         p[3] = false
         p[2] = false
         p[1] = false
      elsif($sumc > $col[y][0])then
         return
      end
      if($sumr + 2 == $row[x][0])then
         p[3] = false
      elsif($sumr + 1 == $row[x][0])then
         p[3] = false
         p[2] = false
      elsif($sumr + 0 == $row[x][0])then
         p[3] = false
         p[2] = false
         p[1] = false
      elsif($sumr > $row[x][0])then
         return
      end
      if(x == 4)then
         p = [false,false,false,false]
         p[$col[y][0] - $sumc] = true
         if($numc != $col[y][1])then
            p[3] = false
            p[2] = false
            p[1] = false
         end
      end
      if(y == 4)then
         p = [false,false,false,false]
         p[$row[x][0] - $sumr] = true
         if($numr != $row[x][1])then
            p[3] = false
            p[2] = false
            p[1] = false
         end
      end
      if($numc == $col[y][1])then
         p[0] = false
      end
      if($numr == $row[x][1])then
         p[0] = false
      end
      0.upto(3){|t|
         if(p[t])then
            board2 = Array.new(5) { Array.new(5) }
            0.upto(4){|a|
               0.upto(4){|b|
                  board2[a][b] = board[a][b]
               }
            }
            board2[x][y] = t
            solve(board2,spot+1)
         end
      }
   end
end
class Main < JFrame
  include ActionListener
  def initialize(*args)
    super
    @view = 0
    @left = JButton.new '<'
    @left.add_action_listener self
    add @left
    @bcur = JButton.new 'Current'
    @bcur.add_action_listener self
    add @bcur
    @right = JButton.new '>'
    @right.add_action_listener self
    add @right
    @help = JButton.new 'help'
    @help.add_action_listener self
    @v = JLabel.new "/"
    @v.setHorizontalAlignment JLabel::CENTER
    con = JPanel.new
    con.setLayout GridLayout.new(2,1)
    con.add @v
    con.add @help
    add con
    @solve = JButton.new 'Solve'
    @solve.add_action_listener self
    add @solve
    @new = JButton.new 'new'
    @new.add_action_listener self
    add @new
    
    @start = true
    @rowtext = Array.new(5) { Array.new(2) {JTextField.new("")}}
    @coltext = Array.new(5) { Array.new(2) {JTextField.new("")}}
    @jlabel = Array.new(5) { Array.new(5) {JTextField.new("6")}}
    @jlabel.each{|alabel|
      alabel.each{|label|
        label.foreground = Color.new(246,3,11)
        label.setFont Font.new "Monotype Corsiva",1,50
        label.setHorizontalAlignment JLabel::CENTER
        label.setPreferredSize Dimension.new 70,70
      }
    }
    0.upto(4) {|x|
      0.upto(4) { |y|
        add @jlabel[x][y]
      }
      con = JPanel.new
      con.setLayout GridLayout.new(2,1)
      con.add @rowtext[x][0]
      con.add @rowtext[x][1]
      add con
    }
    0.upto(4) {|y|
      con = JPanel.new
      con.setLayout GridLayout.new(2,1)
      con.add @coltext[y][0]
      con.add @coltext[y][1]
      add con
    }
    setLayout GridLayout.new(7,6)
    pack
    setDefaultCloseOperation EXIT_ON_CLOSE
    setVisible true
    @left.enabled = false
    @right.enabled = false
  end
  def actionPerformed(event)
    if(event.source==@left)then
      froze(false)
      if(@view <= 0)then
        @view = $array.size-1
      else
        @view -=1
      end
      0.upto(4) {|x|
        0.upto(4) { |y|
          @jlabel[x][y].text = $array[@view][x][y].to_s
        }
      }
    elsif(event.source==@bcur)then
      froze(true)
      0.upto(4) {|x|
        0.upto(4) {|y|
          @jlabel[x][y].text = $current[x][y].to_s
        }
      }
    elsif(event.source==@right)then
      froze(false)
      if(@view >= $array.size-1)then
        @view = 0
      else
        @view +=1
      end
      0.upto(4) {|x|
        0.upto(4) { |y|
          @jlabel[x][y].text = $array[@view][x][y].to_s
        }
      }
    elsif(event.source==@help)then
      puts "green - finished"
      puts "orange 5 - safe place please fill them in"
      puts "blue 6 - only 1 or 0 remain here"
      puts "purple 6 - Best place to guess but only 1 or 0, this will help the program to finish"
      puts "black 6 - Best place to guess with chance of 2 or 3"
      puts "red 6 - don't guess here no idea what it is yet"
    elsif(event.source==@solve)then
      froze(false)
      bsolve()
      @left.enabled = true
      @right.enabled = true
      froze(true)
      after()
      color()
      
    elsif(event.source==@new)then
      0.upto(4) {|x|
        0.upto(4) { |y|
          @jlabel[x][y].text = "6"
          @jlabel[x][y].foreground = Color.new(246,3,11)
        }
        @rowtext[x][0].text = ""
        @rowtext[x][1].text = ""
        @coltext[x][0].text = ""
        @coltext[x][1].text = ""
      }
      @solve.text = "Solve"
      $array = []
      froze(true)
      @left.enabled = false
      @right.enabled = false
    end
    @v.text = "#{@view}/#{$array.size}"
  end
  def froze(b)
    @solve.enabled = b
    0.upto(4) {|x|
      0.upto(4) {|y|
        @jlabel[x][y].enabled = b
      }
      @rowtext[x][0].enabled = b
      @rowtext[x][1].enabled = b
      @coltext[x][0].enabled = b
      @coltext[x][1].enabled = b
    }
  end
  def bsolve()
    puts "button pressed"
    0.upto(4) {|x|
      $row[x][0] = @rowtext[x][0].text.to_i
      $row[x][1] = @rowtext[x][1].text.to_i
      $col[x][0] = @coltext[x][0].text.to_i
      $col[x][1] = @coltext[x][1].text.to_i
      0.upto(4) { |y|
        $current[x][y] = @jlabel[x][y].text.to_i
      }
    }
    if(@start)then
      $array = []
      puts "first solve"
      solve($current,0)
      @start = false
      @solve.text = "fix"
    end
  end
  def color
    finished = true
    noguess = true
    0.upto(4) {|x|
      0.upto(4) { |y|
        @jlabel[x][y].text = $current[x][y].to_s
        if($current[x][y]==6)then
          @jlabel[x][y].foreground = Color.new(246,3,11)
          finished = false
        elsif($current[x][y]==5)then
          @jlabel[x][y].foreground = Color.new(255,171,0)
          finished = false
          noguess = false
        else
          @jlabel[x][y].foreground = Color.new(3,246,30)
        end
      }
    }
    if(finished)then
      #@solve.text = "New"
    elsif(noguess)then
      chance = Array.new(5) { Array.new(5) {1}}
      min = 1
      0.upto(4) {|x|
        0.upto(4) {|y|
          zeros = 0
          if($current[x][y]==6)then
            $array.each{|bo|
              if(bo[x][y]==0)then
                zeros +=1
              end
            }
            chance[x][y] = zeros*1.0/$array.size
            if(chance[x][y] < min)then
              min = chance[x][y]
            end
          end
        }
      }
      0.upto(4) {|x|
        0.upto(4) {|y|
          if(min == chance[x][y])then
            @jlabel[x][y].foreground = Color.new(255,255,0)
          end
        }
      }
      0.upto(4){|y|
        $numc = 0
        $sumc = 0
        $unc = 0
        0.upto(4){|t|
          if($current[t][y]!= 6)then
            $sumc+=$current[t][y]
          else
            $unc+=1
          end
          if($current[t][y] == 0)then
            $numc +=1
          end
        }
        if($col[y][0]-$sumc==$unc+$numc-$col[y][1])then
          0.upto(4){|x|
            @jlabel[x][y].foreground = Color.new(17,0,255)
            chance[x][y] = 1
          }
        end
      }
      0.upto(4){|x|
        $numr = 0
        $sumr = 0
        $unr = 0
        0.upto(4){|t|
          if($current[x][t].to_i != 6)then
            $sumr+=$current[x][t]
          else
            $unr+=1
          end
          if($current[x][t].to_i == 0)then
            $numr +=1
          end
        }
        if($row[x][0]-$sumr==$unr+$numr-$row[x][1])then
          0.upto(4){|y|
            @jlabel[x][y].foreground = Color.new(17,0,255)
            chance[x][y] = 1
          }
        end
      }
      0.upto(4) {|x|
        0.upto(4) { |y|
          @jlabel[x][y].text = $current[x][y].to_s
          if($current[x][y]!=6)then
            @jlabel[x][y].foreground = Color.new(3,246,30)
          end
        }
      }
      0.upto(4) {|x|
        0.upto(4) {|y|
          if(chance[x][y] < min)then
            min = chance[x][y]
          end
        }
      }    
      0.upto(4) {|x|
        0.upto(4) {|y|
          if(min == chance[x][y])then
            @jlabel[x][y].foreground = Color.new(0,0,0)
          end
        }
      }
      puts "guess #{min*100}%"
    end
  end
end
m = Main.new