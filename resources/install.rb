actions :install

# Default action
def initialize(*args)
  super
  @action = :install
end

attribute :settings, :kind_of => GameKeeper::Settings, :name_attribute => true
