LIBRECHAT_DIR="/Users/haysoncheung/programs/system_scripts/LibreChat"
OLLAMA_URL="http://localhost:11434"
LIBRECHAT_URL="http://localhost:3080"

echo "Checking Ollama..."
# Ensure Colima is running
if ! docker info >/dev/null 2>&1; then
    echo "Starting Colima..."
    colima start
fi
if ! curl -s $OLLAMA_URL > /dev/null; then
    echo "Starting Ollama..."
    ollama serve > /dev/null 2>&1 &
    sleep 2
fi

echo "Starting LibreChat..."
docker-compose down

cd "$LIBRECHAT_DIR" || exit
docker-compose up -d --force-recreate

echo "Waiting for LibreChat..."

until curl -s $LIBRECHAT_URL > /dev/null; do
  sleep 1
done

echo "Opening UI..."
open $LIBRECHAT_URL