import { NgModule } from '@angular/core';
import { RouterModule, RouterOutlet, Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { CommonModule } from '@angular/common';
import { InputTextModule } from 'primeng/inputtext';
import { IconFieldModule } from 'primeng/iconfield';
import { InputIconModule } from 'primeng/inputicon';
import { PasswordModule } from 'primeng/password';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { ButtonModule } from 'primeng/button';

const routes: Routes = [
    {
        path: '',
        component: LoginComponent
    }
];

@NgModule({
    declarations: [
        LoginComponent
    ],
    imports: [RouterModule.forChild(routes),
        CommonModule,
        RouterOutlet,
        InputTextModule,
        IconFieldModule,
        InputIconModule,
        PasswordModule,
        FormsModule,
        ReactiveFormsModule,
        ButtonModule
    ],
    exports: [RouterModule]
})


export class LoginModule { }
