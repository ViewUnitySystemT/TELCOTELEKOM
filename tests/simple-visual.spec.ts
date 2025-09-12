import { test, expect } from '@playwright/test';

test('Simple visual test - page loads and shows PeerLink', async ({ page }) => {
  await page.goto('/');
  await expect(page.getByRole('heading', { name: /PeerLink/i })).toBeVisible();
  
  // Warte ein bisschen damit Sie die Seite sehen können
  await page.waitForTimeout(2000);
  
  // Teste ob Kommunikations-Button vorhanden ist
  await expect(page.getByRole('button', { name: '💬 Kommunikation' })).toBeVisible();
  
  // Klicke auf Kommunikation
  await page.getByRole('button', { name: '💬 Kommunikation' }).click();
  await page.waitForTimeout(1000);
  
  // Teste ob Text-Modus verfügbar ist
  await expect(page.getByRole('button', { name: '💬 Text' })).toBeVisible();
});

