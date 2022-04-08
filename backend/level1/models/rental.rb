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
    duration = (end_date - start_date).to_i + 1
    total_price = duration * car.price_per_day + distance * car.price_per_km
    { id: id, price: total_price }
  end
end
