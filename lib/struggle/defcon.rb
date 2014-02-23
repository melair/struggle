class Defcon
  attr_reader :value, :destroyed_by

  def initialize(value = 5)
    @value = value
    @destroyed_by = nil
  end

  def improve(amount = nil)
    raise ArgumentError, "Must be positive" if amount < 0

    set(nil, [value + amount, 5].min)
  end

  def degrade(player, amount)
    raise ArgumentError, "Must be positive" if amount < 0

    set(player, value - amount)
  end

  def set(player, value)
    if player.nil? && value == 1
      raise ArgumentError, "Player needed when setting DEFCON to WAR!"
    end

    if nuclear_war?
      raise ImmutableDefcon, "DEFCON can no longer be changed."
    end

    unless (1..5).include? value
      raise InvalidDefcon, "Invalid DEFCON value #{value.inspect}"
    end

    @value = value

    declare_nuclear_war(player) if value <= 1
  end

  def declare_nuclear_war(player)
    @destroyed_by = player
  end

  def nuclear_war?
    destroyed_by
  end

  DEFCON_RESTRICTIONS = {
    5 => [],
    4 => [Europe],
    3 => [Europe, Asia],
    2 => [Europe, Asia, MiddleEast]
  }

  # Returns a list of regions that are defcon-restricted by
  # the current DEFCON level.

  def restricted_regions
    DEFCON_RESTRICTIONS.fetch(value) do |key|
      raise ArgumentError, "DEFCON is at 1, why are you asking?"
    end
  end

  # Returns true if the given country is in the list of DEFCON
  # restricted regions.

  def affects?(country)
    !(country.regions & restricted_regions).empty?
  end

end

ImmutableDefcon = Class.new(StandardError)
InvalidDefcon = Class.new(StandardError)
