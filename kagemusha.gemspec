
Gem::Specification.new do |s|
  s.specification_version     = 2
  s.required_rubygems_version = Gem::Requirement.new(">= 0")
  s.required_ruby_version     = Gem::Requirement.new(">= 1.8.6")

  s.name    = "kagemusha"
  s.version = "0.0.9"
  s.date    = "2009-06-29"

  s.authors = ["Yuya Kato"]
  s.email   = "yuyakato@gmail.com"

  s.summary     = "kagemusha"
  s.description = "kagemusha"
  s.homepage    = "http://github.com/nayutaya/kagemusha/"

  s.rubyforge_project = nil
  s.has_rdoc          = false
  s.require_paths     = ["lib"]

  s.files = [
    "examples/date.rb",
    "examples/datetime.rb",
    "examples/first.rb",
    "examples/rand.rb",
    "examples/style.rb",
    "examples/time.rb",
    "HISTORY",
    "HISTORY.ja",
    "kagemusha.gemspec",
    "kagemusha.gemspec.erb",
    "lib/kagemusha/composite.rb",
    "lib/kagemusha/core.rb",
    "lib/kagemusha/date.rb",
    "lib/kagemusha/datetime.rb",
    "lib/kagemusha/rand.rb",
    "lib/kagemusha/time.rb",
    "lib/kagemusha/version.rb",
    "lib/kagemusha.rb",
    "LICENSE",
    "Rakefile",
    "README",
    "README.ja",
    "test/test_bugs.rb",
    "test/test_complex_cases.rb",
    "test/test_composite.rb",
    "test/test_date.rb",
    "test/test_datetime.rb",
    "test/test_helper.rb",
    "test/test_kagemusha.rb",
    "test/test_rand.rb",
    "test/test_time.rb",
  ]
  s.test_files = [
    "test/test_bugs.rb",
    "test/test_complex_cases.rb",
    "test/test_composite.rb",
    "test/test_date.rb",
    "test/test_datetime.rb",
    "test/test_helper.rb",
    "test/test_kagemusha.rb",
    "test/test_rand.rb",
    "test/test_time.rb",
  ]
  s.extra_rdoc_files = []
end
