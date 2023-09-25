FROM --platform=linux/amd64 debian:12.1 as base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
  && apt-get install -y \
  apt-transport-https \
  bash-completion \
  bc \
  build-essential \
  ca-certificates \
  cron \
  curl \
  exiftool \
  file \
  fzf \
  gnupg \
  jq \
  libevent-dev \
  libgraph-easy-perl \
  lsb-release \
  lynx \
  man \
  ncat \
  ncurses-dev \
  neofetch \
  openssh-server \
  pandoc \
  pass \
  shellcheck \
  sudo \
  unzip \
  uuid-runtime \
  wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/
ARG DEST=/usr/local/bin

#RUN ARCH=echo "$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)"
ARG ARCH=amd64

# Install nvim from release deb distribution
ARG NVIMVER=0.9.1
 RUN curl -sLO "https://github.com/neovim/neovim/releases/download/v${NVIMVER}/nvim-linux64.tar.gz" && tar -xzvf nvim-linux64.tar.gz \
   && cp ./nvim-linux64/bin/nvim "$DEST"
   
# Install tmux - terminal multiplexer
ARG TMUXVER=3.2a
RUN curl -fsSL "https://github.com/tmux/tmux/releases/download/$TMUXVER/tmux-$TMUXVER.tar.gz" | tar -xzf - \
  && cd "tmux-$TMUXVER" && ./configure && make && make install

# Install bat - cat with wings
ARG BATVER=0.23.0
RUN curl -fsSLO "https://github.com/sharkdp/bat/releases/download/v$BATVER/bat_${BATVER}_${ARCH}.deb" && dpkg -i "./bat_${BATVER}_${ARCH}.deb"

#Install NVM
# ARG NVMVER=0.39.5
# RUN curl -fsSL "https://github.com/nvm-sh/nvm/archive/refs/tags/v$NVMVER.tar.gz" | tar -xzf - \
#   && cd "nvm-$NVMVER" && 

# Install specific Node.js
ARG NODEVER=lts
RUN curl -fsSL "https://deb.nodesource.com/setup_$NODEVER.x" | bash - && apt-get install -y nodejs

# Install global npm modules for Node.js
RUN npm install -g \
  url-decode-encode-cli \
  httpie \
  prettier \ 
  unzip \
  jwt-cli \
  lodash \
  lorem-ipsum \
  markdownlint-cli \
  docsify-cli \
  yarn

# Install gh - CLI for GitHub
ARG GHVER=2.28.0
RUN curl -fsSLO "https://github.com/cli/cli/releases/download/v${GHVER}/gh_${GHVER}_linux_${ARCH}.deb" && dpkg -i "./gh_${GHVER}_linux_${ARCH}.deb"

# Install yq - YAML query tool
ARG YQVER=4.35.1
RUN curl -fsSL "https://github.com/mikefarah/yq/releases/download/v${YQVER}/yq_linux_amd64" -o "$DEST/yq" && chmod +x "$DEST/yq"

# Install glow - terminal based Markdown rendering
ARG GLOWVER=1.4.1
RUN curl -fsSLO "https://github.com/charmbracelet/glow/releases/download/v${GLOWVER}/glow_${GLOWVER}_linux_${ARCH}.deb" && dpkg -i "./glow_${GLOWVER}_linux_${ARCH}.deb"

# Install gitui - a git TUI
ARG GITUIVER=0.24.3
RUN curl -fsSL "https://github.com/extrawurst/gitui/releases/download/v${GITUIVER}/gitui-linux-musl.tar.gz" | tar -C "$DEST" -xzf -

# Install lf - a terminal file manager
ARG LFVER=31
RUN curl -fsSL "https://github.com/gokcehan/lf/releases/download/r${LFVER}/lf-linux-amd64.tar.gz" | tar -C "$DEST" -xzf - lf

# Install shfmt - shell script formatter
ARG SHFMTVER=3.7.0
RUN curl -fsSL "https://github.com/mvdan/sh/releases/download/v${SHFMTVER}/shfmt_v${SHFMTVER}_linux_amd64" -o "$DEST/shfmt" && chmod +x "$DEST/shfmt"

# Clean up temp dir
RUN rm -rf /tmp/*

# Set up non-root user
ARG USERNAME=rahul
RUN adduser \
  --quiet \
  --disabled-password \
  --shell /bin/bash \
  --home /home/$USERNAME \
  --gecos "Dev User" \
  $USERNAME \
  && chown $USERNAME:$USERNAME /tmp/

RUN mkdir /home/$USERNAME/.npm-global \
  && chown $USERNAME:$USERNAME /home/$USERNAME/.npm-global

USER $USERNAME
WORKDIR /home/$USERNAME
ENV TERM xterm-256color

# Install ijq
ARG IJQVER=0.4.1
RUN wget "https://git.sr.ht/~gpanders/ijq/refs/download/v$IJQVER/ijq-$IJQVER-linux-amd64.tar.gz" \
  && tar xf "ijq-$IJQVER-linux-amd64.tar.gz" \
  && cd "ijq-$IJQVER" \
  && cp ijq /home/$USERNAME/bin

RUN rm -rf /home/$USERNAME/*

# Off we go - based on tmux, the terminal multiplexer
CMD ["tmux", "-u", "new", "-s", "main"]
