import { test, expect } from '@playwright/test';

test('Main modes and dashboard load', async ({ page }) => {
  await page.goto('/');
  await expect(page.getByRole('heading', { name: /PeerLink/i })).toBeVisible();

  // Kommunikation aktiv
  await page.getByRole('button', { name: '💬 Kommunikation' }).click();
  await expect(page.getByRole('button', { name: '💬 Text' })).toBeVisible();

  // Services & Tools Übersicht (klicke gezielt Button mit ID)
  await page.locator('#servicesMode').click();
  await expect(page.getByRole('heading', { name: '🔧 Services & Tools' })).toBeVisible();

  // Monitoring Dashboard toggle (scoped auf Services-Overview, um Duplikate zu vermeiden)
  const services = page.locator('#servicesOverview');
  await services.getByRole('button', { name: /Monitoring Dashboard/ }).first().click();
  await expect(page.getByText('Live Monitoring Dashboard')).toBeVisible();
});

test('Help search and producer toggle', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: '💬 Kommunikation' }).click();
  await page.getByRole('button', { name: '❓ Hilfe' }).click();
  const input = page.locator('#helpSearchInput');
  await input.fill('verbindung');
  await expect(page.locator('#helpSearchResults')).toBeVisible();

  // Zurück zur Hauptseite und dann Services & Tools
  await page.getByRole('button', { name: '⬅️ Zurück' }).click();
  await page.getByRole('button', { name: '🔧 Services & Tools' }).click();
  await page.getByRole('button', { name: '🎙️ Producer‑Panel' }).click();
  await expect(page.locator('#producerPanel')).toBeVisible();
});


test('File Exchange: upload lists item and download works', async ({ page }) => {
  await page.goto('/');
  // Öffne Services & Tools → Datei‑Austausch
  await page.locator('#servicesMode').click();
  const services = page.locator('#servicesOverview');
  await services.getByRole('button', { name: /Datei.*Austausch/ }).click();
  await expect(page.locator('#filePanel')).toBeVisible();

  // Lade Datei über hidden input
  const fileName = 'test-upload.txt';
  const fileBuffer = Buffer.from('hello peerlink');
  await page.setInputFiles('#fileInput', {
    name: fileName,
    mimeType: 'text/plain',
    buffer: fileBuffer,
  });

  // Eintrag erscheint in der Liste
  await expect(page.locator('#fileItems').getByText(fileName)).toBeVisible();

  // Download auslösen und prüfen
  const [download] = await Promise.all([
    page.waitForEvent('download'),
    page.locator('.file-download-btn').first().click(),
  ]);
  const suggested = download.suggestedFilename();
  expect(suggested).toContain(fileName);
});

test('Meeting link parsing sets room and meeting title', async ({ page }) => {
  const utc = Date.now() + 60_000; // +1 min
  const title = 'E2E Meeting';
  await page.goto(`/?room=e2eroom#t=${utc}&title=${encodeURIComponent(title)}`);

  await expect(page.locator('#roomIdValue')).toHaveText('e2eroom');
  // Title should be set by parser even if panel hidden
  await expect(page.locator('#meetingTitle')).toHaveValue(title);
  // Ensure the time/meeting UI is revealed for the user
  await page.getByRole('button', { name: '🕐 Zeit & Meetings' }).click();
  await page.getByRole('button', { name: '📅 Meeting' }).click();
  await expect(page.locator('#meetingPanel')).toBeVisible();
});

test('Click-to-load Spotify embed only loads after click', async ({ page }) => {
  await page.goto('/');
  await page.locator('#servicesMode').click();
  const services = page.locator('#servicesOverview');
  await services.getByRole('button', { name: /Producer/ }).click();
  await expect(page.locator('#producerPanel')).toBeVisible();

  // Vorher: kein Spotify-iframe vorhanden
  await expect(page.locator('iframe[src*="open.spotify.com"]')).toHaveCount(0);

  // Click-to-load
  await page.locator('#sp1-placeholder .embed-load-btn').click();
  await expect(page.locator('iframe[src*="open.spotify.com/embed/artist/4JoHEGXx9uwPmdT02ZSVwH"]')).toBeVisible();
});

test('QR: opens, renders image and downloads PNG', async ({ page }) => {
  await page.goto('/');
  await page.locator('#showQR').click();
  await expect(page.locator('#qrCode img')).toBeVisible();

  const [download] = await Promise.all([
    page.waitForEvent('download'),
    page.getByRole('button', { name: /PNG herunterladen/ }).click(),
  ]);
  expect(download.suggestedFilename()).toContain('peerlink-qr');
});

