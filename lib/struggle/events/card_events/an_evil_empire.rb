module Events
  module CardEvents

    class AnEvilEmpire < Instruction

      def action
        instructions = []

        instructions << Instructions::AwardVictoryPoints.new(
          player: US,
          amount: 1
        )

        instructions << Instructions::Remove.new(
          card_ref: "AnEvilEmpire"
        )

        instructions
      end

    end

  end
end
