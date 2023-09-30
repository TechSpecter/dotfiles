FROM --platform=linux/amd64 debian:12.1 as base

RUN apt-get update \
  && apt-get install -y \
  apt-transport-https \
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
  stow \
  zsh \
  locales \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen en_US.UTF-8

SHELL ["/bin/zsh", "-o", "pipefail", "-c"]

WORKDIR /tmp/
ARG DEST=/usr/local/bin

#RUN ARCH=echo "$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)"
ARG ARCH=amd64

# Install neovim from release deb distribution
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

# Install ijq
ARG IJQVER=0.4.1
RUN wget "https://git.sr.ht/~gpanders/ijq/refs/download/v$IJQVER/ijq-$IJQVER-linux-amd64.tar.gz" \
  && tar xf "ijq-$IJQVER-linux-amd64.tar.gz" \
  && cp "ijq-$IJQVER/ijq" $DEST \
  && cp "ijq-$IJQVER/ijq.1" '/usr/local/share/man/man1'

#Install Node.js via NVM
ARG NVMVER=v0.39.5
ARG NODEVER=v18.18.0
RUN curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVMVER}/install.sh" | bash
RUN source "$HOME/.nvm/nvm.sh" && nvm install ${NODEVER} && nvm use ${NODEVER}
#RUN curl -fsSL "https://deb.nodesource.com/setup_$NODEVER.x" | zsh - && apt-get install -y nodejs

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
RUN /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/turbot/steampipe/main/install.sh)"

# Clean up temp dir
RUN rm -rf /tmp/*

# Set up non-root user
ARG USERNAME=rahul
RUN adduser \
  --quiet \
  --disabled-password \
  --shell /bin/zsh \
  --home /home/$USERNAME \
  --gecos "Dev User" \
  $USERNAME \
  && chown $USERNAME:$USERNAME /tmp/

#RUN mkdir /home/$USERNAME/.npm-global \
#  && chown $USERNAME:$USERNAME /home/$USERNAME/.npm-global

USER $USERNAME
WORKDIR /home/$USERNAME
ENV TERM xterm-256color

# generate locale for rahul
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && /usr/sbin/locale-gen

#Install Node.js via NVM
ARG NVMVER=v0.39.5
ARG NODEVER=v18.18.0
RUN curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVMVER}/install.sh" | bash
RUN source "$HOME/.nvm/nvm.sh" && nvm install ${NODEVER} && nvm use ${NODEVER}
#RUN curl -fsSL "https://deb.nodesource.com/setup_$NODEVER.x" | zsh - && apt-get install -y nodejs

# RUN npm config set prefix "/home/$USERNAME/.npm-global"

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

# run the installation script  
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# install powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN echo ZSH_THEME="powerlevel10k/powerlevel10k" >> $HOME/.zshrc

# Set up dotfiles
#RUN git clone https://github.com/qmacro/dotfiles.git && cd dotfiles/ && ./dotsetup
# Install Vim plugins
#RUN vim +'PackerInstall' +qa > /dev/null 2>&1

# Add extra bashrc.d file to append $HOME/.npm-global/bin to $PATH
#RUN echo 'export PATH=$PATH:$HOME/.npm-global/bin' > $HOME/dotfiles/bashrc.d/99-docker-npm-global-bin-path.sh

# Install Packer (for NeoVim) core
#RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

# Off we go - based on tmux, the terminal multiplexer
#CMD ["tmux", "-u", "new", "-s", "main"]
CMD ["neofetch"]
