FROM python:3.9-alpine3.17

COPY ./app /app 
WORKDIR /app 
RUN pip install -r requirements.txt

CMD ["gunicorn", "--bind", "0.0.0.0:4545", "wsgi:app"]