FROM python:3.7-slim

COPY ./entrypoint.sh .

RUN apt-get update
RUN apt-get -y install git curl jq

RUN pip install bump2version

ENTRYPOINT ["/entrypoint.sh"]