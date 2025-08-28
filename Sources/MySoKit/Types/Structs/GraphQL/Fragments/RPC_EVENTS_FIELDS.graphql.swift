// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct RPC_EVENTS_FIELDS: MySoKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment RPC_EVENTS_FIELDS on Event { __typename sendingModule { __typename package { __typename address } name } sender { __typename address } contents { __typename type { __typename repr } json bcs } timestamp }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Event }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("sendingModule", SendingModule?.self),
    .field("sender", Sender?.self),
    .field("contents", Contents.self),
    .field("timestamp", MySoKit.DateTimeApollo?.self)
  ] }

  /// The Move module containing some function that when called by
  /// a programmable transaction block (PTB) emitted this event.
  /// For example, if a PTB invokes A::m1::foo, which internally
  /// calls A::m2::emit_event to emit an event,
  /// the sending module would be A::m1.
  public var sendingModule: SendingModule? { __data["sendingModule"] }
  /// Address of the sender of the event
  public var sender: Sender? { __data["sender"] }
  /// The event's contents as a Move value.
  public var contents: Contents { __data["contents"] }
  /// UTC timestamp in milliseconds since epoch (1/1/1970)
  public var timestamp: MySoKit.DateTimeApollo? { __data["timestamp"] }

  /// SendingModule
  ///
  /// Parent Type: `MoveModule`
  public struct SendingModule: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveModule }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("package", Package.self),
      .field("name", String.self)
    ] }

    /// The package that this Move module was defined in
    public var package: Package { __data["package"] }
    /// The module's (unqualified) name.
    public var name: String { __data["name"] }

    /// SendingModule.Package
    ///
    /// Parent Type: `MovePackage`
    public struct Package: MySoKit.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MovePackage }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("address", MySoKit.MySoAddressApollo.self)
      ] }

      public var address: MySoKit.MySoAddressApollo { __data["address"] }
    }
  }

  /// Sender
  ///
  /// Parent Type: `Address`
  public struct Sender: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Address }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("address", MySoKit.MySoAddressApollo.self)
    ] }

    public var address: MySoKit.MySoAddressApollo { __data["address"] }
  }

  /// Contents
  ///
  /// Parent Type: `MoveValue`
  public struct Contents: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveValue }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("type", Type_SelectionSet.self),
      .field("json", MySoKit.JSONApollo.self),
      .field("bcs", MySoKit.Base64Apollo.self)
    ] }

    /// The value's Move type.
    public var type: Type_SelectionSet { __data["type"] }
    /// Representation of a Move value in JSON, where:
    ///
    /// - Addresses, IDs, and UIDs are represented in canonical form, as JSON strings.
    /// - Bools are represented by JSON boolean literals.
    /// - u8, u16, and u32 are represented as JSON numbers.
    /// - u64, u128, and u256 are represented as JSON strings.
    /// - Vectors are represented by JSON arrays.
    /// - Structs are represented by JSON objects.
    /// - Empty optional values are represented by `null`.
    ///
    /// This form is offered as a less verbose convenience in cases where the layout of the type is
    /// known by the client.
    public var json: MySoKit.JSONApollo { __data["json"] }
    /// The BCS representation of this value, Base64 encoded.
    public var bcs: MySoKit.Base64Apollo { __data["bcs"] }

    /// Contents.Type_SelectionSet
    ///
    /// Parent Type: `MoveType`
    public struct Type_SelectionSet: MySoKit.SelectionSet {
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
