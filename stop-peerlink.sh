#!/bin/bash

# ==========================================
# PeerLink Stop-Script
# Stoppt alle Komponenten des Systems
# ==========================================

echo "🛑 Stoppe PeerLink System..."

# Farbcodes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Signaling Server stoppen
echo -e "${BLUE}📡 Stoppe Signaling Server...${NC}"
pkill -f "node server.js" || echo -e "${YELLOW}⚠️  Kein Signaling Server gefunden${NC}"

# Docker Container stoppen
echo -e "${BLUE}🐳 Stoppe Docker Container...${NC}"
docker-compose down || echo -e "${YELLOW}⚠️  Keine Docker Container gefunden${NC}"

# Aufräumen
echo -e "${BLUE}🧹 Räume auf...${NC}"
rm -f nohup.out

echo -e "${GREEN}✅ PeerLink System gestoppt${NC}"

