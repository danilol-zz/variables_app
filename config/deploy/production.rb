set :stage, :production
set :branch, 'master'
set :keep_releases, 5

# Replace 127.0.0.1 with your server's IP address!
server '192.168.1.96', user: 'deploy', roles: %w{web app}
