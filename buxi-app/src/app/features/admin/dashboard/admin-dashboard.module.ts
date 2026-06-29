import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { RouterModule } from '@angular/router';
import { AdminDashboardPage } from './admin-dashboard.page';

@NgModule({
  declarations: [AdminDashboardPage],
  imports: [
    CommonModule,
    IonicModule,
    RouterModule.forChild([{ path: '', component: AdminDashboardPage }]),
  ],
})
export class AdminDashboardPageModule {}
