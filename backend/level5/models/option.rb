class Option
  attr_reader :id, :rental_id, :type

  def initialize(attr)
    @id = attr['id']
    @rental_id = attr['rental_id']
    @type = attr['type']
  end
end
