require_relative("../db/sql_runner.rb")

class Roaster

  attr_accessor :id, :name, :location, :total_sold, :blurb

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @location = options["location"]
    @total_sold = 0
    @blurb = options["blurb"]
  end

  # .save
  def save()
    sql = "
      INSERT INTO roasters (
        name,
        location,
        total_sold,
        blurb
      )
      VALUES ($1, $2, $3, $4)
      RETURNING id;
    "
    values = [@name, @location, @total_sold, @blurb]
    results = SqlRunner.run(sql, values)
    @id = results[0]["id"].to_i
  end

  def update()
    sql = "
      UPDATE roasters
      SET (
        name,
        location,
        total_sold,
        blurb
      ) = ($1, $2, $3, $4)
      WHERE id = $5;
    "
    values = [@name, @location, @total_sold, @blurb, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "
      DELETE FROM roasters
      WHERE id = $1;
    "
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "
      SELECT * FROM roasters;
    "
    results = SqlRunner.run(sql)
    return results.map { |roaster_hash| Roaster.new(roaster_hash) }
  end

  def self.delete_all()
    sql = "
      DELETE FROM roasters;
    "
    SqlRunner.run(sql)
  end

  def coffees()
    sql = "
    SELECT * FROM coffees
    WHERE roaster_id = $1;
    "
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map { |coffee_hash| Coffee.new(coffee_hash) }
  end

  def self.find(id)
    sql = "
      SELECT * FROM roasters
      WHERE id = $1;
    "
    values = [id]
    results = SqlRunner.run(sql, values)
    return Roaster.new(results[0])
  end

end
