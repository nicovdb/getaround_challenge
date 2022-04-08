class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance

  def initialize(attr)
    @id = attr['id']
    @car = $cars.find { |car| car.id == attr['car_id'] }
    @start_date = Date.parse(attr['start_date'])
    @end_date = Date.parse(attr['end_date'])
    @distance = attr['distance']
  end

  def price_hash
    { id: id, price: total_price }
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
end
