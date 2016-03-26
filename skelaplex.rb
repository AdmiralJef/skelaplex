APP_DIR = '~/web/skela'
PORT = 3000

def tmux(code)
  `tmux #{code}`
end

def start
  tmux 'start-server'
end

start

tmux 'new-session -d -s skelaplex -n Server'
tmux "send-keys -t skelaplex:0 \"cd #{APP_DIR}; bundle exec passenger start -p #{PORT}\" C-m"

tmux 'split-window -v -t skelaplex:0'
tmux 'resize-pane -D -t skelaplex:0 9'
tmux "send-keys -t skelaplex:0 \"cd #{APP_DIR}\" C-m C-l"
tmux 'send-keys -t skelaplex:0 "rails c" C-m'


tmux 'new-window -t skelaplex:1 -n Bash'
tmux "send-keys -t skelaplex:1 \"cd #{APP_DIR}; git show --stat\" C-m"

need_chrome = `pgrep chrome`.empty?
tmux 'new-session -d -s Browser -n Chrome'
tmux "send-keys -t Browser:0 \"google-chrome 127.0.0.1:#{PORT}\" C-m"
unless need_chrome
  tmux 'send-keys -t Browser:0 \"exit\" C-m'
end

if `pgrep rubymine`.empty?

  rubymine_path = '/opt/RubyMine-8.0.3/bin/rubymine.sh'

  tmux 'new-session -d -s IDE -n Rubymine'
  tmux "send-keys -t IDE:0 \"#{rubymine_path}\" C-m"
end

tmux 'select-window -t skelaplex:0'
tmux 'attach-session -t skelaplex'
