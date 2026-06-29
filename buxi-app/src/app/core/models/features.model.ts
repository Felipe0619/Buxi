export interface Favorito {
  id: string;
  user_id: string;
  ruta_id: string;
  created_at: string;
}

export interface Horario {
  id: string;
  ruta_id: string;
  dia: 'lunes_viernes' | 'sabado' | 'domingo';
  primera_salida: string;
  ultima_salida: string;
  frecuencia_minutos: number;
  notas: string | null;
}

export interface Calificacion {
  id: string;
  user_id: string;
  ruta_id: string;
  bus_id: string | null;
  estrellas: number;
  comentario: string | null;
  created_at: string;
}

export interface UserPreferences {
  user_id: string;
  dark_mode: boolean;
  notifications_enabled: boolean;
}

export interface Viaje {
  id: string;
  bus_id: string;
  chofer_id: string;
  ruta_id: string;
  inicio: string;
  fin: string | null;
  estado: 'en_curso' | 'completado' | 'cancelado';
  distancia_km: number;
  created_at: string;
  bus?: any;
  chofer?: any;
  ruta?: any;
}

export interface ActivityLog {
  id: string;
  user_id: string | null;
  accion: string;
  detalle: string | null;
  entidad: string | null;
  entidad_id: string | null;
  created_at: string;
}

export interface SystemConfig {
  key: string;
  value: string;
  description: string | null;
}
