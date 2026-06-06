import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var auth: AuthenticationManager
    @StateObject private var login: LoginViewModel
    @StateObject private var register: RegisterViewModel
    @State private var isRegister = false
    @State private var showForgot = false

    init() {
        let placeholder = AuthenticationManager(persistence: PersistenceController())
        _login = StateObject(wrappedValue: LoginViewModel(auth: placeholder))
        _register = StateObject(wrappedValue: RegisterViewModel(auth: placeholder))
    }

    var body: some View {
        VStack(spacing: 18) {
            Text(isRegister ? "Create your account" : "Welcome back").font(.largeTitle.bold()).foregroundStyle(.white).frame(maxWidth: .infinity, alignment: .leading)
            TextField("Email", text: isRegister ? $register.email : $login.email).textInputAutocapitalization(.never).keyboardType(.emailAddress).textFieldStyle(.roundedBorder)
            if isRegister { TextField("Display name", text: $register.displayName).textFieldStyle(.roundedBorder) }
            SecureField("Password", text: isRegister ? $register.password : $login.password).textFieldStyle(.roundedBorder)
            if isRegister {
                PasswordStrengthView(strength: register.strength)
                SecureField("Confirm password", text: $register.confirmPassword).textFieldStyle(.roundedBorder)
            }
            Button(isRegister ? "Create Account" : "Sign in") {
                if isRegister { Task { await auth.register(email: register.email, password: register.password, displayName: register.displayName) } }
                else { Task { await auth.signIn(email: login.email, password: login.password) } }
            }.thereButtonStyle()
            Button(isRegister ? "Already have an account? Sign in" : "New email? Create account") { isRegister.toggle() }.foregroundStyle(ColorPalette.accent)
            if !isRegister { Button("Forgot Password?") { showForgot = true }.font(.footnote).foregroundStyle(ColorPalette.textSecondary) }
            Spacer()
        }
        .padding().background(Color.black.ignoresSafeArea()).sheet(isPresented: $showForgot) { ForgotPasswordView() }
    }
}

struct PasswordStrengthView: View {
    let strength: PasswordStrength
    var body: some View {
        HStack { Text("Password strength: \(strength.rawValue)"); Spacer(); Capsule().fill(strength == .strong ? ColorPalette.accent : strength == .medium ? ColorPalette.accentAlt : .red).frame(width: 88, height: 6) }
            .font(.caption).foregroundStyle(ColorPalette.textSecondary)
    }
}

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View { NavigationStack { VStack(spacing: 16) { Text("Reset Password").font(.title.bold()); TextField("Email", text: $email).textFieldStyle(.roundedBorder); SecureField("New password", text: $password).textFieldStyle(.roundedBorder); Button("Save New Password") { dismiss() }.thereButtonStyle(); Spacer() }.padding().background(Color.black).foregroundStyle(.white) } }
}

typealias RegisterView = LoginView
typealias PasswordCreationView = LoginView
struct AuthButtonsView: View { var body: some View { EmptyView() } }
