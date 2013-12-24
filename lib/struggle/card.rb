class Card
  attr_accessor :ref, :id, :name, :phase, :ops, :side
  attr_accessor :remove_after_event, :discard_after_event, :always_evaluate_first

  def initialize(**args)
    args.each { |k,v| send("#{k}=", v) }
  end

  def scoring?
    ops.zero?
  end

  def early?
    phase == :early
  end

  def inspect
    star = remove_after_event ? "*" : ""
    underline = "" # display on board until cancelled - TODO?

    "%3s: [%s %4s %-5s] %s%s%s%s" % [
      id, ops, side || '-', phase.to_s.upcase, underline, name, underline, star
    ]
  end
end

