FROM ubuntu:22.04

# Evitar interacciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncurses5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario no-root para ejecutar pyenv
RUN useradd -ms /bin/bash pyuser
USER pyuser
WORKDIR /home/pyuser

# Instalar pyenv
RUN curl https://pyenv.run | bash

# Configurar pyenv en el perfil del usuario
ENV HOME="/home/pyuser"
ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"
ENV PATH="$PYENV_ROOT/shims:$PATH"
RUN echo 'eval "$(pyenv init --path)"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

# Instalar Python 3.11.6 utilizando pyenv
RUN $PYENV_ROOT/bin/pyenv install 3.11.6

# Crear un entorno virtual con pyenv y activarlo
RUN $PYENV_ROOT/bin/pyenv global 3.11.6 && \
    $PYENV_ROOT/bin/pyenv virtualenv 3.11.6 resemble_env && \
    $PYENV_ROOT/bin/pyenv global resemble_env

# Establecer el shell para que cargue .bashrc
SHELL ["/bin/bash", "--login", "-c"]

# Asegurarse de que estamos utilizando el Python correcto
RUN bash -c "source ~/.bashrc && python --version && pip --version"

# Clonar el repositorio resemble-enhance
RUN bash -c "source ~/.bashrc && git clone https://github.com/johnjaider1000/resemble-enhance.git"

# Cambiar al directorio del repositorio
WORKDIR /home/pyuser/resemble-enhance

# Instalar pydantic específicamente en la versión solicitada
RUN bash -c "source ~/.bashrc && pip install pydantic==1.10.8"

# Actualizar gradio
RUN bash -c "source ~/.bashrc && pip install --upgrade gradio"

# Instalar requerimientos del repositorio
RUN bash -c "source ~/.bashrc && pip install -r requirements.txt"

# Configurar el CMD para ejecutar app.py
WORKDIR /home/pyuser/resemble-enhance
CMD ["/bin/bash", "-c", "source ~/.bashrc && python app.py"]

