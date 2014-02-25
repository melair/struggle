module Instructions; end

require_relative "instructions/add_current_card"
require_relative "instructions/add_influence"
require_relative "instructions/add_to_deck"
require_relative "instructions/advance_turn"
require_relative "instructions/award_victory_points"
require_relative "instructions/check_held_cards"
require_relative "instructions/check_military_ops"
require_relative "instructions/claim_china_card"
require_relative "instructions/coup"
require_relative "instructions/deal_cards"
require_relative "instructions/declare_winner"
require_relative "instructions/degrade_defcon"
require_relative "instructions/dispose_current_cards"
require_relative "instructions/end_game"
require_relative "instructions/final_scoring"
require_relative "instructions/flip_china_card"
require_relative "instructions/improve_defcon"
require_relative "instructions/increment_military_ops"
require_relative "instructions/nesting_instruction"
require_relative "instructions/noop"
require_relative "instructions/play_card"
require_relative "instructions/realignment"
require_relative "instructions/remove_card_from_hand"
require_relative "instructions/remove_current_card"
require_relative "instructions/remove_influence"
require_relative "instructions/reset_military_ops"
require_relative "instructions/set_phasing_player"
require_relative "instructions/surrender_china_card"

# Generates:
#  instructions/discard
#  instructions/remove
#  instructions/limbo
require_relative "instructions/card_dumpers"

