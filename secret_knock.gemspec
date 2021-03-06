Gem::Specification.new do |s|
  s.name = 'secret_knock'
  s.version = '0.3.1'
  s.summary = 'Listens for a hidden message in a succession of knocks (or button presses) using timing.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/secret_knock.rb']
  s.signing_key = '../privatekeys/secret_knock.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/secret_knock'
end
