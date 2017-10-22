APP_DIR = '~/projects/skela'
PORT = 3000
IDE_PATH = '/opt/RubyMine-2016.1.2/bin/rubymine.sh'

require 'yaml'
config = YAML.load_file("/home/jef/projects/skelaplex/skeletons.yml")

def tmux_running?
  false
end



postgres = false

start_server_code = if postgres
  "bundle exec passenger start -p #{PORT}"
else
  "rails s -p #{PORT}"
end


def tmux(code)
  `tmux #{code}`
end

def start_tmux
  tmux 'start-server'
end


def make_alias
  skelaplex_path = "ruby #{File.dirname(__FILE__)}/skelaplex.rb"
  
  puts 'Creating permanent alias...'
  `echo 'alias skelaplex=\"#{skelaplex_path}\"' >> ~/.bash_aliases`

  puts 'Done. Restart your terminal and enter `skelaplex` to set up your environment.'
end

def new_session(session_name, window_name)
  tmux "new-session -d -s #{session_name} -n #{window_name}"
end

def new_window(session, index, name)
  tmux "new-window -t #{session}:#{index} -n #{name}"
end


# STUFF STARTS HERE

if ARGV.empty?
  folder = config['default']
  skeleton = config[folder]
else
  folder = ARGV[0]
  skeleton = config[folder]
end

if skeleton
  title = skeleton['title']
  puts title
  if tmux_running?
    puts 'tmux server already running'
  else
    start_tmux
  end
  new_session title, 'Server'
end


tmux "select-window -t #{title}:0"
tmux "attach-session -t #{title}"

# make_alias if ARGV[0] == 'alias'

# start_tmux

# # tmux 'new-session -d -s skelaplex -n Server'
# new_session 'skelaplex', 'Server'

# tmux "send-keys -t skelaplex:0 \"cd #{APP_DIR}; #{start_server_code}\" C-m"

# # tmux 'split-window -v -t skelaplex:0'
# # tmux 'resize-pane -D -t skelaplex:0 9'
# # tmux "send-keys -t skelaplex:0 \"cd #{APP_DIR}\" C-m C-l"
# # tmux 'send-keys -t skelaplex:0 "rails c" C-m'


# tmux 'new-window -t skelaplex:1 -n RSpec'
# tmux "send-keys -t skelaplex:1 \"cd #{APP_DIR}; guard\" C-m"

# tmux 'new-window -t skelaplex:2 -n Bash'
# tmux "send-keys -t skelaplex:2 \"cd #{APP_DIR}; git show --stat\" C-m"

# need_chrome = `pgrep chrome`.empty?
# tmux 'new-session -d -s Browser -n Chrome'
# tmux "send-keys -t Browser:0 \"google-chrome 127.0.0.1:#{PORT}\" C-m"
# unless need_chrome
#   tmux 'send-keys -t Browser:0 \"exit\" C-m'
# end

# if `pgrep rubymine`.empty?
#   tmux 'new-session -d -s IDE -n Rubymine'
#   tmux "send-keys -t IDE:0 \"#{IDE_PATH} & disown\" C-m"
#   sleep 1
#   tmux 'kill-session -t IDE'
# end

# tmux 'select-window -t skelaplex:0'
# tmux 'attach-session -t skelaplex'
