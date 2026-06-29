import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { SupabaseService } from '../../../core/services/supabase.service';

@Component({
  selector: 'app-splash',
  templateUrl: './splash.page.html',
  styleUrls: ['./splash.page.scss'],
  standalone: false,
})
export class SplashPage implements OnInit {
  constructor(private router: Router, private supabase: SupabaseService) {}

  ngOnInit() {
    setTimeout(async () => {
      const session = this.supabase.currentSession;
      if (session) {
        try {
          const profile = await this.supabase.getProfile();
          if (profile) {
            switch (profile.rol) {
              case 'admin_jirb':
                this.router.navigate(['/admin/dashboard'], { replaceUrl: true });
                return;
              case 'admin_empresa':
                this.router.navigate(['/empresa/dashboard'], { replaceUrl: true });
                return;
              case 'chofer':
                this.router.navigate(['/chofer/home'], { replaceUrl: true });
                return;
            }
          }
        } catch {}
        this.router.navigate(['/passenger/map'], { replaceUrl: true });
      } else {
        this.router.navigate(['/auth/login'], { replaceUrl: true });
      }
    }, 2500);
  }
}
