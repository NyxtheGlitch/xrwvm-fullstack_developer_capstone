FROM python:3.9.18-slim-bookworm


WORKDIR /python-docker

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# The sentiment model's word list. Without it the service crashes on start.
RUN python -m nltk.downloader -d /usr/local/share/nltk_data vader_lexicon

COPY . .
RUN ls
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
