// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ResolveNameServiceAddressQuery: GraphQLQuery {
  public static let operationName: String = "resolveNameServiceAddress"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query resolveNameServiceAddress($domain: String!) { resolveSuinsAddress(domain: $domain) { __typename address } }"#
    ))

  public var domain: String

  public init(domain: String) {
    self.domain = domain
  }

  public var __variables: Variables? { ["domain": domain] }

  public struct Data: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("resolveSuinsAddress", ResolveSuinsAddress?.self, arguments: ["domain": .variable("domain")])
    ] }

    /// Resolves a SuiNS `domain` name to an address, if it has been bound.
    public var resolveSuinsAddress: ResolveSuinsAddress? { __data["resolveSuinsAddress"] }

    /// ResolveSuinsAddress
    ///
    /// Parent Type: `Address`
    public struct ResolveSuinsAddress: MySoKit.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Address }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("address", MySoKit.SuiAddressApollo.self)
      ] }

      public var address: MySoKit.SuiAddressApollo { __data["address"] }
    }
  }
}
