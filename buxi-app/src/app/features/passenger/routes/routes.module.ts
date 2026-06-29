import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { RouterModule } from '@angular/router';
import { RoutesPage } from './routes.page';

@NgModule({
  declarations: [RoutesPage],
  imports: [
    CommonModule,
    IonicModule,
    RouterModule.forChild([{ path: '', component: RoutesPage }]),
  ],
})
export class RoutesPageModule {}
