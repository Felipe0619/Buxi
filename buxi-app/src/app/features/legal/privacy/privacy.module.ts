import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { RouterModule } from '@angular/router';
import { PrivacyPage } from './privacy.page';

@NgModule({
  declarations: [PrivacyPage],
  imports: [
    CommonModule,
    IonicModule,
    RouterModule.forChild([{ path: '', component: PrivacyPage }]),
  ],
})
export class PrivacyPageModule {}
