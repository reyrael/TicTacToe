#TicTacToe Game
#Reymundo Rael
#8th Light

class TicTacToe

  def initialize

    #all possible wins
    @pos_win = [      
      [:a1,:a2,:a3],
      [:b1,:b2,:b3],
      [:c1,:c2,:c3],
      
      [:a1,:b1,:c1],
      [:a2,:b2,:c2],
      [:a3,:b3,:c3],
      
      [:a1,:b2,:c3],
      [:c1,:b2,:a3]
    ]
    game_over = nil
    
    @cpu = rand() 
    if @cpu > 0.5 
      @cpu = 'X' 
    else
      @cpu = 'O'
    end
    if @cpu == 'X'
      @user = 'O'
    else
      @user = 'X'
    end
        
    start_game(@user == 'X')
  end

  def start_game(who_is_first)
    @board_sections = {
      :a1 => "_" , :a2 => "_" , :a3 => "_",
      :b1 => "_" , :b2 => "_" , :b3 => "_",
      :c1 => "_" , :c2 => "_" , :c3 => "_"
    }
    if who_is_first
      player_turn
    else
      cpu_turn
    end
  end

  def replay_game(who_is_first)
    puts "#" * 26
    puts "#" * 26
    start_game(who_is_first)
  end
  
  def print_board
    puts "\n  TIC TAC TOE"
    puts ""
    puts " CPU: #{@cpu}"
    puts " Player: #{@user}"
    puts ""
    puts "     a   b   c"
    puts ""
    puts " 1   #{@board_sections[:a1]} | #{@board_sections[:b1]} | #{@board_sections[:c1]} "
    puts "    --- --- ---"
    puts " 2   #{@board_sections[:a2]} | #{@board_sections[:b2]} | #{@board_sections[:c2]} "
    puts "    --- --- ---"
    puts " 3   #{@board_sections[:a3]} | #{@board_sections[:b3]} | #{@board_sections[:c3]} "
  end
  
  def cpu_turn
    move = cpu_strategy
    @board_sections[move] = @cpu
    print_board
    puts " CPU marks #{@cpu} on #{move.to_s.upcase}"
    is_game_over(@user)
  end
  
  def cpu_strategy
    #find cpu a move 
    #one move to win
    @pos_win.each do |win_combin|
      if count_sym(win_combin, @cpu) == 2
        return is_section_empty win_combin
      end
    end
    
    # block user
    @pos_win.each do |win_combin|
      if count_sym(win_combin, @user) == 2
        return is_section_empty win_combin
      end
    end
    
    #build up to win
    @pos_win.each do |win_combin|
      if count_sym(win_combin, @cpu) == 1
        return is_section_empty win_combin
      end
    end
    
    #pick a random spot
    k = @board_sections.keys;
    i = rand(k.length)
    if @board_sections[k[i]] == "_"
      return k[i]
    else
      @board_sections.each { |k,v| return k if v == "_" }
    end
  end
  
  #count symbols for cpu strategy
  def count_sym arr, item
    times = 0
    arr.each do |i| 
      times += 1 if @board_sections[i] == item
      unless @board_sections[i] == item || @board_sections[i] == "_"
        return 0
      end
    end
    times
  end
  
  def is_section_empty arr
    arr.each do |i| 
      if @board_sections[i] == "_"
        return i
      end
    end
  end
  
  def player_turn
    print_board
    print "\n Human please make a move or type 'exit'(Format: columnrow): "
    STDOUT.flush
    input = gets.chomp.downcase
    
    len = input.length
    if len == 2
      a = input.to_s.split("")
      if(['a','b','c'].include? a[0])
        if(['1','2','3'].include? a[1])
          k = @board_sections.keys
          karr = k.to_s.scan(/../)
          count = 0
          karr.each do |c|
            if karr[count] == input
              break
            else
              count += 1
            end
          end
          if @board_sections[k[count]] == "_"
            @board_sections[k[count]] = @user
            puts " Human marks #{@user} in #{input.to_s.upcase}"
            is_game_over(@cpu)
          else
            puts " Section already taken! Pick an empty section"
            player_turn
          end
        else
          puts " The format is 'A1' , 'B3' , 'C2' etc. Try again!"
          player_turn
        end
      else
        puts " The format is 'A1' , 'B3' , 'C2' etc. Try again!"
        player_turn
      end
    else
      if input == "exit"
        @board_sections.clear
        puts "#{@board_sections}"
      else
        puts " The format is 'A1' , 'B3' , 'C2' etc. Try again!"
        player_turn
      end
    end
  end
  
  def sections_left
    @board_sections.values.select{ |v| v == "_" }.length
  end
  
  def is_game_over(who_won)
    game_over = nil
    
    @pos_win.each do |win_combin|
      # see if cpu has won
      if count_sym(win_combin, @cpu) == 3
        
        print_board
        
        puts ""
        puts " -----Game Over ----- \n"
        puts "Winner: CPU \n"
        game_over = true
        play_again(false)
      end
      # see if user has won
      if count_sym(win_combin, @user) == 3
        
        print_board
        
        puts ""
        puts " -----Game Over ----- \n"
        puts "Winner: Human \n"
        game_over = true
        play_again(true)
      end
    end
    
    unless game_over
      if(sections_left > 0)
        if(who_won == @user)
          player_turn
        else
          cpu_turn
        end
      else
        
        print_board
        
        puts ""
        puts " Game Over -- DRAW!\n"
        play_again(@user = 'X')
      end
    end
  end

  def play_again(who_is_first)
    print " Play again? (Yn): "
    STDOUT.flush
    response = gets.chomp.downcase
    case response
    when "y"   then replay_game(who_is_first)
    when "yes" then replay_game(who_is_first)
    when "n"   then #do nothing
    when "no"  then #do nothing
    else play_again(who_is_first)
    end
  end
end

TicTacToe.new