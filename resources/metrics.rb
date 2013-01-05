actions :create

# Default action
def initialize(*args)
  super
  @action = :create
end

attribute :sink,        :kind_of => String, :name_attribute => true # Ganglia, Graphite, Statsd, Stdout
attribute :settings,    :kind_of => GameKeeper::Settings, :required => true
attribute :stale_after, :kind_of => Integer, :default => 10 # Days
attribute :frequency,   :kind_of => Integer, :default => 10 # Seconds
attribute :host,        :kind_of => String,  :default => "localhost"
attribute :port,        :kind_of => Integer, :default => 0

