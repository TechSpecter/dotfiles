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
  entr \
  exiftool \
  fd-find \
  file \
  fzf \
  gnupg \
  highlight \
  iputils-ping \
  jq \
  libevent-dev \
  libgraph-easy-perl \
  locales \
  locales-all \
  lsb-release \
  lynx \
  man \
  miller \
  ncat \
  ncurses-dev \
  neofetch \
  newsboat \
  openssh-server \
  pandoc \
  pass \
  ripgrep \
  shellcheck \
  stow \
  sudo \
  toot \
  unzip \
  uuid-runtime \
  vim-nox \
  w3m \
  wget \
  zsh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen "en_US.UTF-8" \
  && dpkg-reconfigure locales

WORKDIR /tmp/
ARG DEST=/usr/local/bin

#RUN ARCH=echo "$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)"
ARG ARCH=amd64

# Install neovim from release deb distribution
#ARG NVIMVER=0.9.1
#RUN curl -sLO "https://github.com/neovim/neovim/releases/download/v${NVIMVER}/nvim-linux64.tar.gz" && tar -xzvf nvim-linux64.tar.gz \
#  && cp ./nvim-linux64/bin/nvim "$DEST"

# Install nvim from release deb distribution
ARG NVIMVER=0.8.0
RUN cd /tmp/ \
  && curl -sLO https://github.com/neovim/neovim/releases/download/v${NVIMVER}/nvim-linux64.deb \
  && apt install ./nvim-linux64.deb

# Install tmux - terminal multiplexer
ARG TMUXVER=3.2a
RUN curl -fsSL "https://github.com/tmux/tmux/releases/download/$TMUXVER/tmux-$TMUXVER.tar.gz" | tar -xzf - \
  && cd "tmux-$TMUXVER" && ./configure && make && make install

# Install bat - cat with wings
ARG BATVER=0.23.0
RUN curl -fsSLO "https://github.com/sharkdp/bat/releases/download/v$BATVER/bat_${BATVER}_${ARCH}.deb" && dpkg -i "./bat_${BATVER}_${ARCH}.deb"

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

# Install Dockerfile linter hadolint
ARG HADOLINTVER=2.8.0
RUN curl -fsSL "https://github.com/hadolint/hadolint/releases/download/v${HADOLINTVER}/hadolint-Linux-x86_64" -o "$DEST/hadolint" && chmod +x "$DEST/hadolint"

# Install Steampipe - SQL for APIs
RUN /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/turbot/steampipe/main/install.sh)"

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install ijq
ARG IJQVER=0.4.1
RUN wget "https://git.sr.ht/~gpanders/ijq/refs/download/v$IJQVER/ijq-$IJQVER-linux-amd64.tar.gz" \
  && tar xf "ijq-$IJQVER-linux-amd64.tar.gz" \
  && cp "ijq-$IJQVER/ijq" $DEST \
  && cp "ijq-$IJQVER/ijq.1" '/usr/local/share/man/man1'

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

USER $USERNAME
WORKDIR /home/$USERNAME
ENV TERM xterm-256color

#Install Node.js via NVM
ARG NVMVER=v0.39.5
ARG NODEVER=v18.18.0
ARG NVM_INSTALL_PATH=/home/$USERNAME/.nvm/versions/node/$NODEVER
RUN wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVMVER/install.sh" | bash
RUN source /home/$USERNAME/.nvm/nvm.sh \
  && nvm install $NODEVER \
  && nvm alias default $NODEVER \
  && nvm use default \
  && npm install -g \
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
ENV NODE_PATH $NVM_INSTALL_PATH/lib/node_modules
ENV PATH $NVM_INSTALL_PATH/bin:$PATH

#Setup ZSH with Oh-my-zsh
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" \
  && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
  && git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Set up dotfiles and copy the configurations using Stow
RUN mkdir -p /home/$USERNAME/.config \
  && git clone https://github.com/TechSpecter/dotfiles.git "$HOME/dotfiles" \
  && cd dotfiles/ \
  && ./dotsetup 

# Off we go - based on tmux, the terminal multiplexer
ENTRYPOINT [ "/bin/zsh" ]
#CMD ["tmux", "-u", "new", "-s", "main"]
