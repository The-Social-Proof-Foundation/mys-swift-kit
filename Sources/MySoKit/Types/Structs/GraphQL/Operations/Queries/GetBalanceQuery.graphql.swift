// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetBalanceQuery: GraphQLQuery {
  public static let operationName: String = "getBalance"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query getBalance($owner: MysAddress!, $type: String = "0x2::mys::MYS") { address(address: $owner) { __typename balance(type: $type) { __typename coinType { __typename repr } coinObjectCount totalBalance } } }"#
    ))

  public var owner: MySoAddressApollo
  public var type: GraphQLNullable<String>

  public init(
    owner: MySoAddressApollo,
    type: GraphQLNullable<String> = "0x2::mys::MYS"
  ) {
    self.owner = owner
    self.type = type
  }

  public var __variables: Variables? { [
    "owner": owner,
    "type": type
  ] }

  public struct Data: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("address", Address?.self, arguments: ["address": .variable("owner")])
    ] }

    /// Look-up an Account by its MySoAddressApollo.
    public var address: Address? { __data["address"] }

    /// Address
    ///
    /// Parent Type: `Address`
    public struct Address: MySoKit.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Address }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("balance", Balance?.self, arguments: ["type": .variable("type")])
      ] }

      /// Total balance of all coins with marker type owned by this address. If type is not supplied,
      /// it defaults to `0x2::mys::MYS`.
      public var balance: Balance? { __data["balance"] }

      /// Address.Balance
      ///
      /// Parent Type: `Balance`
      public struct Balance: MySoKit.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Balance }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("coinType", CoinType.self),
          .field("coinObjectCount", MySoKit.UInt53Apollo?.self),
          .field("totalBalance", MySoKit.BigIntApollo?.self)
        ] }

        /// Coin type for the balance, such as 0x2::mys::MYS
        public var coinType: CoinType { __data["coinType"] }
        /// How many coins of this type constitute the balance
        public var coinObjectCount: MySoKit.UInt53Apollo? { __data["coinObjectCount"] }
        /// Total balance across all coin objects of the coin type
        public var totalBalance: MySoKit.BigIntApollo? { __data["totalBalance"] }

        /// Address.Balance.CoinType
        ///
        /// Parent Type: `MoveType`
        public struct CoinType: MySoKit.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveType }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("repr", String.self)
          ] }

          /// Flat representation of the type signature, as a displayable string.
          public var repr: String { __data["repr"] }
        }
      }
    }
  }
}
