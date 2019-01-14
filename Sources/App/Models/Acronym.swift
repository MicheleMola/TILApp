import Vapor
import FluentPostgreSQL

final class Acronym: Codable {
  var id: Int?
  var short: String
  var long: String
  var userID: User.ID
  
  init(short: String, long: String, userID: User.ID) {
    self.short = short
    self.long = long
    self.userID = userID
  }
}

extension Acronym: PostgreSQLModel {}
extension Acronym: Content {}
extension Acronym: Parameter {}

extension Acronym {
  var user: Parent<Acronym, User> {
    return parent(\.userID)
  }
  
  var categories: Siblings<Acronym, Category, AcronymCategoryPivot> {
    return siblings()
  }
}

extension Acronym: Migration {
  // 2
  static func prepare(
    on connection: PostgreSQLConnection
    ) -> Future<Void> {
    // 3
    return Database.create(self, on: connection) { builder in
      // 4
      try addProperties(to: builder)
      // 5
      builder.reference(from: \.userID, to: \User.id)
    }
  }
}
