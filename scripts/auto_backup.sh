#!/bin/bash

# Mau sac menu
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Duong dan
BASE_DIR=$(dirname "$(dirname "$(realpath "$0")")")
DATA_DIR="$BASE_DIR/data"
BACKUP_DIR="$BASE_DIR/backups"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/backup.log"

# Tao thu muc neu chua ton tai
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

# Ham backup
backup_data() {
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="backup_$TIMESTAMP.tar.gz"

    tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$DATA_DIR"

    echo "$(date) : Backup thanh cong -> $BACKUP_FILE" >> "$LOG_FILE"

    echo -e "${GREEN}Backup thanh cong!${NC}"

    # Chi giu lai 5 file backup moi nhat
    ls -t "$BACKUP_DIR"/*.tar.gz | tail -n +6 | xargs -r rm

    # Kiem tra internet
    ping -c 1 google.com > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "${BLUE}Internet dang ket noi${NC}"
    else
        echo -e "${RED}Khong co ket noi Internet${NC}"
    fi
}

# Ham xem danh sach backup
view_backups() {
    echo -e "${BLUE}Danh sach backup:${NC}"
    ls -lh "$BACKUP_DIR"
}

# Ham xem log
view_logs() {
    echo -e "${GREEN}Noi dung log:${NC}"
    cat "$LOG_FILE"
}
# Tu dong backup
if [ "$1" = "auto" ]; then
    backup_data
    exit 0
fi
# Menu
while true
do
    echo "==============================="
    echo -e "${BLUE}HE THONG BACKUP DU LIEU${NC}"
    echo "1. Backup du lieu"
    echo "2. Xem danh sach backup"
    echo "3. Xem log"
    echo "4. Thoat"
    echo "==============================="

    read -p "Chon: " choice

    case $choice in
        1)
            backup_data
            ;;
        2)
            view_backups
            ;;
        3)
            view_logs
            ;;
        4)
            echo "Thoat chuong trinh..."
            exit 0
            ;;
        *)
            echo -e "${RED}Lua chon khong hop le!${NC}"
            ;;
    esac
done
