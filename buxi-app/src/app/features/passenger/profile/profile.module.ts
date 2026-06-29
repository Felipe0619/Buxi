import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { RouterModule } from '@angular/router';
import { ProfilePage } from './profile.page';

@NgModule({
  declarations: [ProfilePage],
  imports: [
    CommonModule,
    ReactiveFormsModule,
    IonicModule,
    RouterModule.forChild([{ path: '', component: ProfilePage }]),
  ],
})
export class ProfilePageModule {}
