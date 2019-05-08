# docker-jupyter-ielixir
container to run jupyter with an elixir kernel

Get it running with the following:

    docker run -p 8888:8888 northisup/jupyter-ielixir

Jupyter is running in `/home/jupyter` so mount any notebooks you want to share there.

    docker run \
        -p 8888:8888 northisup/jupyter-ielixir \
        -v $HOME/src/notebooks:/notebooks

If you need a specific version of elixir or erlang use the `ELIXIR_VERSION` and `ESL_ERLANG_VERSION` build args.

    docker build . --build-arg 'ELIXIR_VERSION=1.7' -t jupyter-ielixir:1.7