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
tmux "send-keys -t skelaplex:0 \"cd #{APP_DIR}; rails s -p #{PORT}\" C-m"

tmux 'split-window -v -t skelaplex:0'
tmux 'resize-pane -D -t skelaplex:0 9'
tmux "send-keys -t skelaplex:0 \"cd #{APP_DIR}\" C-m C-l"
tmux 'send-keys -t skelaplex:0 "rails c" C-m'


tmux 'new-window -t skelaplex:1 -n Bash'
tmux "send-keys -t skelaplex:1 \"cd #{APP_DIR}; git show --stat\" C-m"

tmux 'select-window -t skelaplex:0'
tmux 'attach-session -t skelaplex'
