Gem::Specification.new do |s|
  s.name        = 'r1411-students'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = "Models and controllers for students app"
  s.description = "This gem contains models and controllers for students app. You need to make your own views."
  s.authors     = ["r1411"]
  s.email       = 'roma00055@gmail.com'
  s.files       = Dir['controllers/*']
  s.files       += Dir['db_config/migrations/*'] + Dir['db_config/config.example.yaml']
  s.files       += Dir['models/*']
  s.files       += Dir['repositories/*']
  s.files       += Dir['util/*']
  s.homepage    = 'https://rubygems.org/gems/r1411-students'
  s.metadata    = { "source_code_uri" => "https://github.com/r1411/PatternsLabs" }
  s.required_ruby_version = '>= 3.0'
end