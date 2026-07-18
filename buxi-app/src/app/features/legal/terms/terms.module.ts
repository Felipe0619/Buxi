import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { RouterModule } from '@angular/router';
import { TermsPage } from './terms.page';

@NgModule({
  declarations: [TermsPage],
  imports: [
    CommonModule,
    IonicModule,
    RouterModule.forChild([{ path: '', component: TermsPage }]),
  ],
})
export class TermsPageModule {}
