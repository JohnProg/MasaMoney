//
//  Strings.swift
//  MasaMoney
//
//  Created by Maria Lopez on 04/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

enum CountryCode: String {
    case es
    case en
}

struct Strings {
    //check the country code in the system
    private static var userLanguage = Locale.current.languageCode ?? "en"
    //if the language is not supported set english by default
    private static var language: CountryCode {
        if let code = CountryCode.init(rawValue: Strings.userLanguage) {
            return code
        } else {
            return CountryCode(rawValue: "en")!
        }
    }
    
    // Each var return string depending on country code
    static var splashWelcome: String {
        switch language {
        case .en:
            return "Don't let your money hide from you"
        case .es:
            return "Que no se te escape el dinero"
        }
    }
    
    static var loading: String {
        switch language {
        case .en:
            return "Loading..."
        case .es:
            return "Cargando..."
        }
    }
    
    static var loggingFacebook: String {
        switch language {
        case .en:
            return "Logging in with Facebook..."
        case .es:
            return "Entrando en Facebook..."
        }
    }
    
    static var loggingGoogle: String {
        switch language {
        case .en:
            return "Logging in with Google..."
        case .es:
            return "Entrando en Google..."
        }
    }
    
    static var failedFacebook: String {
        switch language {
        case .en:
            return "Failed to get Facebook user with error:"
        case .es:
            return "Error al conseguir usuario de facebook, error:"
        }
    }
    
    static var cancelFacebook: String {
        switch language {
        case .en:
            return "Canceled getting Facebook user"
        case .es:
            return "Cancelado el inicio con Facebook"
        }
    }
    
    static var errorSignUp: String {
        switch language {
        case .en:
            return "Sign up error"
        case .es:
            return "Error al iniciar sesión"
        }
    }
    
    static var balance: String {
        switch language {
        case .en:
            return "Balance"
        case .es:
            return "Ingresos"
        }
    }
    
    static var spent: String {
        switch language {
        case .en:
            return "Spent"
        case .es:
            return "Gastos"
        }
    }
    
    static var nameAccount: String {
        switch language {
        case .en:
            return "Name of the account"
        case .es:
            return "Nombre de la cuenta"
        }
    }
    
    static var amountAccount: String {
        switch language {
        case .en:
            return "Amount"
        case .es:
            return "Cantidad"
        }
    }
    
    static var newIncomeAc: String {
        switch language {
        case .en:
            return "Create income account"
        case .es:
            return "Crear una cuenta de ingresos"
        }
    }
    
    static var newOutcomeAc: String {
        switch language {
        case .en:
            return "Create outcome account"
        case .es:
            return "Crear una cuenta de gastos"
        }
    }
    
    static var emptyField: String {
        switch language {
        case .en:
            return "Empty field"
        case .es:
            return "Campo vacio"
        }
    }
    
    static var noName: String {
        switch language {
        case .en:
            return "There is no name for the new account"
        case .es:
            return "No hay nombre para la cuenta nueva"
        }
    }
    
    static var noAmountNewAccount: String {
        switch language {
        case .en:
            return "There is no amount for the new account"
        case .es:
            return "No hay cantidad para la cuenta nueva"
        }
    }
    
    static var noAmount: String {
        switch language {
        case .en:
            return "Please, introduce an amount"
        case .es:
            return "Por favor, introduzca una cantidad"
        }
    }
    
    static var cancel: String {
        switch language {
        case .en:
            return "Cancel"
        case .es:
            return "Cancelar"
        }
    }
    
    static var icon: String {
        switch language {
        case .en:
            return "Icon"
        case .es:
            return "Icono"
        }
    }
    
    static var iconMessage: String {
        switch language {
        case .en:
            return "Choose your icon image"
        case .es:
            return "Elige el icono para la cuenta"
        }
    }
    
    static var done: String {
        switch language {
        case .en:
            return "Done"
        case .es:
            return "Hecho"
        }
    }
    
    static var english: String {
        switch language {
        case .en:
            return "English"
        case .es:
            return "Ingles"
        }
    }
    
    static var spanish: String {
        switch language {
        case .en:
            return "Spanish"
        case .es:
            return "Español"
        }
    }
    
    static var addIncomeTitle: String {
        switch language {
        case .en:
            return "Select account where money comes to"
        case .es:
            return "Selecciona la cuenta donde se ingresa el dinero"
        }
    }
    
    static var income: String {
        switch language {
        case .en:
            return "Income"
        case .es:
            return "Ingreso"
        }
    }
    
    static var wallet: String {
        switch language {
        case .en:
            return "Wallet"
        case .es:
            return "Cartera"
        }
    }
    
    static var bank: String {
        switch language {
        case .en:
            return "Bank"
        case .es:
            return "Banco"
        }
    }
    
    static var groceries: String {
        switch language {
        case .en:
            return "Groceries"
        case .es:
            return "Provisiones"
        }
    }
    
    static var atm: String {
        switch language {
        case .en:
            return "ATM"
        case .es:
            return "Cajeros automaticos"
        }
    }
    
    static var perfil: String {
        switch language {
        case .en:
            return "Profile"
        case .es:
            return "Perfil"
        }
    }
    
    static var logout: String {
        switch language {
        case .en:
            return "Log out"
        case .es:
            return "Cerrar sesion"
        }
    }
    
    static var contact: String {
        switch language {
        case .en:
            return "Contact"
        case .es:
            return "Contacto"
        }
    }
    
    static var back: String {
        switch language {
        case .en:
            return "Back"
        case .es:
            return "Atras"
        }
    }
    
    static var edit: String {
        switch language {
        case .en:
            return "Edit"
        case .es:
            return "Editar"
        }
    }
    
    static var delete: String {
        switch language {
        case .en:
            return "Delete"
        case .es:
            return "Eliminar"
        }
    }
    
    static var deleteMessage: String {
        switch language {
        case .en:
            return "Are you sure that you want to eliminate this account?"
        case .es:
            return "Esta seguro de que quiere eliminar esta cuenta?"
        }
    }
    
    static var deleteAccount: String {
        switch language {
        case .en:
            return "Delete account"
        case .es:
            return "Eliminar cuenta"
        }
    }
    
    static var comment: String {
        switch language {
        case .en:
            return "Comment"
        case .es:
            return "Comentario"
        }
    }
    
    static var picture: String {
        switch language {
        case .en:
            return "Attach picture"
        case .es:
            return "Añadir foto"
        }
    }
    
    static var pictureGallery: String {
        switch language {
        case .en:
            return "Take a picture from gallery"
        case .es:
            return "Elegir una foto de la galeria"
        }
    }
    
    static var pictureCamera: String {
        switch language {
        case .en:
            return "Take a picture from camera"
        case .es:
            return "Hacer foto desde la camara"
        }
    }
    
    
    static var pictureError: String {
        switch language {
        case .en:
            return "Error"
        case .es:
            return "Error"
        }
    }

}
