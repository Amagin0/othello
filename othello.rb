# 参照 https://github.com/TomoProg/RubyOsero/blob/master/ruby_osero.rb
# 解説 https://tomoprog.hatenablog.com/entry/2017/03/29/001156

class Othello
  BLANK = "・"  # 何も置いてない
  BLACK = "○"   # 黒石
  WHITE = "●"   # 白石
  WALL  = "■"   # 端
  MAX_ROW = 10  # 行
  MAX_COL = 10  # 列
  @@field = nil # フィールド
  @@turn = nil  # ターン
  
  def run()
    # 初期化
    @@turn = BLACK
    make_field()
    print_field()

    while turn
      puts "<< #{@@turn}のターン>>"

      # 石を置ける場所のチェック
      where_put_list = search_put_stone(@@turn)
      if where_put_list.empty?
        puts "置ける場所がないため、#{@@turn}のターンを飛ばします"
        change_turn()
        next
      end

      # 石を置く座標の指定
      # puts "置ける場所" => #{where_put_list}
      print "置き場所を横、縦で指定してください。例) 1,2 --->"
      put_stone = gets  # 指定された数値の入力を取得

      # 入力された文字のチェック
      if !check_input(put_stone)
        next
      end

      # 置かれた場所のチェック
      put_stone = put_stone.chomp().split(",") # 改行を取り除き、カンマで区切る
      row = Integer(put_stone[0].strip)
      col = Integer(put_stone[1].strip)
      if !where_put_list.include?([row, col])
        puts "指定された場所に置くことはできません"
        next
      end

      # 反転処理
      reverse(row, col)

      # 盤面表示
      print_field()

      # 終了判定
      if finish?()
        break
      end

      # ターン交代
      change_turn()
    end

    # 結果表示
    print_result()
  end

  # 入力された数値のチェック
  def check_input(input)
  input = input.chomp.split(",")
  if input.length != 2
    puts "石を置く場所を正しく指定してください"
    return false
  end

  # 入力されたものが数値かのチェック
  def !integer_string?(input[0].strip) || !integer_string?(input[1].strip)
    puts "石を置く場所を数値で指定してください"
    return false
  end

  def search_put_stone(turn)
    enemy = get_enemy(turn)
    where_put_list = []
    # 時計回りに方向を定義
    directions = [[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,1],[-1,-1]]

    for row_num in 0..(MAX_ROW - 1)
      for col_num in 0..(MAX_COL - 1)
        if @@field[row_num][col_num] != BLANK
          next
        end

        # 置いた石の周りに相手の石があるか確認
        directions.each do |direction|
          can_put_flag = false
          search_row = row_num + direction[0]
          search_col = col_num + direction[1]

          # 相手の石でない場合は次の方向を確認
          if @@field[search_row][search_col] != enemy
            next
          end

          # 見つけた方向を捜査していく
          while true
            search_row += direction[0]
            search_col += direction[1]
            if @@field[search_row][search_col] != enemy && @@field[search_row][search_col] != turn
              break
            elsif @@field[search_row][search_col] == enemy
              next
            else
              where_put_list << [row_num, col_num]
              can_put_flag = true
              break
            end
          end

          if can_put_flag
            break
          end
        end
      end
    end

    return where_put_list
  end



  def make_field()
    @@field = [] #@@field配列を作成
    10.times do #@@fieldの中に、2つ目の配列を10個作成
      row = []
      10.times do #2つ目の配列の中にBLANKを10個作成
        row << BLANK
      end
      @@field << row # @@fieldにBLANKが10個入る
    end
    0.upto(MAX_COL - 1) do |i| # 配列は0スタートなため-1する(0-9を代入できる) 
      @@field[0][i] = WALL            # 最上部に■を配置
      @@field[MAX_COL - 1][i] = WALL  # 最下部に■を配置
    end
    0.upto(MAX_ROW - 1) do |i|
      @@field[i][0] = WALL            # 左端に■を配置
      @@field[i][MAX_ROW - 1] = WALL  # 右端に■を配置
    end

    @@field[4][4] = WHITE  # 初期配値
    @@field[5][5] = WHITE
    @@field[4][5] = BLACK
    @@field[5][4] = BLACK
  end

  def print_field
    print "  "
    0.upto(MAX_COL - 1) do |i|
      print i.to_s + " "
    end
    print "\n"

    for i in 0..(MAX_ROW - 1)
      print i.to_s
      row = field[i]
      row.each do |stone|
        print stone
      end
      print "\n"
    end
  end



end

