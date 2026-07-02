// Helper para usar sleep(ms) em sketches Processing
void sleep(long millis) {
  if (millis <= 0) return;
  try {
    Thread.sleep(millis);
  } catch (InterruptedException e) {
    Thread.currentThread().interrupt();
  }
}
