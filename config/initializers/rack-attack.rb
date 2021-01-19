class Rack::Attack
  # 同一IPアドレスからのリクエストを300回/5分に制限
  throttle('req/ip', :limit => 300, :period => 5.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end
end