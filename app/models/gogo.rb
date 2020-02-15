class Gogo < ApplicationRecord
  # ゴーゴー星占い（グッド！モーニング/テレビ朝日/月〜金/ ）
  def self.gogoFortune(sign)
    # set up
    page = Faraday.get('https://www.tv-asahi.co.jp/goodmorning/uranai/')
    @sign = sign
    @page_ja = page.body.toutf8

    # common
    seiza_contents_index = @page_ja.index('seiza-contents')

    @sign_index = @page_ja.index(@sign, seiza_contents_index)
    lucky_box_start_index = @page_ja.index('"lucky-box"', @sign_index)
    lucky_box_end_index = @page_ja.index('"seiza-box-top"', @sign_index)

    # function
    def self.getRank()
      rank_area_index = @page_ja.index('"rank-area"')
      rank_sign_index = @page_ja.index(@sign, rank_area_index)
      rank_image_index = @page_ja.rindex('images/rank', rank_sign_index)
      rank_start_index = @page_ja.index('-', rank_image_index)
      rank_end_index = @page_ja.index('.png', rank_start_index)
 
      return @page_ja.slice(rank_start_index + 1 .. rank_end_index - 1)
    end

    def self.getText(target, start_mark, end_mark)
      target_index = @page_ja.index(target, @sign_index)
      start_index = @page_ja.index(start_mark, target_index)
      end_index = @page_ja.index(end_mark, start_index)

      return @page_ja.slice(start_index + 1 .. end_index - 1)
    end

    def self.getLuckeyBoxCount(target, start_index, end_index)
      target_count = 0
      target_index = @page_ja.index(target, start_index)

      while target_index < end_index
        target_count += 1
        target_index = @page_ja.index(target, target_index + 1)

        break if target_index === nil
      end

      return target_count
    end

    # scraping
    @rank = getRank().to_i
    @text = getText('"read"', '>', '<')
    @lucky_color = getText('ラッキーカラー', '：', '<')
    @lucky_item = getText('幸運のカギ', '：', "\n\t")
    @kinun = getLuckeyBoxCount('"icon-money"', lucky_box_start_index, lucky_box_end_index)
    @renai = getLuckeyBoxCount('"icon-love"', lucky_box_start_index, lucky_box_end_index)
    @shigoto = getLuckeyBoxCount('"icon-work"', lucky_box_start_index, lucky_box_end_index)
    @kenko = getLuckeyBoxCount('"icon-health"', lucky_box_start_index, lucky_box_end_index)

    # create
    Gogo.create(
      sign: @sign,
      rank: @rank,
      text: @text,
      lucky_color: @lucky_color,
      lucky_item: @lucky_item,
      kinun: @kinun,
      renai: @renai,
      shigoto: @shigoto,
      kenko: @kenko
    )
  end
end
