FROM python:3.7-slim

# elixir likes utf8
ENV	LANG=C.UTF-8

# install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    curl \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

ARG ELIXIR_VERSION
ARG ESL_ERLANG_VERSION

ENV \
    ELIXIR_VERSION=${ELIXIR_VERSION} \
    ESL_ERLANG_VERSION=${ESL_ERLANG_VERSION}

# install elixer & erlang
RUN curl -O https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && apt-get update && apt-get install -y --no-install-recommends \
    esl-erlang=${ESL_ERLANG_VERSION}\* \
    elixir=${ELIXIR_VERSION}\* \
    && rm -rf /var/lib/apt/lists/* \
    && echo "$(elixir --version)"

# install jupyter
RUN pip install --no-cache jupyter

RUN useradd -ms /bin/bash jupyter
USER jupyter
WORKDIR /home/jupyter

# install iElixir jupyter kernel
RUN git clone https://github.com/pprzetacznik/IElixir.git \
    && cd IElixir \
    && mix local.hex --force \
    && mix local.rebar --force \
    && export PATH=$PATH:${HOME}/.mix \
    && mix deps.get \
    && mix deps.compile \
    && ./install_script.sh

EXPOSE 8888
VOLUME /notebooks

CMD [ \
    "jupyter", \
    "notebook", \
    "--no-browser", \
    "--ip=0.0.0.0", \
    "--notebook-dir=/notebooks", \
    "--NotebookApp.custom_display_url=http://localhost:8888", \
    "--MultiKernelManager.default_kernel_name=ielixir" \
    ]