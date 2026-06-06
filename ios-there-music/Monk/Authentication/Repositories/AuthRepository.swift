import Foundation

struct AuthRepository {
    let auth: AuthenticationManager
    func signOut() { auth.signOut() }
}
