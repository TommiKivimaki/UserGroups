/// Defined user groups
/// You could extend this in your app to give meaning for groups
/// ```
/// extension UserGroups {
///    public static var admin = {
///        group0
///    }
/// ```
public struct UserGroups {
    public static let group0 = 0
    public static let group1 = 1
    public static let group2 = 2

    public static var admin: Int {
        group0
    }
}
