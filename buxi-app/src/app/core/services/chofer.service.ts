import { Injectable } from '@angular/core';
import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { environment } from '../../../environments/environment';
import { Bus } from '../models/transport.model';

@Injectable({ providedIn: 'root' })
export class ChoferService {
  private supabase: SupabaseClient;

  constructor() {
    this.supabase = createClient(environment.supabaseUrl, environment.supabaseAnonKey);
  }

  async getAssignedBus(choferId: string): Promise<Bus | null> {
    const { data, error } = await this.supabase
      .from('buses')
      .select('*, ruta:rutas(nombre, origen, destino, color), empresa:empresas(nombre)')
      .eq('chofer_id', choferId)
      .maybeSingle();

    if (error) throw error;
    return data as Bus | null;
  }

  async sendLocation(busId: string, lat: number, lng: number, speed: number = 0, heading: number = 0) {
    const { error } = await this.supabase
      .from('bus_locations')
      .insert({
        bus_id: busId,
        latitud: lat,
        longitud: lng,
        velocidad: speed,
        heading: heading,
      });

    if (error) throw error;
  }

  async updateBusStatus(busId: string, estado: string) {
    const { error } = await this.supabase
      .from('buses')
      .update({ estado })
      .eq('id', busId);

    if (error) throw error;
  }
}
