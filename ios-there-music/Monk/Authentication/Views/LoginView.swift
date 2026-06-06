import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var auth: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var confirmationCode = ""
    @State private var isRegister = false
    @State private var showCodeVerification = false
    @State private var showForgot = false
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Text(isRegister ? "Создайте аккаунт" : "С возвращением")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Email field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.caption)
                            .foregroundStyle(ColorPalette.textSecondary)
                        TextField("email@example.com", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding(13)
                            .background(ColorPalette.elevated, in: RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(.white)
                    }

                    if isRegister {
                        // Display name
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Имя")
                                .font(.caption)
                                .foregroundStyle(ColorPalette.textSecondary)
                            TextField("Как вас зовут?", text: $displayName)
                                .padding(13)
                                .background(ColorPalette.elevated, in: RoundedRectangle(cornerRadius: 12))
                                .foregroundStyle(.white)
                        }
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Пароль")
                            .font(.caption)
                            .foregroundStyle(ColorPalette.textSecondary)
                        SecureField("Введите пароль", text: $password)
                            .padding(13)
                            .background(ColorPalette.elevated, in: RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(.white)
                    }

                    if isRegister {
                        // Confirm password
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Подтвердите пароль")
                                .font(.caption)
                                .foregroundStyle(ColorPalette.textSecondary)
                            SecureField("Повторите пароль", text: .constant(""))
                                .padding(13)
                                .background(ColorPalette.elevated, in: RoundedRectangle(cornerRadius: 12))
                                .foregroundStyle(.white)
                        }
                    }

                    // Action button
                    Button {
                        if isRegister {
                            showCodeVerification = true
                        } else {
                            Task {
                                isLoading = true
                                await auth.signIn(email: email, password: password)
                                isLoading = false
                            }
                        }
                    } label: {
                        if isLoading {
                            ProgressView().tint(.black)
                        } else {
                            Text(isRegister ? "Зарегистрироваться" : "Войти")
                        }
                    }
                    .thereButtonStyle()
                    .disabled(email.isEmpty || password.isEmpty)

                    // Toggle register/login
                    Button {
                        isRegister.toggle()
                    } label: {
                        Text(isRegister ? "Уже есть аккаунт? Войти" : "Нет аккаунта? Регистрация")
                            .font(.subheadline)
                    }
                    .foregroundStyle(ColorPalette.accent)

                    if !isRegister {
                        Button("Забыли пароль?") { showForgot = true }
                            .font(.footnote)
                            .foregroundStyle(ColorPalette.textSecondary)
                    }

                    Spacer()
                }
                .padding(20)
            }
        }
        .sheet(isPresented: $showCodeVerification) {
            CodeVerificationView(email: email, displayName: displayName, password: password)
        }
        .sheet(isPresented: $showForgot) {
            ForgotPasswordView()
        }
    }
}

// MARK: - Email Code Verification

struct CodeVerificationView: View {
    let email: String
    let displayName: String
    let password: String
    @EnvironmentObject private var auth: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    @State private var code = ""
    @State private var generatedCode = ""
    @State private var isVerifying = false
    @State private var errorMessage = ""
    @State private var timeRemaining = 60
    @State private var canResend = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer().frame(height: 40)

                Image(systemName: "envelope.badge.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(ColorPalette.accent)

                Text("Подтвердите email")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text("Мы отправили код на \(email)")
                    .font(.subheadline)
                    .foregroundStyle(ColorPalette.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                // Code input — 6 digit style
                HStack(spacing: 8) {
                    ForEach(0..<6, id: \.self) { index in
                        TextField("", text: digitBinding(for: index))
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)
                            .frame(width: 46, height: 52)
                            .background(ColorPalette.elevated, in: RoundedRectangle(cornerRadius: 10))
                            .foregroundStyle(.white)
                            .keyboardType(.numberPad)
                    }
                }
                .padding(.horizontal, 24)

                // Verify button
                Button {
                    verifyCode()
                } label: {
                    if isVerifying {
                        ProgressView().tint(.black)
                    } else {
                        Text("Подтвердить")
                    }
                }
                .thereButtonStyle()
                .disabled(code.count < 6)

                // Resend
                if canResend {
                    Button("Отправить код повторно") {
                        sendCode()
                        timeRemaining = 60
                        canResend = false
                    }
                    .foregroundStyle(ColorPalette.accent)
                    .font(.subheadline)
                } else {
                    Text("Повторная отправка через \(timeRemaining)с")
                        .font(.caption)
                        .foregroundStyle(ColorPalette.textSecondary)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            sendCode()
            startTimer()
        }
    }

    private func digitBinding(for index: Int) -> Binding<String> {
        Binding(
            get: {
                let chars = Array(code)
                return index < chars.count ? String(chars[index]) : ""
            },
            set: { newValue in
                let chars = Array(code)
                var newCode = chars.map(String.init)
                if index < newCode.count {
                    if newValue.isEmpty {
                        newCode.remove(at: index)
                    } else {
                        newCode[index] = newValue
                    }
                } else if !newValue.isEmpty {
                    newCode.append(newValue)
                }
                code = newCode.joined()
            }
        )
    }

    private func sendCode() {
        generatedCode = String(format: "%06d", Int.random(in: 0..<999999))
        // In production, send via email API. For now, store and auto-accept.
        print("Verification code for \(email): \(generatedCode)")
    }

    private func verifyCode() {
        isVerifying = true
        // Auto-accept any 6-digit code for now (production: compare with sent code)
        Task {
            try? await Task.sleep(for: .milliseconds(800))
            await auth.register(email: email, password: password, displayName: displayName)
            isVerifying = false
            dismiss()
        }
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                canResend = true
                timer.invalidate()
            }
        }
    }
}

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Сброс пароля")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding(13)
                        .background(ColorPalette.elevated, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                    SecureField("Новый пароль", text: $password)
                        .padding(13)
                        .background(ColorPalette.elevated, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                    Button("Сохранить новый пароль") { dismiss() }
                        .thereButtonStyle()
                    Spacer()
                }
                .padding()
            }
        }
    }
}

typealias RegisterView = LoginView
typealias PasswordCreationView = LoginView
struct AuthButtonsView: View { var body: some View { EmptyView() } }
