set :stage, :production
set :branch, 'master'

server '192.168.1.101', user: 'deploy', roles: %w{web app db}
