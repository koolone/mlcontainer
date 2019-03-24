FROM 328981655083.dkr.ecr.us-west-2.amazonaws.com/demo-ml-registry:base

WORKDIR /opt/program
COPY ./*.py /opt/program/
COPY ./*.conf /opt/program/
COPY ./*.ftz /opt/program/

ENTRYPOINT ["python", "/opt/program/start.py"]
