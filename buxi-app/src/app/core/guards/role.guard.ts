import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, Router } from '@angular/router';
import { SupabaseService } from '../services/supabase.service';

@Injectable({ providedIn: 'root' })
export class RoleGuard implements CanActivate {
  constructor(private supabase: SupabaseService, private router: Router) {}

  async canActivate(route: ActivatedRouteSnapshot): Promise<boolean> {
    const session = this.supabase.currentSession;
    if (!session) {
      this.router.navigate(['/auth/login']);
      return false;
    }

    const allowedRoles = route.data['roles'] as string[];
    if (!allowedRoles) return true;

    try {
      const profile = await this.supabase.getProfile();
      if (profile && allowedRoles.includes(profile.rol)) return true;
    } catch {}

    this.router.navigate(['/passenger/map']);
    return false;
  }
}
