class Deck
    attr_accessor :cards
    def initialize
        @cards = []
        build
    end

    def build
        [100, 200, 300, 400].each do |mark_no|
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11 ,12 ,13].each do |card_no|
                @cards.push(mark_no + card_no)
            end
        end
        @cards.shuffle!
    end

    def draw_card
        @cards.pop
    end
end

class Player
    attr_accessor :hand, :card, :score, :burst, :draw
    def initialize(name)
        @name = name
        @hand = []
        @card = ""
        @score = 0
        @burst = false
        @draw = true
    end

    def show_card(card)
        @card = card
        display_card = @card.to_s.slice(1, 2).to_i
        case @card.to_s.slice(0, 1).to_i
        when 1 then
            suit = "スペード"
        when 2 then
            suit = "クラブ"
        when 3 then
            suit = "ダイヤ"
        when 4 then
            suit = "ハート"
        end

        puts "#{@name}の引いたカードは「#{suit}の#{display_card}」です。"
    end

    def show_score
        @score = 0
        ace_flg = false
        @hand.each do |card|
            point = card.to_s.slice(1, 2).to_i
            if point > 10 then point = 10 end
            if point == 1 then ace_flg = true end
            @score += point
        end
        if @score > 21 then
            @burst = true
            @draw = false
        elsif ace_flg == true then
            @score += 10
            if @score > 21 then @score -= 10 end
        end
        puts "#{@name}の得点は#{@score}です。"
    end
end

class User < Player
    def draw_card(deck, input_flg)
        loop_flg = false
        while loop_flg == false do
            if input_flg == true then
                puts "カードを引きますか?(引く:Y, 引かない:N)"
                line = gets.chop
            end
            if line == "y" || line == "Y" || input_flg == false then
                card = deck.draw_card
                @hand.push(card)
                show_card(card)
                loop_flg = true
            elsif line == "n" || line == "N" then
                @draw = false
                loop_flg = true
            else
                puts "YもしくはNで入力してください。"
            end
        end
    end
end

class Dealer < Player
    def draw_card(deck, show_flg)
        if @score < 17 then
            card = deck.draw_card
            @hand.push(card)
            if show_flg == true
                show_card(card)
            elsif show_flg == false
                puts "#{@name}の2枚目のカードはわかりません。"
            end
        else
            @draw = false
        end
    end

    def show_second_card(card)
        @card = card
        display_card = @card.to_s.slice(1, 2).to_i
        case @card.to_s.slice(0, 1).to_i
        when 1 then
            suit = "スペード"
        when 2 then
            suit = "クラブ"
        when 3 then
            suit = "ダイヤ"
        when 4 then
            suit = "ハート"
        end

        puts "#{@name}の2枚目のカードは「#{suit}の#{display_card}」でした。"
    end
end

puts "◆ブラックジャック◆"
puts "ゲームを開始します。"

deck = Deck.new
user = User.new("あなた")
dealer = Dealer.new("ディーラー")

user.draw_card(deck, false)
user.draw_card(deck, false)
dealer.draw_card(deck, true)
dealer.draw_card(deck, false)
user.show_score

loop do
    if user.draw == true then
        if user.burst == false then user.draw_card(deck, true) end
        if user.draw == true then user.show_score end
    end
    if user.draw == false || user.burst == true then
        break
    end
end

dealer.show_second_card(dealer.hand[1])
dealer.show_score
loop do
    if dealer.draw == true && user.burst == false then
        if dealer.burst == false then dealer.draw_card(deck, true) end
        if dealer.draw == true then dealer.show_score end
    end
    if dealer.draw == false || dealer.burst == true || user.burst == true then
        break
    end
end

if user.burst == true && dealer.burst == false || user.score < dealer.score && dealer.burst == false then
    puts "あなたの負けです。"
elsif dealer.burst == true && user.burst == false || user.score > dealer.score && user.burst == false then
    puts "あなたの勝ちです。" 
elsif user.burst = true && dealer.burst == true || user.score == dealer.score then
    puts "引き分けです。"
end
