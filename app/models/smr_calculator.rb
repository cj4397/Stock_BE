class SmrCalculator
  def initialize(amount,invest,sell,item, available)
    @amount= amount
    @invest=invest
    @item=item
    @sell=sell 
    @available=available
     
  end

  def asset
   (@invest.fdiv(@amount)).round(3)
  end

  def invest
    (asset * @amount)
  end

  def amount
   ((@item.asset + asset) * @amount)

  end

  def add_asset
    (@available.asset.to_f + asset).round(3)
  end

  def sub_asset
    (@item.asset.to_f - @sell).round(3)
  end

  def total_invest
    (sub_asset * @amount)
  end

end