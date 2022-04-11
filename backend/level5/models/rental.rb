class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance
  attr_accessor :options

  def initialize(attr)
    @id = attr['id']
    @car = $cars.find { |car| car.id == attr['car_id'] }
    @start_date = Date.parse(attr['start_date'])
    @end_date = Date.parse(attr['end_date'])
    @distance = attr['distance']
    @options = []
  end

  def price_per_action_with_options_hash
    {
      id: id,
      options: options_list,
      actions: actions_array
    }
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

  def total_base_price
    duration_price + distance_price
  end

  def total_price
    total_base_price + options_price
  end

  def commission
    (total_base_price * 0.3).to_i
  end

  def insurance_fee
    (commission * 0.5).to_i
  end

  def assistance_fee
    duration * 100
  end

  def drivy_fee
    commission - insurance_fee - assistance_fee + additional_insurance_price
  end

  def owner_credit
    total_base_price - commission + gps_price + baby_seat_price
  end

  def actions_array
    [
      {
        "who": "driver",
        "type": "debit",
        "amount": total_price
      },
      {
        "who": "owner",
        "type": "credit",
        "amount": owner_credit
      },
      {
        "who": "insurance",
        "type": "credit",
        "amount": insurance_fee
      },
      {
        "who": "assistance",
        "type": "credit",
        "amount": assistance_fee
      },
      {
        "who": "drivy",
        "type": "credit",
        "amount": drivy_fee
      }
    ]
  end

  def options_list
    options.map(&:type)
  end

  def gps_price
    options_list.include?('gps') ? duration * 500 : 0
  end

  def baby_seat_price
    options_list.include?('baby_seat') ? duration * 200 : 0
  end

  def additional_insurance_price
    options_list.include?('additional_insurance') ? duration * 1000 : 0
  end

  def options_price
    gps_price + baby_seat_price + additional_insurance_price
  end
end
