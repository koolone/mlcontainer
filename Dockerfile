FROM python:3.6-slim-stretch


RUN apt-get -y update && apt-get install -y --no-install-recommends \
         nginx \
         ca-certificates \
         build-essential \
         git \
         unzip \
         g++ \
    && rm -rf /var/lib/apt/lists/*

# Set some environment variables. PYTHONUNBUFFERED keeps Python from buffering our standard
# output stream, which means that logs can be delivered to the user quickly. PYTHONDONTWRITEBYTECODE
# keeps Python from writing the .pyc files which are unnecessary in this case. We also update
# PATH so that the train and serve programs are found when the container is invoked.

ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"

COPY requirements.txt /opt/program/requirements.txt
WORKDIR /opt/program

# Here we get all python packages.
RUN pip install flask gevent gunicorn future
RUN pip install -r requirements.txt && rm -rf /root/.cache

# Install FastText.
RUN git clone https://github.com/facebookresearch/fastText.git /tmp/fastText && \
  rm -rf /tmp/fastText/.git* && \
  cd /tmp/fastText && \
  make &&\
  python setup.py install &&\
  cp /tmp/fastText/fasttext /opt/program/ && \
  rm -fr /tmp/fastText

COPY ./*.py /opt/program/
COPY ./*.conf /opt/program/
COPY ./*.ftz /opt/program/

ENTRYPOINT ["python", "/opt/program/start.py"]
