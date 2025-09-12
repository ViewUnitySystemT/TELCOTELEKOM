// Media Gallery Integration für PeerLink APK
// Diese Datei wird in die peerlink.html eingebettet

class MediaGallery {
    constructor() {
        this.mediaFiles = [];
        this.currentIndex = 0;
        this.isInitialized = false;
        this.init();
    }
    
    async init() {
        try {
            // Prüfe ob wir in der Android App sind
            if (window.MediaInterface) {
                await this.loadMediaFiles();
                this.createGalleryUI();
                this.isInitialized = true;
                console.log('✅ Mediengalerie initialisiert');
            } else {
                console.log('ℹ️ Mediengalerie nur in Android App verfügbar');
            }
        } catch (error) {
            console.error('❌ Fehler bei Mediengalerie-Initialisierung:', error);
        }
    }
    
    async loadMediaFiles() {
        try {
            const fileNames = window.MediaInterface.getMediaFiles();
            const mediaDir = window.MediaInterface.getMediaDirectory();
            
            this.mediaFiles = fileNames.map(fileName => ({
                name: fileName,
                path: `${mediaDir}/${fileName}`,
                type: this.getFileType(fileName),
                url: `file://${mediaDir}/${fileName}`
            }));
            
            console.log(`📁 ${this.mediaFiles.length} Mediendateien geladen`);
        } catch (error) {
            console.error('❌ Fehler beim Laden der Mediendateien:', error);
        }
    }
    
    getFileType(fileName) {
        const extension = fileName.toLowerCase().split('.').pop();
        if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'].includes(extension)) {
            return 'image';
        } else if (['mp4', 'avi', 'mov', 'webm'].includes(extension)) {
            return 'video';
        } else if (['mp3', 'wav', 'ogg', 'm4a'].includes(extension)) {
            return 'audio';
        }
        return 'unknown';
    }
    
    createGalleryUI() {
        // Erstelle Galerie-Button in der Navigation
        const nav = document.querySelector('.nav-buttons');
        if (nav) {
            const galleryBtn = document.createElement('button');
            galleryBtn.className = 'nav-btn';
            galleryBtn.innerHTML = '📁 Galerie';
            galleryBtn.onclick = () => this.showGallery();
            nav.appendChild(galleryBtn);
        }
        
        // Erstelle Galerie-Modal
        this.createGalleryModal();
    }
    
    createGalleryModal() {
        const modal = document.createElement('div');
        modal.id = 'mediaGalleryModal';
        modal.className = 'modal';
        modal.style.cssText = `
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.9);
            overflow: hidden;
        `;
        
        modal.innerHTML = `
            <div class="gallery-container" style="
                position: relative;
                width: 100%;
                height: 100%;
                display: flex;
                flex-direction: column;
            ">
                <div class="gallery-header" style="
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 20px;
                    background: rgba(0,0,0,0.8);
                    color: white;
                ">
                    <h2>Mediengalerie (${this.mediaFiles.length} Dateien)</h2>
                    <button onclick="mediaGallery.closeGallery()" style="
                        background: #ff4444;
                        color: white;
                        border: none;
                        padding: 10px 20px;
                        border-radius: 5px;
                        cursor: pointer;
                    ">✕ Schließen</button>
                </div>
                
                <div class="gallery-grid" style="
                    flex: 1;
                    padding: 20px;
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                    gap: 15px;
                    overflow-y: auto;
                "></div>
                
                <div class="gallery-viewer" style="
                    display: none;
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0,0,0,0.95);
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                ">
                    <div class="viewer-content" style="
                        max-width: 90%;
                        max-height: 80%;
                        position: relative;
                    "></div>
                    <div class="viewer-controls" style="
                        position: absolute;
                        bottom: 20px;
                        left: 50%;
                        transform: translateX(-50%);
                        display: flex;
                        gap: 10px;
                    ">
                        <button onclick="mediaGallery.previousMedia()" style="
                            background: #2563eb;
                            color: white;
                            border: none;
                            padding: 10px 20px;
                            border-radius: 5px;
                            cursor: pointer;
                        ">‹ Zurück</button>
                        <button onclick="mediaGallery.nextMedia()" style="
                            background: #2563eb;
                            color: white;
                            border: none;
                            padding: 10px 20px;
                            border-radius: 5px;
                            cursor: pointer;
                        ">Weiter ›</button>
                        <button onclick="mediaGallery.closeViewer()" style="
                            background: #ff4444;
                            color: white;
                            border: none;
                            padding: 10px 20px;
                            border-radius: 5px;
                            cursor: pointer;
                        ">Schließen</button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
    }
    
    showGallery() {
        const modal = document.getElementById('mediaGalleryModal');
        const grid = modal.querySelector('.gallery-grid');
        
        // Leere das Grid
        grid.innerHTML = '';
        
        // Füge Medien-Thumbnails hinzu
        this.mediaFiles.forEach((file, index) => {
            const item = document.createElement('div');
            item.className = 'gallery-item';
            item.style.cssText = `
                position: relative;
                aspect-ratio: 1;
                border-radius: 8px;
                overflow: hidden;
                cursor: pointer;
                background: #f0f0f0;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
            `;
            
            if (file.type === 'image') {
                const img = document.createElement('img');
                img.src = file.url;
                img.style.cssText = 'width: 100%; height: 100%; object-fit: cover;';
                img.onerror = () => {
                    item.innerHTML = '🖼️';
                };
                item.appendChild(img);
            } else if (file.type === 'video') {
                item.innerHTML = '🎥';
            } else if (file.type === 'audio') {
                item.innerHTML = '🎵';
            } else {
                item.innerHTML = '📄';
            }
            
            item.onclick = () => this.viewMedia(index);
            grid.appendChild(item);
        });
        
        modal.style.display = 'block';
    }
    
    viewMedia(index) {
        this.currentIndex = index;
        const file = this.mediaFiles[index];
        const viewer = document.querySelector('.gallery-viewer');
        const content = viewer.querySelector('.viewer-content');
        
        content.innerHTML = '';
        
        if (file.type === 'image') {
            const img = document.createElement('img');
            img.src = file.url;
            img.style.cssText = 'max-width: 100%; max-height: 100%; object-fit: contain;';
            content.appendChild(img);
        } else if (file.type === 'video') {
            const video = document.createElement('video');
            video.src = file.url;
            video.controls = true;
            video.style.cssText = 'max-width: 100%; max-height: 100%;';
            content.appendChild(video);
        } else if (file.type === 'audio') {
            const audio = document.createElement('audio');
            audio.src = file.url;
            audio.controls = true;
            audio.style.cssText = 'width: 100%;';
            content.appendChild(audio);
        } else {
            const div = document.createElement('div');
            div.innerHTML = `
                <div style="text-align: center; color: white;">
                    <h3>${file.name}</h3>
                    <p>Dateityp nicht unterstützt</p>
                </div>
            `;
            content.appendChild(div);
        }
        
        viewer.style.display = 'flex';
    }
    
    previousMedia() {
        this.currentIndex = (this.currentIndex - 1 + this.mediaFiles.length) % this.mediaFiles.length;
        this.viewMedia(this.currentIndex);
    }
    
    nextMedia() {
        this.currentIndex = (this.currentIndex + 1) % this.mediaFiles.length;
        this.viewMedia(this.currentIndex);
    }
    
    closeViewer() {
        document.querySelector('.gallery-viewer').style.display = 'none';
    }
    
    closeGallery() {
        document.getElementById('mediaGalleryModal').style.display = 'none';
    }
}

// Initialisiere Mediengalerie
let mediaGallery;
document.addEventListener('DOMContentLoaded', () => {
    mediaGallery = new MediaGallery();
});
