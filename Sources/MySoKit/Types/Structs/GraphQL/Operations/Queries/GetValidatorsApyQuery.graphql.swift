// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetValidatorsApyQuery: GraphQLQuery {
  public static let operationName: String = "getValidatorsApy"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query getValidatorsApy { epoch { __typename epochId validatorSet { __typename activeValidators { __typename pageInfo { __typename hasNextPage endCursor } nodes { __typename address { __typename address } apy } } } } }"#
    ))

  public init() {}

  public struct Data: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("epoch", Epoch?.self)
    ] }

    /// Fetch epoch information by ID (defaults to the latest epoch).
    public var epoch: Epoch? { __data["epoch"] }

    /// Epoch
    ///
    /// Parent Type: `Epoch`
    public struct Epoch: MySoKit.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Epoch }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("epochId", MySoKit.UInt53Apollo.self),
        .field("validatorSet", ValidatorSet?.self)
      ] }

      /// The epoch's id as a sequence number that starts at 0 and is incremented by one at every epoch change.
      public var epochId: MySoKit.UInt53Apollo { __data["epochId"] }
      /// Validator related properties, including the active validators.
      public var validatorSet: ValidatorSet? { __data["validatorSet"] }

      /// Epoch.ValidatorSet
      ///
      /// Parent Type: `ValidatorSet`
      public struct ValidatorSet: MySoKit.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.ValidatorSet }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("activeValidators", ActiveValidators.self)
        ] }

        /// The current set of active validators.
        public var activeValidators: ActiveValidators { __data["activeValidators"] }

        /// Epoch.ValidatorSet.ActiveValidators
        ///
        /// Parent Type: `ValidatorConnection`
        public struct ActiveValidators: MySoKit.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.ValidatorConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("pageInfo", PageInfo.self),
            .field("nodes", [Node].self)
          ] }

          /// Information to aid in pagination.
          public var pageInfo: PageInfo { __data["pageInfo"] }
          /// A list of nodes.
          public var nodes: [Node] { __data["nodes"] }

          /// Epoch.ValidatorSet.ActiveValidators.PageInfo
          ///
          /// Parent Type: `PageInfo`
          public struct PageInfo: MySoKit.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.PageInfo }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("hasNextPage", Bool.self),
              .field("endCursor", String?.self)
            ] }

            /// When paginating forwards, are there more items?
            public var hasNextPage: Bool { __data["hasNextPage"] }
            /// When paginating forwards, the cursor to continue.
            public var endCursor: String? { __data["endCursor"] }
          }

          /// Epoch.ValidatorSet.ActiveValidators.Node
          ///
          /// Parent Type: `Validator`
          public struct Node: MySoKit.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Validator }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("address", Address.self),
              .field("apy", Int?.self)
            ] }

            /// The validator's address.
            public var address: Address { __data["address"] }
            /// The APY of this validator in basis points.
            /// To get the APY in percentage, divide by 100.
            public var apy: Int? { __data["apy"] }

            /// Epoch.ValidatorSet.ActiveValidators.Node.Address
            ///
            /// Parent Type: `Address`
            public struct Address: MySoKit.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Address }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("address", MySoKit.MySoAddressApollo.self)
              ] }

              public var address: MySoKit.MySoAddressApollo { __data["address"] }
            }
          }
        }
      }
    }
  }
}
