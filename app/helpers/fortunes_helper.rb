module FortunesHelper
  def params_change(params)
    return "おひつじ座" if params == "ohitsuji"
    return "おうし座" if params == "oushi"
    return "ふたご座" if params == "futago"
    return "かに座" if params == "kani"
    return "しし座" if params == "shishi"
    return "おとめ座" if params == "otome"
    return "てんびん座" if params == "tenbin"
    return "さそり座" if params == "sasori"
    return "いて座" if params == "ite"
    return "やぎ座" if params == "yagi"
    return "みずがめ座" if params == "mizugame"
    return "うお座" if params == "uo"
  end

  def params_change_reverse(params)
    return "ohitsuji" if params == "おひつじ座"
    return "oushi" if params == "おうし座"
    return "futago" if params == "ふたご座"
    return "kani" if params == "かに座"
    return "shishi" if params == "しし座"
    return "otome" if params == "おとめ座"
    return "tenbin" if params == "てんびん座"
    return "sasori" if params == "さそり座"
    return "ite" if params == "いて座"
    return "yagi" if params == "やぎ座"
    return "mizugame" if params == "みずがめ座"
    return "uo" if params == "うお座"
  end

  def gogototal_search_no1(fortune, sign)
    @no1_array = []
    @no1_array << "総合1位" if fortune.total_no1 == sign
    @no1_array << "金運1位" if fortune.gold_no1 == sign
    @no1_array << "恋愛運1位" if fortune.love_no1 == sign
    @no1_array << "仕事運1位" if fortune.work_no1 == sign
    @no1_array << "健康運1位" if fortune.health_no1 == sign
    return @no1_array
  end

  def gudetama_hogehogenahito(rank)
    @hogehogenahito = "'ぐー'な人" if rank <= 5
    @hogehogenahito = "'でーじょうぶ'な人" if rank > 5 && rank <= 8
    @hogehogenahito = "'たいへんかも…'な人" if rank > 8 && rank <= 11
    @hogehogenahito = "'マズイかも…'な人" if rank == 12
    return @hogehogenahito
  end

  def sukkirisu_hogehogerisu(rank)
    @hogehogerisu = "超スッキりす" if rank == 1
    @hogehogerisu = "スッキりす" if rank != 1 && rank <= 6
    @hogehogerisu = "まあまあスッキりす" if rank > 6 && rank <= 11
    @hogehogerisu = "ガッカりす…" if rank == 12
    return @hogehogerisu
  end

  def img_select(sign)
    @img_url = "/assets/ohitsuji.png" if sign == "おひつじ座"
    @img_url = "/assets/oushi.png" if sign == "おうし座"
    @img_url = "/assets/futago.png" if sign == "ふたご座"
    @img_url = "/assets/kani.png" if sign == "かに座"
    @img_url = "/assets/shishi.png" if sign == "しし座"
    @img_url = "/assets/otome.png" if sign == "おとめ座"
    @img_url = "/assets/tenbin.png" if sign == "てんびん座"
    @img_url = "/assets/sasori.png" if sign == "さそり座"
    @img_url = "/assets/ite.png" if sign == "いて座"
    @img_url = "/assets/yagi.png" if sign == "やぎ座"
    @img_url = "/assets/mizugame.png" if sign == "みずがめ座"
    @img_url = "/assets/uo.png" if sign == "うお座"
    return @img_url
  end

  def month_img_select(month)
    @img_url = "/assets/month1.png" if month == 1
    @img_url = "/assets/month2.png" if month == 2
    @img_url = "/assets/month3.png" if month == 3
    @img_url = "/assets/month4.png" if month == 4
    @img_url = "/assets/month5.png" if month == 5
    @img_url = "/assets/month6.png" if month == 6
    @img_url = "/assets/month7.png" if month == 7
    @img_url = "/assets/month8.png" if month == 8
    @img_url = "/assets/month9.png" if month == 9
    @img_url = "/assets/month10.png" if month == 10
    @img_url = "/assets/month11.png" if month == 11
    @img_url = "/assets/month12.png" if month == 12
    return @img_url
  end

  def overallRanking(sign)
    sum = 0
    point = 3
    for i in 0..2 do
      sum += point if sign == @mezamashi[i].sign
      sum += point if sign == @gudetama[i].sign
      point -= 1
    end
    sum += 3 if sign == @gogo_total_no1.sign
    sum += 1 if sign == @gogo_gold_no1.sign
    sum += 1 if sign == @gogo_love_no1.sign
    sum += 1 if sign == @gogo_work_no1.sign
    sum += 1 if sign == @gogo_health_no1.sign
    return sum
  end

  def fortune_result(sign)
    @meza_result = ["f", "f", "f"]
    @gude_result = ["f", "f", "f"]
    @gogo_result = ["f", "f", "f", "f", "f"]
    for i in 0..2 do
      @meza_result[i] = "t" if sign == @mezamashi[i].sign
      @gude_result[i] = "t" if sign == @gudetama[i].sign
    end
    @gogo_result[0] = "t" if sign == @gogo_total_no1.sign
    @gogo_result[1] = "t" if sign == @gogo_gold_no1.sign
    @gogo_result[2] = "t" if sign == @gogo_love_no1.sign
    @gogo_result[3] = "t" if sign == @gogo_work_no1.sign
    @gogo_result[4] = "t" if sign == @gogo_health_no1.sign
  end

  # AMAZON API
  def searchLuckyItemByAmazon(lucky_item)
    Amazon::Ecs.configure do |options|
      options[:AWS_access_key_id] = ENV['AMAZON_ACCESS_KEY']
      options[:AWS_secret_key] = ENV['AMAZON_SECRET_KEY']
      options[:associate_tag] = ENV['AMAZON_ASSOCIATE_TAG']
    end
    Amazon::Ecs.debug = true
    amazon_lucky_items = Amazon::Ecs.item_search(
      lucky_item,
      search_index: 'All',
      dataType: 'script',
      response_group: 'ItemAttributes, Images',
      country:  'jp',
    )
    first_item = amazon_lucky_items.items.first
    if first_item == nil
      @lucky_item = {image: nil}
    else
      @lucky_item = {
        # title: first_item.get('ItemAttributes/Title'),
        # url: first_item.get('DetailPageURL'),
        image: first_item.get('MediumImage/URL')
      }
    end
  end
end
