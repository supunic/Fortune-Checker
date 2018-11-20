class Sukkirisu < ApplicationRecord
  # スッキりす誕生月占い（スッキリ/日本テレビ/月〜金/ ）
  def self.sukkirisuFortune(month)
    page = Faraday.get('http://www.ntv.co.jp/sukkiri/sukkirisu/index.html')
    page_ja = page.body.toutf8

    n = page_ja.index('type1')
    number = page_ja.rindex('div', n)
    month_num = page_ja.index('month'+month.to_s+'"', number)
    rank2_num = page_ja.index('2位', number)
    rank11_num = page_ja.index('11位', number)

    color_num = page_ja.index('color', month_num)
    start_num = page_ja.index('>', color_num)
    end_num = page_ja.index('<', start_num)
    @color = page_ja.slice(start_num+1..end_num-1)

    if rank2_num < color_num && month_num < rank11_num
      rankTxt_num = page_ja.index('rankTxt', month_num)
      start_num = page_ja.index('>', rankTxt_num)
      end_num = page_ja.index('<', start_num)
      @rankTxt = page_ja.slice(start_num+1..end_num-1)

      rankTxt_p_num = page_ja.index('p', rankTxt_num+15)
      start_num = page_ja.index('>', rankTxt_p_num)
      end_num = page_ja.index('<', start_num)
      @rankTxt_p = page_ja.slice(start_num+1..end_num-1)

    elsif rank2_num > color_num
      @rankTxt = "1位"

      mTxt_num = page_ja.index('mTxt', month_num)
      mTxt_p_num = page_ja.index('p', mTxt_num)
      start_num = page_ja.index('>', mTxt_p_num)
      end_num = page_ja.index('<', start_num)
      @rankTxt_p = page_ja.slice(start_num+1..end_num-1)

    else
      @rankTxt = "12位"

      mTxt_num = page_ja.index('mTxt', month_num)
      mTxt_p_num = page_ja.index('p', mTxt_num)
      start_num = page_ja.index('>', mTxt_p_num)
      end_num = page_ja.index('<', start_num)
      @rankTxt_p = page_ja.slice(start_num+1..end_num-1)
    end
    Sukkirisu.create(month: month, rank: @rankTxt, text: @rankTxt_p, lucky_color: @color)
  end
end
