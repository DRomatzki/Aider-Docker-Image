# Aider Docker image

This repository creates a Docker image that runs Aider code assistant accessing the Ollama.

It was developed to run Aider on a Linux Mint 21.2 machine and it works with Ollama, also in a Docker image. If you want to run it with other service providers, follow the steps on [https://aider.chat/](URL) by modifying the config file, "aider.conf.yml".


## Why a Docker image?

I hate to create conda or other enviromental configuration to run all the software that I want to test or use. It just clutters the hard drive.
So the result is this Docker image ..... :-)

Unfortunbatley I could not get the official Docker Image from the Aider repository going because of file permissions in linux and other problems.
I also use Gogs (docker image) as a local github service and I got Aider error messages for git instructions. Currently Aider does not have "robust" git integration to catch all errors. Maybe you have better luck. I am not a git expert.


# Aider

Aider is a powerful AI-powered code assistant that helps you with writing and testing code and apps. It uses advanced language models to provide accurate and informative responses.

The details are available at [https://aider.chat/](URL)

Their github is at [https://github.com/paul-gauthier/aider](URL)

All credit goes to Paul Gauthier and his team.


## Prerequisites

Before running Aider, make sure you have the following:

- Docker installed on your system
- An OpenAI API key and other keys if you want to use external service providers and models.
- A running Ollama API server

## Usage

1. Clone the repository:

```bash
git clone https://github.com/DRomatzki/aider.git
```

2. Build the Docker image:

Before you create the container, try to edit the dockerfile to set your git global credentials. 

> "#Run Git configuration"  
> RUN git config --global user.name <Your_git_username> && \  
>         git config --global user.email <Your_email_address>`

It downloads the Aider github. Therefor you will always have the latest version of Aider, stable or unstable.

```bash
docker build -t aider .
```
The created image file is about 10.6 GB and is called "aider".


3. To Run the Docker container:

Create a folder to be used as a volume. In this volume the config files will be stored. The dockerfile copies the relevant configuration files to this folder and you can edit and change it at your leasure. If this folder is not avialable it will create them but Docker will use the "root" user as owner. Maybe it is even better if you just copy them over. Permissions can be a schlepp.....

**Remember:** this is an interactive container that is created and destroyed every time. To make the changes in your config file applicable to your current Aider instance, you have to stop and restart the container again.

    ```bash
docker run --rm -it \
           --name aider \
           -p 8501:8501 \
           -v "$(pwd)":/home/appuser/app \
           -v /path/to/config:/home/appuser/config \
           --add-host=host.docker.internal:host-gateway \
           aider:latest`
```

Replace `/path/to/config` with the actual path to your configuration directory on your host machine.

You can create an alias in bashrc if you like. It solves a lot of typing and problems.
Edit your .bashrc file in you home directory and add the following code

    ```bash
alias aider="docker run --rm -it \
           --name aider \
           -p 8501:8501 \
          -v "$(pwd)":/home/appuser/app \
           -v /path/to/config:/home/appuser/config \
           --add-host=host.docker.internal:host-gateway \
           aider:latest"
```
If necessary type 

    ```bash
source ~/.bashrc
```

4. Aider will start running inside the Docker container, and you can interact with it through the command-line interface. If you created the "alias" just type "aider" and the application will start.

## Configuration

Aider uses configuration files located in the `/home/appuser/config` directory inside the container. These files include:

- `aider.conf.yml`: The main configuration file
- `aider.model.settings.yml`: Model settings
- `aider.model.metadata.json`: Model metadata

Make sure to mount the appropriate configuration directory when running the Docker container.

## Contributing

If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/DRomatzki/Aaider_Docker_Image).

Just remember ........ I am not a Docker expert ........ :-)

## License

This project is licensed under the [Apache License 2](LICENSE), same as Aider.
