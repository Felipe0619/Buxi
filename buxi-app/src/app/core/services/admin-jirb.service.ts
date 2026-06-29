import { Injectable } from '@angular/core';
import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { environment } from '../../../environments/environment';
import { Empresa, Bus, Ruta, Parada } from '../models/transport.model';
import { UserProfile } from '../models/user-profile.model';
import { Calificacion, Horario } from '../models/features.model';

@Injectable({ providedIn: 'root' })
export class AdminJirbService {
  private supabase: SupabaseClient;

  constructor() {
    this.supabase = createClient(environment.supabaseUrl, environment.supabaseAnonKey);
  }

  // ---- STATS GLOBALES ----
  async getGlobalStats(): Promise<{
    totalEmpresas: number; totalRutas: number; totalBuses: number;
    totalChoferes: number; totalPasajeros: number; busesEnRuta: number;
    totalCalificaciones: number; promedioGeneral: number;
  }> {
    const [empresas, rutas, buses, choferes, pasajeros, calificaciones] = await Promise.all([
      this.supabase.from('empresas').select('id'),
      this.supabase.from('rutas').select('id'),
      this.supabase.from('buses').select('id, estado'),
      this.supabase.from('profiles').select('id').eq('rol', 'chofer'),
      this.supabase.from('profiles').select('id').eq('rol', 'pasajero'),
      this.supabase.from('calificaciones').select('estrellas'),
    ]);

    const busData = (buses.data || []) as { id: string; estado: string }[];
    const calData = (calificaciones.data || []) as { estrellas: number }[];
    const avgRating = calData.length > 0
      ? calData.reduce((s, c) => s + c.estrellas, 0) / calData.length
      : 0;

    return {
      totalEmpresas: (empresas.data || []).length,
      totalRutas: (rutas.data || []).length,
      totalBuses: busData.length,
      totalChoferes: (choferes.data || []).length,
      totalPasajeros: (pasajeros.data || []).length,
      busesEnRuta: busData.filter(b => b.estado === 'en_ruta').length,
      totalCalificaciones: calData.length,
      promedioGeneral: Math.round(avgRating * 10) / 10,
    };
  }

  // ---- EMPRESAS ----
  async getEmpresas(): Promise<Empresa[]> {
    const { data, error } = await this.supabase.from('empresas').select('*').order('nombre');
    if (error) throw error;
    return data as Empresa[];
  }

  async createEmpresa(empresa: Partial<Empresa>): Promise<Empresa> {
    const { data, error } = await this.supabase.from('empresas').insert(empresa).select().single();
    if (error) throw error;
    return data as Empresa;
  }

  async updateEmpresa(id: string, updates: Partial<Empresa>): Promise<Empresa> {
    const { data, error } = await this.supabase.from('empresas').update(updates).eq('id', id).select().single();
    if (error) throw error;
    return data as Empresa;
  }

  async deleteEmpresa(id: string): Promise<void> {
    const { error } = await this.supabase.from('empresas').delete().eq('id', id);
    if (error) throw error;
  }

  // ---- RUTAS (todas) ----
  async getAllRutas(): Promise<Ruta[]> {
    const { data, error } = await this.supabase
      .from('rutas')
      .select('*, empresa:empresas(nombre)')
      .order('nombre');
    if (error) throw error;
    return data as Ruta[];
  }

  async createRuta(ruta: Partial<Ruta>): Promise<Ruta> {
    const { data, error } = await this.supabase.from('rutas').insert(ruta).select().single();
    if (error) throw error;
    return data as Ruta;
  }

  async updateRuta(id: string, updates: Partial<Ruta>): Promise<Ruta> {
    const { data, error } = await this.supabase.from('rutas').update(updates).eq('id', id).select().single();
    if (error) throw error;
    return data as Ruta;
  }

  async deleteRuta(id: string): Promise<void> {
    const { error } = await this.supabase.from('rutas').delete().eq('id', id);
    if (error) throw error;
  }

  // ---- BUSES (todos) ----
  async getAllBuses(): Promise<Bus[]> {
    const { data, error } = await this.supabase
      .from('buses')
      .select('*, ruta:rutas(nombre, color), empresa:empresas(nombre), chofer:profiles(nombre_completo)')
      .order('placa');
    if (error) throw error;
    return data as Bus[];
  }

  async updateBus(id: string, updates: Partial<Bus>): Promise<void> {
    const { error } = await this.supabase.from('buses').update(updates).eq('id', id);
    if (error) throw error;
  }

  async deleteBus(id: string): Promise<void> {
    const { error } = await this.supabase.from('buses').delete().eq('id', id);
    if (error) throw error;
  }

  // ---- USUARIOS (todos) ----
  async getAllUsers(): Promise<UserProfile[]> {
    const { data, error } = await this.supabase.from('profiles').select('*').order('created_at', { ascending: false });
    if (error) throw error;
    return data as UserProfile[];
  }

  async updateUserRole(userId: string, rol: string, empresaId?: string | null): Promise<void> {
    const updates: any = { rol };
    if (empresaId !== undefined) updates.empresa_id = empresaId;
    const { error } = await this.supabase.from('profiles').update(updates).eq('id', userId);
    if (error) throw error;
  }

  async updateUserStatus(userId: string, estado: string): Promise<void> {
    const { error } = await this.supabase.from('profiles').update({ estado }).eq('id', userId);
    if (error) throw error;
  }

  // ---- CALIFICACIONES ----
  async getAllCalificaciones(): Promise<Calificacion[]> {
    const { data, error } = await this.supabase
      .from('calificaciones')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(100);
    if (error) throw error;
    return data as Calificacion[];
  }

  async deleteCalificacion(id: string): Promise<void> {
    const { error } = await this.supabase.from('calificaciones').delete().eq('id', id);
    if (error) throw error;
  }

  // ---- HORARIOS ----
  async getAllHorarios(): Promise<Horario[]> {
    const { data, error } = await this.supabase.from('horarios').select('*');
    if (error) throw error;
    return data as Horario[];
  }

  // ---- PARADAS ----
  async getParadas(rutaId: string): Promise<Parada[]> {
    const { data, error } = await this.supabase.from('paradas').select('*').eq('ruta_id', rutaId).order('orden');
    if (error) throw error;
    return data as Parada[];
  }

  async createParada(parada: Partial<Parada>): Promise<void> {
    const { error } = await this.supabase.from('paradas').insert(parada);
    if (error) throw error;
  }

  async deleteParada(id: string): Promise<void> {
    const { error } = await this.supabase.from('paradas').delete().eq('id', id);
    if (error) throw error;
  }
}
