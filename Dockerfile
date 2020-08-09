# To enable ssh & remote debugging on app service change the base image to the one below
# FROM mcr.microsoft.com/azure-functions/python:3.0-python3.8-appservice
FROM python:latest

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN apt-get clean
RUN apt-get update
RUN apt-get install sudo
RUN apt-get install -y apt-transport-https
RUN sudo apt-get install unixodbc -y
RUN sudo apt-get install unixodbc-dev -y
RUN sudo apt-get install curl -y
RUN sudo apt-get install poppler-utils -y
RUN sudo apt-get install --reinstall build-essential -y

RUN sudo curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN sudo curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN sudo ACCEPT_EULA=Y apt-get install msodbcsql17
RUN sudo ACCEPT_EULA=Y apt-get install mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

COPY requirements.txt /
RUN pip install -r /requirements.txt

COPY . /
ADD . /

CMD [ "python", "./data_jar_scrape.py" ]
