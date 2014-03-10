class Game
  attr_accessor :countries, :deck, :turn, :defcon, :china_card, :space_race,
                :cards, :military_ops, :victory_track, :hands, :phasing_player,
                :current_cards, :discards, :removed, :limbo, :victory, :rng,
                :die, :injector, :guard_resolver, :events

  def initialize
    self.injector = Injector.new(self)

    self.cards = Cards.new
    self.countries = Countries.new(COUNTRY_DATA)

    self.rng = Random.new
    self.die = Die.new(rng)
    self.deck = Deck.new
    self.turn = TurnMarker.new
    self.defcon = Defcon.new
    self.victory = Victory.new
    self.china_card = ChinaCard.new
    self.space_race = SpaceRace.new
    self.military_ops = MilitaryOps.new
    self.victory_track = VictoryTrack.new
    self.phasing_player = PhasingPlayer.new

    self.hands = Hands.new

    # Cards that are currently being played.
    self.current_cards = Set.new

    self.discards = Set.new
    self.removed = Set.new

    # Limbo is for cards that stay on the board but get put into the discard
    # pile once they are cancelled (i.e. Shuttle Diplomacy).
    self.limbo = Set.new

    self.events = Events::Finder.new(injector)
    self.guard_resolver = GuardResolver.new(injector)

    @engine = Engine.new
    @engine.injector = injector
  end

  def start
    @engine.add_work_item GameInstructions
  end

  def accept(move)
    @engine.accept move
  end

  def hint
    @engine.peek
  end

  def hand(player)
    hands.get(player)
  end

  def observers
    @engine.observers
  end
end

def Instruction(const, **named_args, &block)
  Instructions.const_get(const).new(named_args, &block)
end

def List(*args)
  Instructions::NestingInstruction.new(*args)
end

def Arbitrator(const, **named_args, &block)
  Arbitrators.const_get(const).new(named_args, &block)
end

alias I Instruction
alias L List

# Markers
module Instructions
  ActionRoundsEnd = Class.new(Instructions::Noop)
end

Setup = List(
  Instruction(:AddToDeck, phase: :early),
  Instruction(:DealCards, target: 8),
  Instruction(:ClaimChinaCard, player: USSR, playable: true),
  Instruction(:StartingInfluence)
)

# TODO
def HeadlinePhase
  I(:Noop, label: "Headline phase is unimplemented")
end

def Turn(phase:)
  cards  = { early: 8, mid: 9, late: 9 }
  rounds = { early: 6, mid: 7, late: 7 }

  List(
    I(:ImproveDefcon, amount: 1),
    I(:DealCards, target: cards[phase]),
    HeadlinePhase(),

    *rounds[phase].times.map { |n| I(:ActionRound, number: n + 1) },

    I(:OptionalActionRound, number: rounds[phase] + 1),

    I(:ActionRoundsEnd), # for certain events to trigger off of
    I(:CheckMilitaryOps),
    I(:ResetMilitaryOps),
    I(:CheckHeldCards), # check no scoring cards
    I(:FlipChinaCard), # make it 'playable'
    DiscardHeldCard, # only available with space race #6
    I(:AdvanceTurn)
  )
end

def Phase(phase)
  List(
    # Early phase cards are dealt before the phase begins.
    *phase != :early ? Instruction(:AddToDeck, phase: phase) : nil,
    Turn(phase: phase),
    Turn(phase: phase),
    Turn(phase: phase)
  )
end

# TODO Award the holder of The China Card at the end of Turn 10 with 1 VP.
AwardChinaCardHolder =
  I(:Noop, label: "Awarding 1 VP to holder of China Card is unimplemented")

# TODO
# Allow optional discarding of a held card by any qualifiying player
# (space race bonus)
#
# Instruction that (if modifier present) returns an arbitrator that allows
# the player to choose a card to be discarded
DiscardHeldCard = List()

FinalScoring = List(
  AwardChinaCardHolder
)

GameInstructions = List(
  Setup,
  Phase(:early),
  Phase(:mid),
  Phase(:late),
  FinalScoring, # set a winner here if applicable
  I(:EndGame)
)

