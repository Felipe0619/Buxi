import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AlertController, LoadingController, ToastController } from '@ionic/angular';
import { SupabaseService } from '../../../core/services/supabase.service';
import { UserProfile } from '../../../core/models/user-profile.model';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.page.html',
  styleUrls: ['./profile.page.scss'],
  standalone: false,
})
export class ProfilePage implements OnInit {
  profile: UserProfile | null = null;
  profileForm: FormGroup;
  loading = true;
  editing = false;

  provincias = [
    'San José', 'Alajuela', 'Cartago', 'Heredia',
    'Guanacaste', 'Puntarenas', 'Limón',
  ];

  constructor(
    private fb: FormBuilder,
    private supabase: SupabaseService,
    private router: Router,
    private alertCtrl: AlertController,
    private loadingCtrl: LoadingController,
    private toastCtrl: ToastController,
  ) {
    this.profileForm = this.fb.group({
      nombre_completo: ['', [Validators.required, Validators.minLength(3)]],
      telefono: [''],
      provincia: [''],
    });
  }

  async ngOnInit() {
    try {
      this.profile = await this.supabase.getProfile();
      if (this.profile) {
        this.profileForm.patchValue({
          nombre_completo: this.profile.nombre_completo,
          telefono: this.profile.telefono || '',
          provincia: this.profile.provincia || '',
        });
      }
    } catch {
    } finally {
      this.loading = false;
    }
  }

  toggleEdit() {
    this.editing = !this.editing;
  }

  async onSave() {
    if (this.profileForm.invalid) {
      this.profileForm.markAllAsTouched();
      return;
    }

    const loading = await this.loadingCtrl.create({ message: 'Guardando...' });
    await loading.present();

    try {
      const updates = this.profileForm.value;
      this.profile = await this.supabase.updateProfile(updates);
      this.editing = false;

      const toast = await this.toastCtrl.create({
        message: 'Perfil actualizado',
        duration: 2000,
        color: 'success',
        position: 'top',
      });
      await toast.present();
    } catch {
      const toast = await this.toastCtrl.create({
        message: 'Error al guardar los cambios',
        duration: 3000,
        color: 'danger',
        position: 'top',
      });
      await toast.present();
    } finally {
      await loading.dismiss();
    }
  }

  async onLogout() {
    const alert = await this.alertCtrl.create({
      header: 'Cerrar sesión',
      message: '¿Estás seguro que deseas cerrar sesión?',
      buttons: [
        { text: 'Cancelar', role: 'cancel' },
        {
          text: 'Cerrar sesión',
          role: 'confirm',
          handler: async () => {
            await this.supabase.signOut();
            this.router.navigate(['/auth/login'], { replaceUrl: true });
          },
        },
      ],
    });
    await alert.present();
  }
}
