FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN groupadd -g 1000 appgroup && useradd -r -u 1000 -g appgroup appuser
COPY --chown=appuser:appgroup . .
USER appuser:appgroup

EXPOSE 8000
CMD ["python", "app.py"]