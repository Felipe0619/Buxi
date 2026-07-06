import * as L from 'leaflet';

/**
 * Desliza un marcador de su posición actual a una nueva en vez de saltar de
 * golpe, para que el movimiento del bus en el mapa se vea fluido.
 */
export function animateMarkerTo(marker: L.Marker, target: L.LatLngExpression, duration = 1000): void {
  const start = marker.getLatLng();
  const end = L.latLng(target);
  const startTime = performance.now();

  function step(now: number) {
    const t = Math.min((now - startTime) / duration, 1);
    marker.setLatLng([
      start.lat + (end.lat - start.lat) * t,
      start.lng + (end.lng - start.lng) * t,
    ]);
    if (t < 1) requestAnimationFrame(step);
  }

  requestAnimationFrame(step);
}
