class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance

  def initialize(attr)
    @id = attr['id']
    @car = $cars.find { |car| car.id == attr['car_id'] }
    @start_date = Date.parse(attr['start_date'])
    @end_date = Date.parse(attr['end_date'])
    @distance = attr['distance']
  end

  def price_with_commission_hash
    {
      id: id,
      price: total_price,
      commission: commission_hash
    }
  end

  def total_price
    duration_price + distance_price
  end

  def duration
    (end_date - start_date).to_i + 1
  end

  def distance_price
    distance * car.price_per_km
  end

  def duration_price
    price = 0
    for i in 1..duration
      case i
      when 1
        price += car.price_per_day
      when 1..4
        price += (car.price_per_day) * 0.9
      when 5..10
        price += (car.price_per_day) * 0.7
      else
        price += (car.price_per_day) * 0.5
      end
    end
    price.to_i
  end

  def commission
    (total_price * 0.3).to_i
  end

  def insurance_fee
    (commission * 0.5).to_i
  end

  def assistance_fee
    duration * 100
  end

  def drivy_fee
    commission - insurance_fee - assistance_fee
  end

  def commission_hash
    {
      "insurance_fee": insurance_fee,
      "assistance_fee": assistance_fee,
      "drivy_fee": drivy_fee
    }
  end
end
