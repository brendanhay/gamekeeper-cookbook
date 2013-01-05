action :create do
  res = new_resource

  gamekeeper_install res.settings

  runit_service "gamekeeper" do
    cookbook "gamekeeper"
    template_name "gamekeeper"
    logger :local

    options({
      :home      => res.settings.home,
      :user      => res.settings.user,
      :path      => res.settings.bin,
      :uri       => res.settings.uri,
      :frequency => res.frequency,
      :days      => res.stale_after,
      :sink      => res.sink.capitalize,
      :host      => res.host,
      :port      => res.port
    })
  end
end
