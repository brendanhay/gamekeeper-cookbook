actions :create

# Default action
def initialize(*args)
  super
  @action = :create
end

attribute :node_name,      :kind_of => String, :name_attribute => true
attribute :settings,       :kind_of => GameKeeper::Settings, :required => true
attribute :high_watermark, :kind_of => Float, :required => true
attribute :checks,         :kind_of => Hash, :required => true, :default => {}
