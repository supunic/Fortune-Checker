class Sukkirisu < ApplicationRecord
  # スッキりす誕生月占い（スッキリ/日本テレビ/月〜金/ ）
  def self.sukkirisuFortune(month)
    page    = Faraday.get('https://www.ntv.co.jp/sukkiri/sukkirisu/index.html')
    page_ja = page.body.toutf8

    month_index          = page_ja.index('<span>'+month.to_s+'</span>月')
    
    tyosukkirisu_index     = page_ja.index('超スッキリす')
    month_row1_index     = page_ja.rindex('row1', month_index)
    month_row2_index     = page_ja.index('row2', month_index)

    month_row2_p_index        = page_ja.index('<p>', month_row2_index)
    month_row2_div_index      = page_ja.index('<div', month_row2_index)

    month_row1_rank_index_start     = page_ja.index('>', month_row1_index + 10)
    month_row1_rank_index_end       = page_ja.index('位', month_row1_index)
    month_row2_p_index_start     = page_ja.index('>', month_row2_p_index + 1)
    month_row2_p_index_end       = page_ja.index('<', month_row2_p_index + 1)
    month_row2_div_index_start   = page_ja.index('>', month_row2_div_index + 1)
    month_row2_div_index_end     = page_ja.index('<', month_row2_div_index + 1)

    if month_row1_rank_index_end
      @rank  = page_ja.slice(month_row1_rank_index_start + 1 .. month_row1_rank_index_end - 1).to_i
    elsif tyosukkirisu_index < month_index
      @rank = 1
    else
      @rank = 12
    end
    @text  = page_ja.slice(month_row2_p_index_start + 1 .. month_row2_p_index_end - 1)
    @color = page_ja.slice(month_row2_div_index_start + 1 .. month_row2_div_index_end - 1)

    Sukkirisu.create(month: month, rank: @rank, text: @text, lucky_color: @color)
  end
end
